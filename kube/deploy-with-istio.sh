#!/bin/bash

# Script para desplegar la configuración completa de Istio y observabilidad
# GeStock - Full Deployment with Istio

set -e

echo "🚀 Desplegando GeStock con Istio y Observabilidad..."

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para esperar a que un deployment esté listo
wait_for_deployment() {
    local deployment=$1
    local namespace=${2:-default}
    echo -e "${YELLOW}⏳ Esperando a que ${deployment} esté listo...${NC}"
    kubectl wait --for=condition=available --timeout=300s deployment/${deployment} -n ${namespace} 2>/dev/null || true
    echo -e "${GREEN}✅ ${deployment} está listo${NC}"
}

# Paso 1: Instalar Istio
echo -e "${BLUE}📦 Paso 1: Instalando Istio...${NC}"
./install-istio.sh

# Paso 2: Reiniciar deployments para inyectar sidecar
echo -e "${BLUE}🔄 Paso 2: Reiniciando deployments para inyectar sidecar de Istio...${NC}"
kubectl rollout restart deployment/backend
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/oracle-db

wait_for_deployment backend
wait_for_deployment frontend
wait_for_deployment oracle-db

# Paso 3: Aplicar configuración de Istio
echo -e "${BLUE}⚙️  Paso 3: Aplicando configuración de Istio...${NC}"
kubectl apply -f istio-config.yaml
kubectl apply -f istio-security.yaml
kubectl apply -f istio-telemetry.yaml

# Paso 4: Verificar que los sidecars estén inyectados
echo -e "${BLUE}🔍 Paso 4: Verificando inyección de sidecars...${NC}"
echo ""
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].name}{"\n"}{end}' | grep -E "(backend|frontend|oracle)"

# Paso 5: Exponer servicios de Istio
echo -e "${BLUE}🌐 Paso 5: Exponiendo servicios de observabilidad...${NC}"

# Grafana
kubectl port-forward -n istio-system svc/grafana 3000:3000 > /dev/null 2>&1 &
GRAFANA_PID=$!

# Prometheus
kubectl port-forward -n istio-system svc/prometheus 9090:9090 > /dev/null 2>&1 &
PROMETHEUS_PID=$!

# Kiali (Service Mesh Dashboard)
kubectl port-forward -n istio-system svc/kiali 20001:20001 > /dev/null 2>&1 &
KIALI_PID=$!

# Jaeger (Tracing)
kubectl port-forward -n istio-system svc/tracing 16686:80 > /dev/null 2>&1 &
JAEGER_PID=$!

# Guardar PIDs para poder detenerlos después
echo "$GRAFANA_PID $PROMETHEUS_PID $KIALI_PID $JAEGER_PID" > /tmp/gestock-portforward.pids

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Despliegue completado exitosamente!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📊 Acceso a las herramientas de observabilidad:${NC}"
echo ""
echo -e "🔹 Grafana (Dashboards):"
echo -e "   URL: ${YELLOW}http://localhost:3000${NC}"
echo -e "   Usuario: ${YELLOW}admin${NC}"
echo -e "   Contraseña: ${YELLOW}admin${NC}"
echo -e "   Dashboards Istio disponibles:"
echo -e "     - Istio Mesh Dashboard"
echo -e "     - Istio Service Dashboard"
echo -e "     - Istio Workload Dashboard"
echo ""
echo -e "🔹 Prometheus (Métricas):"
echo -e "   URL: ${YELLOW}http://localhost:9090${NC}"
echo ""
echo -e "🔹 Kiali (Service Mesh Observability):"
echo -e "   URL: ${YELLOW}http://localhost:20001${NC}"
echo -e "   Usuario: ${YELLOW}admin${NC}"
echo -e "   Contraseña: ${YELLOW}admin${NC}"
echo ""
echo -e "🔹 Jaeger (Distributed Tracing):"
echo -e "   URL: ${YELLOW}http://localhost:16686${NC}"
echo ""
echo -e "🔹 Backend API:"
echo -e "   Obtener URL del Ingress Gateway:"
echo -e "   ${YELLOW}export INGRESS_HOST=\$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')${NC}"
echo -e "   ${YELLOW}export INGRESS_PORT=\$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name==\"http2\")].port}')${NC}"
echo -e "   ${YELLOW}echo http://\$INGRESS_HOST:\$INGRESS_PORT/api${NC}"
echo ""
echo -e "${BLUE}📈 Métricas disponibles para cada endpoint:${NC}"
echo -e "  - Latencia (P50, P90, P95, P99)"
echo -e "  - Request rate (requests por segundo)"
echo -e "  - Error rate (errores por segundo)"
echo -e "  - Throughput (bytes enviados/recibidos)"
echo -e "  - Connection pool metrics"
echo -e "  - Circuit breaker status"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo -e "  - Las métricas se recolectan automáticamente sin modificar código"
echo -e "  - Istio crea métricas para TODOS los endpoints del backend"
echo -e "  - Usa Kiali para visualizar el service mesh en tiempo real"
echo -e "  - Usa Jaeger para tracing distribuido de requests"
echo ""
echo -e "${BLUE}🔧 Para detener los port-forwards:${NC}"
echo -e "   ${YELLOW}kill \$(cat /tmp/gestock-portforward.pids)${NC}"
echo ""
echo -e "${GREEN}🎉 ¡Todo listo! Accede a Grafana para ver los dashboards de Istio${NC}"
