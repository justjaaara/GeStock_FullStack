#!/bin/bash

# Script para instalar y configurar Istio en el cluster
# GeStock - Istio Installation

set -e

echo "🚀 Instalando Istio en el cluster..."

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar si istioctl está instalado
if ! command -v istioctl &> /dev/null; then
    echo -e "${YELLOW}⚠️  istioctl no está instalado. Descargando...${NC}"
    
    # Descargar Istio
    cd /tmp
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.0 sh -
    
    # Agregar istioctl al PATH
    export PATH=$PATH:/tmp/istio-1.20.0/bin
    
    echo -e "${GREEN}✅ istioctl descargado${NC}"
else
    echo -e "${GREEN}✅ istioctl ya está instalado${NC}"
fi

# Instalar Istio con el perfil demo (incluye Prometheus, Grafana, Jaeger, Kiali)
echo -e "${BLUE}📦 Instalando Istio con perfil demo...${NC}"
istioctl install --set profile=demo -y

# Verificar la instalación
echo -e "${BLUE}🔍 Verificando instalación de Istio...${NC}"
kubectl get pods -n istio-system

# Habilitar inyección automática de sidecar en el namespace default
echo -e "${BLUE}💉 Habilitando inyección automática de sidecar en namespace default...${NC}"
kubectl label namespace default istio-injection=enabled --overwrite

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Istio instalado exitosamente!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📊 Componentes instalados:${NC}"
echo -e "  - Istiod (Control Plane)"
echo -e "  - Istio Ingress Gateway"
echo -e "  - Istio Egress Gateway"
echo -e "  - Prometheus (métricas)"
echo -e "  - Grafana (dashboards)"
echo -e "  - Jaeger (tracing)"
echo -e "  - Kiali (service mesh observability)"
echo ""
