#!/bin/bash

# Script para acceder a todas las herramientas de observabilidad de Istio
# GeStock - Quick Access

echo "🎯 Accediendo a las herramientas de observabilidad de GeStock con Istio..."
echo ""

# Verificar que los servicios estén corriendo
echo "🔍 Verificando servicios..."
kubectl get pods -n istio-system | grep -E "(grafana|prometheus|kiali|jaeger)" | grep "Running" > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Servicios corriendo correctamente"
else
    echo "⚠️  Algunos servicios no están corriendo. Ejecuta: ./deploy-with-istio.sh"
    exit 1
fi

echo ""
echo "🌐 Exponiendo servicios (port-forward)..."

# Limpiar port-forwards anteriores
pkill -f "port-forward.*grafana" 2>/dev/null
pkill -f "port-forward.*prometheus" 2>/dev/null
pkill -f "port-forward.*kiali" 2>/dev/null
pkill -f "port-forward.*jaeger" 2>/dev/null
sleep 2

# Exponer servicios
kubectl port-forward -n istio-system svc/grafana 3000:3000 >/dev/null 2>&1 &
GRAFANA_PID=$!

kubectl port-forward -n istio-system svc/prometheus 9090:9090 >/dev/null 2>&1 &
PROMETHEUS_PID=$!

kubectl port-forward -n istio-system svc/kiali 20001:20001 >/dev/null 2>&1 &
KIALI_PID=$!

kubectl port-forward -n istio-system svc/tracing 16686:80 >/dev/null 2>&1 &
JAEGER_PID=$!

sleep 3

echo ""
echo "✅ Port-forwards activos:"
echo ""
echo "📊 GRAFANA - Dashboards de métricas"
echo "   🔗 http://localhost:3000"
echo "   👤 Usuario: admin | Contraseña: admin"
echo ""
echo "   📈 Dashboards disponibles:"
echo "      - Istio Mesh Dashboard (Vista general del mesh)"
echo "      - Istio Service Dashboard (Métricas por servicio)"
echo "      - Istio Workload Dashboard (Métricas por workload)"
echo "      - Istio Performance Dashboard (Latencia detallada)"
echo ""

echo "🔍 PROMETHEUS - Consultas de métricas"
echo "   🔗 http://localhost:9090"
echo ""
echo "   💡 Queries útiles:"
echo "      - istio_requests_total (total de requests)"
echo "      - istio_request_duration_milliseconds_bucket (latencia)"
echo "      - istio_tcp_connections_opened_total (conexiones TCP)"
echo ""

echo "🕸️  KIALI - Visualización del Service Mesh"
echo "   🔗 http://localhost:20001"
echo "   👤 Usuario: admin | Contraseña: admin"
echo ""
echo "   ✨ Características:"
echo "      - Topología del mesh en tiempo real"
echo "      - Health checks de servicios"
echo "      - Métricas y logs integrados"
echo "      - Configuración de Istio validada"
echo ""

echo "📍 JAEGER - Distributed Tracing"
echo "   🔗 http://localhost:16686"
echo ""
echo "   🔎 Puedes buscar traces por:"
echo "      - Servicio (backend, frontend)"
echo "      - Operación (GET /api/products, etc.)"
echo "      - Duración (traces lentos)"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎯 MÉTRICAS POR ENDPOINT"
echo ""
echo "Istio recolecta automáticamente métricas para CADA endpoint:"
echo ""
echo "  ✓ /api/products"
echo "  ✓ /api/inventory"
echo "  ✓ /api/users"
echo "  ✓ /api/auth/*"
echo "  ✓ /api/sales/*"
echo "  ✓ /api/rfid/*"
echo "  ✓ Y todos los demás endpoints..."
echo ""
echo "📊 Métricas disponibles:"
echo "  • Request rate (requests/segundo)"
echo "  • Latencia (P50, P90, P95, P99)"
echo "  • Error rate (errores/segundo)"
echo "  • Success rate (%)"
echo "  • Throughput (bytes/segundo)"
echo "  • Active connections"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 EJEMPLOS DE USO"
echo ""
echo "1️⃣  Ver métricas en tiempo real:"
echo "   • Abre Grafana → Dashboards → Istio Service Dashboard"
echo "   • Filtra por servicio: backend.default.svc.cluster.local"
echo ""
echo "2️⃣  Visualizar topología del mesh:"
echo "   • Abre Kiali → Graph"
echo "   • Selecciona namespace: default"
echo "   • Observa el tráfico entre servicios en tiempo real"
echo ""
echo "3️⃣  Analizar latencia de un endpoint:"
echo "   • Abre Prometheus"
echo "   • Query: histogram_quantile(0.95, rate(istio_request_duration_milliseconds_bucket[5m]))"
echo ""
echo "4️⃣  Rastrear un request completo:"
echo "   • Abre Jaeger"
echo "   • Busca por servicio: backend"
echo "   • Ve el path completo: frontend → backend → database"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🛑 Para detener los port-forwards:"
echo "   kill $GRAFANA_PID $PROMETHEUS_PID $KIALI_PID $JAEGER_PID"
echo ""
echo "   O simplemente cierra esta terminal"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ ¡Listo! Abre tu navegador y explora las herramientas"
echo ""

# Mantener el script corriendo
echo "⌛ Presiona Ctrl+C para detener los port-forwards..."
echo ""

# Esperar indefinidamente
wait
