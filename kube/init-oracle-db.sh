#!/bin/bash
set -e

echo "🔧 Script de inicialización completa de Oracle en Kubernetes"
echo "============================================================"

# Obtener el pod de Oracle
ORACLE_POD=$(kubectl get pods -l app=oracle-db -o jsonpath='{.items[0].metadata.name}')

if [ -z "$ORACLE_POD" ]; then
  echo "❌ No se encontró el pod de Oracle"
  exit 1
fi

echo "✅ Pod de Oracle encontrado: $ORACLE_POD"
echo ""

# Directorio de scripts
SCRIPTS_DIR="./oracle-db/init-scripts"
REMOTE_DIR="/tmp/init-scripts"

echo "📦 Copiando scripts de inicialización al pod..."
kubectl exec $ORACLE_POD -- mkdir -p $REMOTE_DIR

for script in $(ls $SCRIPTS_DIR/*.sql | sort); do
  script_name=$(basename $script)
  echo "   Copiando $script_name..."
  kubectl cp $script $ORACLE_POD:$REMOTE_DIR/$script_name
done

echo "✅ Scripts copiados exitosamente"
echo ""

# Ejecutar scripts en orden
echo "🚀 Ejecutando scripts de inicialización..."

scripts=(
  "02-create-sequences.sql"
  "03-create-tables.sql"
  "04-create-views.sql"
  "05-inserts.sql"
  "06-create-indexes.sql"
  "07-create-procedures.sql"
  "08-add-table-constraints.sql"
  "09-create-triggers.sql"
  "999-init-complete.sql"
)

for script in "${scripts[@]}"; do
  echo ""
  echo "📄 Ejecutando $script..."
  kubectl exec $ORACLE_POD -- bash -c "sqlplus -s GESTOCK/adminadmin@//localhost:1521/FREEPDB1 @$REMOTE_DIR/$script" || {
    echo "⚠️  Error en $script (continuando...)"
  }
done

echo ""
echo "✅ Inicialización de base de datos completada"
echo ""
echo "🔍 Verificando tablas creadas..."
kubectl exec $ORACLE_POD -- bash -c "echo 'SELECT table_name FROM user_tables;' | sqlplus -s GESTOCK/adminadmin@//localhost:1521/FREEPDB1" | head -20

echo ""
echo "✨ ¡Listo! Ahora puedes acceder a la aplicación"
