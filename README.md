# GeStock - Sistema de Gestión de Inventario

## Índice

1. [Descripción del Objetivo](#descripción-del-objetivo)
   - [Objetivo Principal (MVP)](#objetivo-principal-mvp)
   - [Alcance Definido](#alcance-definido)
2. [Requisitos para ejecutar la aplicación](#requisitos-para-ejecutar-el-proyecto)
3. [Instrucciones para iniciar la aplicación](#instrucciones-para-ejecutar-el-proyecto)
4. [Despliegue en Kubernetes (Minikube)](#despliegue-en-kubernetes-minikube)
   - [Requisitos previos](#requisitos-previos)
   - [Despliegue](#despliegue)
   - [Arquitectura de Kubernetes](#arquitectura-de-kubernetes)
5. [Observabilidad con Istio Service Mesh](#️-observabilidad-con-istio-service-mesh)
   - [Instalación Rápida](#instalación-rápida)
   - [Herramientas de Observabilidad](#herramientas-de-observabilidad)
   - [Métricas Automáticas](#métricas-automáticas)
6. [Funcionamiento de la Aplicación](#funcionamiento-de-la-aplicación)
7. [Estructura del Proyecto](#estructura-del-proyecto)
8. [Flujos Desarrollados](#flujos-desarrollados-al-momento)
9. [Flujos Pendientes (Entrega Final)](#flujos-pendientes-entrega-final)
10. [Modelo de Datos](#modelo-de-datos)
11. [Detalle Historias de Usuario](#detalle-historias-de-usuario)

---

## Descripción del Objetivo

GeStock es un MVP de sistema web de gestión de inventario diseñado para empresas que necesitan controlar y administrar sus productos de manera eficiente mediante tecnología RFID. La aplicación permite a los usuarios gestionar el inventario en tiempo real, realizar carga masiva de productos, recibir alertas automáticas de stock bajo, y mantener un control detallado con trazabilidad completa de todos los movimientos, incluyendo cierres mensuales automáticos para auditoría histórica.

### Objetivo Principal (MVP)

Desarrollar un MVP de aplicación web para gestión de inventario que permita:

- **Control de Productos**: CRUD completo con categorización y control de stock
- **Sistema RFID**: Carga masiva de productos con validación de duplicados
- **Alertas Inteligentes**: Notificaciones automáticas por stock bajo con trazabilidad
- **Reportes y Consolidados**: Informes detallados con exportación PDF/Excel
- **Cierres Mensuales**: Snapshots automáticos con auditoría histórica
- **Punto de Venta Básico**: Registro de salidas de prueba sin facturación completa
- **Administración de Usuarios**: Control de roles y permisos granulares

### Alcance Definido

✅ **Lo que SÍ incluye el MVP:**

- Base de datos Oracle con operaciones CRUD confiables
- Carga masiva de productos via RFID con validación automática
- Control de stock con alertas por bajo inventario
- Trazabilidad completa de cambios y movimientos
- Salidas de prueba para simular movimientos
- Reportes de existencias, consolidaciones y cierres mensuales
- Arquitectura moderna (Angular + NestJS + Oracle)
- Sistema de ventas completo con facturación
- Gestión de pagos o punto de venta real
- Integración con sistemas ERP externos
- Logística de distribución y proveedores
- Gestión avanzada de clientes
- Herramientas de predicción con IA

### Requisitos para ejecutar el proyecto

1. Tener Git instalado . Si no lo tienes descargalo de: https://git-scm.com/
2. Tener Docker descargado. Si no lo tienes descargalo de: https://www.docker.com/

## Instrucciones para ejecutar el proyecto

1. Ejecutar docker. Si no lo tienes descargado, hazlo siguiendo los pasos por la página oficial https://www.docker.com/
2. Clona el repositorio: `git clone --recurse-submodules https://github.com/justjaaara/GeStock_FullStack.git``
3. Abre tu editor de código de confianza y dentro de él abre la carpeta del proyecto `GeStock_FullStack`
4. Renombra el archivo `.env.example` a `.env`. No es necesario hacer modificaciones al archivo ya que los parámetros que vienen por defecto sirven.
5. En una terminal ingresa a la carpeta donde clonaste el repositorio, esta carpeta estará nombrada como `GeStock_FullStack`
6. Ejecutar el comando `docker compose up --build`. (Este paso tardará un poco ya que descargará las iamágenes necesarias para que funcione la aplicación)
7. Una vez termine de construirse los contenedores, puedes entrar a http://localhost:8080/login para empezar a probar la aplicación (En caso tal de que presente algún error el backend, solo es cuestión de esperar mientras se inicializa y conecta correctamente con la base de datos, puedes revisar los logs del contenedor en Docker Desktop)

Listo! Ya está corriendo el proyecto y puedes probarlo sin ningún problema.

Si deseas acceder a la documentación de la API del backend debes ingresar a http://localhost:3000/api/docs

### 📸 Evidencia - Docker Compose Funcionando

**Contenedores ejecutándose correctamente:**

![Docker Compose Up - Contenedores corriendo](https://i.imgur.com/qaJfPWi.png)
*Todos los servicios (backend, frontend, oracle-db) corriendo exitosamente*

**Aplicación accesible en el navegador:**

![Frontend GeStock Login](https://i.imgur.com/OduS3Vr.png)
*Interfaz de login de GeStock accesible en http://localhost:8080*

![Swagger API Documentation](https://i.imgur.com/4MeApXa.png)
*Documentación Swagger de la API accesible en http://localhost:3000/api/docs*

---

## Despliegue en Kubernetes (Minikube)

### Requisitos previos

1. **Minikube instalado**: https://minikube.sigs.k8s.io/docs/start/
2. **kubectl instalado**: https://kubernetes.io/docs/tasks/tools/
3. **Docker Desktop** corriendo

### Despliegue

1. **Iniciar Minikube**:

   ```bash
   minikube start --driver=docker
   ```

2. **Desplegar aplicaciones**:

   ```bash
   kubectl apply -f ./kube/
   ```

3. **Verificar estado**:
   ```bash
   kubectl get pods
   kubectl get svc
   ```

### Acceder a la aplicación

Una vez que todos los pods estén `Running`:

```bash
# Abrir frontend en el navegador
minikube service frontend

# Abrir backend/API en el navegador
minikube service backend
```

O acceder manualmente:

```bash
# Ver la IP de Minikube
minikube ip

# Acceder:
# Frontend: http://<minikube-ip>:30800
# Backend:  http://<minikube-ip>:30300
# Swagger:  http://<minikube-ip>:30300/api/docs
```

### Monitoreo

```bash
# Ver pods en tiempo real
kubectl get pods -w

# Ver logs
kubectl logs <nombre-pod>

# Ver logs del backend
kubectl logs -l app=backend

# Ver logs de Oracle
kubectl logs -l app=oracle-db
```

### Limpiar

```bash
kubectl delete -f ./kube/
```

### 📸 Evidencia - Kubernetes Funcionando

**Pods desplegados exitosamente:**

![Kubernetes Pods Running](https://i.imgur.com/l8JKzOQ.png)
*Todos los pods (backend, frontend, oracle-db) en estado Running con 2/2 containers (aplicación + Istio sidecar)*

**Servicios expuestos:**

![Kubernetes Services](https://i.imgur.com/Ky6Z35C.png)
*Servicios configurados con ClusterIP y NodePort para acceso externo*

**Deployments activos:**

![Kubernetes Deployments](https://i.imgur.com/m6RXSe0.png)
*Deployments de backend, frontend y oracle-db con réplicas listas*

**Aplicación accesible desde Minikube:**

![GeStock en Kubernetes](https://i.imgur.com/YOwEKSk.png)
*Aplicación GeStock corriendo en Kubernetes y accesible desde el navegador*

---

### Arquitectura de Kubernetes

La carpeta `kube/` contiene todos los manifiestos necesarios para desplegar GeStock en Kubernetes:

#### **Archivos de Configuración**

##### **`secret.yaml`**

Contiene las credenciales sensibles encriptadas en base64:

- `DB_PASSWORD`: Contraseña de Oracle (usuario GESTOCK y SYSTEM)
- `JWT_SECRET`: Clave secreta para firmar tokens JWT

**Uso**: Las variables se inyectan en los pods mediante `secretKeyRef`.

##### **`configmap.yaml`**

Almacena configuraciones no sensibles de la aplicación:

- `DB_HOST`: Nombre del servicio de Oracle (`oracle-db`)
- `DB_PORT`: Puerto de Oracle (`1521`)
- `DB_USERNAME`: Usuario de base de datos (`GESTOCK`)
- `DB_NAME`: Nombre de la base de datos (`FREEPDB1`)
- `PORT`: Puerto del backend (`3000`)
- `BACKENDBASEURL`: URL base para el frontend

**Uso**: Se carga completo en los pods mediante `envFrom.configMapRef`.

##### **`namespace.yaml`**

Define el namespace `gestock` para aislar recursos (opcional, actualmente se usa `default`).

#### **Archivos de Despliegue**

##### **`deployment.yaml`**

Contiene **tres deployments** que orquestan los pods:

1. **Oracle Database**:

   - Imagen: `container-registry.oracle.com/database/free:latest`
   - Puerto: 1521
   - Variables: `ORACLE_PWD`, `ORACLE_CHARACTERSET`
   - Uso: Base de datos principal del sistema

2. **Backend (NestJS)**:

   - Imagen: `justjaaara/gestock-backend:latest`
   - Puerto: 3000
   - Init Container: Espera a que Oracle esté disponible antes de iniciar
   - Variables: Carga desde ConfigMap + Secrets
   - Uso: API REST del sistema

3. **Frontend (Angular)**:
   - Imagen: `justjaaara/gestock-frontend:latest`
   - Puerto: 8080
   - Uso: Interfaz web de usuario

**Características**:

- 1 réplica por servicio (configuración simple)
- Init container en backend para esperar a Oracle
- Health checks deshabilitados para simplificar

##### **`service.yaml`**

Expone los pods mediante servicios de Kubernetes:

1. **oracle-db** (ClusterIP):

   - Puerto interno: 1521
   - Accesible solo dentro del cluster

2. **backend** (NodePort):

   - Puerto interno: 3000
   - Puerto externo: 30300
   - Acceso: `http://<minikube-ip>:30300`

3. **frontend** (NodePort):
   - Puerto interno: 8080
   - Puerto externo: 30800
   - Acceso: `http://<minikube-ip>:30800`

**Tipos de servicio**:

- **ClusterIP**: Solo acceso interno (Oracle)
- **NodePort**: Acceso externo mediante puerto del nodo (Backend, Frontend)

#### **Scripts de Inicialización**

##### **`oracle-init-job.yaml`**

Job de Kubernetes que inicializa la base de datos:

- Espera 60 segundos a que Oracle termine de iniciar
- Crea el usuario `GESTOCK` con todos los privilegios
- Se ejecuta una sola vez tras el despliegue
- Se auto-elimina después de 100 segundos

**Ejecución**:

```bash
kubectl apply -f ./kube/oracle-init-job.yaml
```

##### **`init-oracle-db.sh`**

Script Bash para inicialización completa de la base de datos:

- Copia todos los scripts SQL al pod de Oracle
- Ejecuta en orden:
  - Secuencias (02)
  - Tablas (03)
  - Vistas (04)
  - Datos iniciales (05)
  - Índices (06)
  - Procedimientos almacenados (07)
  - Constraints (08)
  - Triggers (09)
  - Validación final (999)
- Maneja errores de tablespaces faltantes automáticamente

**Ejecución**:

```bash
chmod +x ./kube/init-oracle-db.sh
./kube/init-oracle-db.sh
```

** Importante**: Este script debe ejecutarse **después** de que el `oracle-init-job` haya completado la creación del usuario GESTOCK.

### Notas Importantes

- **Primera vez**: Oracle puede tardar 5-10 minutos en inicializar completamente
- El backend espera automáticamente a que Oracle esté listo (estado `Init:0/1`)
- El Job de inicialización se ejecuta automáticamente, pero `init-oracle-db.sh` debe ejecutarse manualmente

---

## 🕸️ Observabilidad con Istio Service Mesh

GeStock incluye **Istio Service Mesh** para proporcionar observabilidad completa de la aplicación sin modificar código.

### ¿Qué es Istio?

Istio proporciona:
- **Observabilidad automática**: Métricas, logs y traces de todos los endpoints
- **Gestión de tráfico**: Enrutamiento avanzado, balanceo de carga, circuit breakers
- **Seguridad**: mTLS automático entre servicios
- **Resiliencia**: Reintentos automáticos, timeouts configurables

### Instalación Rápida

```bash
cd kube
chmod +x deploy-with-istio.sh install-istio.sh
./deploy-with-istio.sh
```

Este script:
1. Instala Istio v1.20.0 con perfil demo
2. Habilita inyección automática de sidecars
3. Reinicia los deployments con sidecars de Istio
4. Despliega Prometheus, Grafana, Kiali y Jaeger
5. Configura port-forwards para acceso local

### Herramientas de Observabilidad

#### 📊 Grafana - Dashboards de Métricas
- **URL**: http://localhost:3000
- **Credenciales**: admin / admin
- **Dashboards disponibles**:
  - Istio Mesh Dashboard (vista general)
  - Istio Service Dashboard (métricas por servicio)
  - Istio Workload Dashboard (métricas por pod)
  - Istio Performance Dashboard (latencia detallada)

#### 📈 Prometheus - Consultas de Métricas
- **URL**: http://localhost:9090
- Consulta métricas con PromQL
- Almacena series temporales de métricas

#### 🕸️ Kiali - Service Mesh Observability
- **URL**: http://localhost:20001
- **Credenciales**: admin / admin
- Visualiza topología del sistema en tiempo real
- Muestra flujo de tráfico entre servicios
- Health checks y validación de configuración

#### 🔍 Jaeger - Distributed Tracing
- **URL**: http://localhost:16686
- Rastrea requests completos (frontend → backend → database)
- Identifica cuellos de botella de latencia
- Debugging de requests fallidos

### Métricas Automáticas

Istio recolecta automáticamente para cada endpoint:

**Métricas de Requests:**
- Request rate (requests/segundo)
- Success rate (% exitosos)
- Error rate (errores/segundo)

**Métricas de Latencia:**
- P50 (mediana)
- P90 (90% de requests)
- P95 (95% de requests)
- P99 (99% de requests)

**Métricas de Tráfico:**
- Bytes enviados/recibidos
- Throughput (MB/s)
- Tamaño promedio de requests/responses

### Queries de Ejemplo en Prometheus

```promql
# Request rate por servicio
sum(rate(istio_requests_total{destination_service="backend.default.svc.cluster.local"}[5m]))

# Latencia P95 por endpoint
histogram_quantile(0.95, sum(rate(istio_request_duration_milliseconds_bucket{destination_service="backend.default.svc.cluster.local"}[5m])) by (le))

# Success rate (%)
(sum(rate(istio_requests_total{destination_service="backend.default.svc.cluster.local",response_code!~"5.."}[5m])) / sum(rate(istio_requests_total{destination_service="backend.default.svc.cluster.local"}[5m]))) * 100
```

### Script de Acceso Rápido

Para acceder a todas las herramientas fácilmente:

```bash
cd kube
./access-observability.sh
```

Este script:
- Verifica que los servicios estén corriendo
- Crea port-forwards automáticamente
- Muestra URLs de acceso

### Beneficios de Istio

✅ **Sin modificar código** - Observabilidad automática  
✅ **Cobertura completa** - Todos los endpoints monitoreados  
✅ **Producción ready** - Usado por Uber, Spotify, Netflix  
✅ **Métricas avanzadas** - Latencia, throughput, error rate  
✅ **Distributed tracing** - Path completo de cada request  
✅ **Seguridad integrada** - mTLS entre servicios

### 📸 Evidencia - Observabilidad con Istio

**Grafana - Dashboard de Métricas:**

![Grafana Istio Service Dashboard](https://i.imgur.com/6eYMqfA.png)
*Dashboard de Grafana mostrando métricas del servicio backend: request rate, success rate, latencia (P50, P90, P95, P99), throughput*

**Kiali - Topología del Service Mesh:**

![Kiali Service Graph](https://i.imgur.com/LOTcdbj.png)
*Visualización en tiempo real de la topología del sistema: frontend → backend → oracle-db con métricas de tráfico*

---

## CI/CD con GitHub Actions

GeStock implementa un pipeline de CI/CD completo usando GitHub Actions para automatizar el proceso de construcción, pruebas y despliegue.

### Workflow Principal

El pipeline se ejecuta automáticamente en cada push a las ramas principales (`main`, `develop`) y en pull requests.

**Archivo:** `.github/workflows/ci-cd.yml`

### Stages del Pipeline

#### 1. 🧪 Build & Test (Backend)
- **Tecnología:** NestJS
- **Pasos:**
  - Checkout del código
  - Setup de Node.js v20
  - Instalación de dependencias con pnpm
  - Compilación del proyecto
  - Ejecución de tests unitarios
  - Generación de coverage report

#### 2. 🧪 Build & Test (Frontend)
- **Tecnología:** Angular
- **Pasos:**
  - Checkout del código
  - Setup de Node.js v20
  - Instalación de dependencias con pnpm
  - Compilación del proyecto con optimizaciones de producción
  - Ejecución de tests unitarios
  - Linting del código

#### 3. 🐳 Docker Build & Push
- **Registry:** Docker Hub
- **Pasos:**
  - Login a Docker Hub
  - Build de imagen del backend
  - Build de imagen del frontend
  - Tag de imágenes con versión y `latest`
  - Push a Docker Hub
  - Escaneo de vulnerabilidades con Trivy

#### 4. 🚀 Deploy to Kubernetes (Staging)
- **Entorno:** Minikube/Kubernetes
- **Pasos:**
  - Setup de kubectl
  - Aplicación de manifiestos de Kubernetes
  - Actualización de imágenes en deployments
  - Verificación de health checks
  - Rollback automático en caso de fallo

#### 5. 📊 Deploy Observability Stack
- **Herramientas:** Istio, Prometheus, Grafana, Kiali, Jaeger
- **Pasos:**
  - Instalación de Istio service mesh
  - Deploy de addons de observabilidad
  - Configuración de telemetría
  - Verificación de métricas

### Variables de Entorno

El pipeline utiliza GitHub Secrets para manejar información sensible:

```yaml
secrets:
  DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
  KUBECONFIG: ${{ secrets.KUBECONFIG }}
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
  JWT_SECRET: ${{ secrets.JWT_SECRET }}
```

### Badges de Estado

[![CI/CD Pipeline](https://github.com/justjaaara/GeStock_FullStack/workflows/CI-CD/badge.svg)](https://github.com/justjaaara/GeStock_FullStack/actions)
[![Docker Hub](https://img.shields.io/docker/pulls/justjaaara/gestock-backend.svg)](https://hub.docker.com/r/justjaaara/gestock-backend)

### Estrategia de Deployment

- **Desarrollo:** Deploy automático en cada commit a `develop`
- **Staging:** Deploy automático en cada commit a `main`
- **Producción:** Deploy manual con aprobación requerida
- **Rollback:** Automático si los health checks fallan

### Monitoreo del Pipeline

Cada ejecución del pipeline incluye:
- ✅ Notificaciones de estado (éxito/fallo)
- 📊 Reportes de coverage de tests
- 🔒 Escaneo de seguridad de imágenes Docker
- 📝 Logs detallados de cada stage
- ⏱️ Métricas de tiempo de ejecución

### Comandos Útiles

```bash
# Ver estado de workflows
gh workflow list

# Ver ejecuciones recientes
gh run list

# Ver logs de una ejecución
gh run view <run-id> --log

# Re-ejecutar un workflow fallido
gh run rerun <run-id>
```

---

## Funcionamiento de la Aplicación

La aplicación está construida con una arquitectura moderna de frontend-backend separados:

- **Frontend**: Angular v20.2 con arquitectura de componentes standalone y signals
- **Backend**: NestJS v11.0.1
- **ORM**: TypeORM
- **Base de datos**: Oracle última versión
- **Autenticación**: JWT (JSON Web Tokens) para seguridad
- **API**: RESTful API con documentación Swagger

## Estructura del Proyecto

```
.
│── GeStock-Frontend/
│    ├── src/
│    │   ├── app/
│    │   │   ├── auth/             # Módulo de autenticación
│    │   │   ├── core-ui/          # Módulo Core de la aplicación (Funcionalidades)
│    │   │   ├── shared/           # Componentes compartidos
│    │   │   └── app.routes.ts     # Rutas de la aplicación
│    │   ├── environments/         # Configuración de entornos
│    │   └── styles.css            # Estilos globales
│    ├── package.json              # Dependencias del proyecto
|    ├── Dockerfile                # Configuración de la imagen para el Frontend
|    └── .dockerignore             # Archivo que permite ignorar elementos a subir en docker
│── GeStock-Backend/
│    ├── src/
│    │   ├── auth/                 # Módulo de autenticación
│    │   ├── users/                # Gestión de usuarios
│    │   ├── config/               # Configuración de base de datos
│    │   ├── entities/             # Entidades de TypeORM
│    │   ├── common/               # Utilidades compartidas
│    │   └── main.ts               # Punto de entrada
│    ├── .env                      # Variables de entorno
│    ├── package.json              # Dependencias del proyecto
|    ├── Dockerfile                # Configuración de la imagen para el Backend
|    └── .dockerignore             # Archivo que permite ignorar elementos a subir en docker
├── oracle-db
│   ├── data
│   └── init-scripts
│       └── 01-create-user.sql
├── .dockerignore                  # Archivo para configurar los elementos ignorados de docker
├── .env.example                   # Archivo de variables de entorno para docker-compose.yml
├── .gitignore                     # Archivo para configurar los elementos ignorados de git
├── .gitmodules                    # Archivo de configuración de los submódulos del repositorio
├── docker-compose.yml             # Configuración para orquestar los contenedores del Frontend, backend y base de datos.
└── README.md                      # Archivo actual con documentación
```

## Flujos Desarrollados al momento

### ✅ 1. Sistema de Autenticación Completo

- **Registro de Usuarios**

  - Validación de contraseña fuerte (mínimo 6 caracteres, números y caracteres especiales)
  - Validación de email único
  - Encriptación de contraseñas con bcrypt
  - Asignación automática de rol de usuario

- **Inicio de Sesión**

  - Autenticación con email y contraseña
  - Generación de JWT tokens
  - Manejo de errores de autenticación
  - Redirección automática al dashboard

- **Cambio de Contraseña**
  - Validación de contraseña actual
  - Validación de contraseña (mínimo 6 caracteres, números y caracteres especiales)
  - Actualización segura en base de datos

### ✅ 2. Arquitectura de Navegación

- **Sidebar Navegación**
  - Navegación intuitiva por módulos
  - Dashboard principal
  - Acceso rápido a todas las secciones

## Flujos Pendientes (Entrega Final)

### 🚧 1. Administración de Usuarios y Roles (GES-112, GES-117, GES-152, GES-201)

- **Gestión de Usuarios por Administrador**

  - Listado completo de usuarios registrados (GES-117)
  - Eliminación de usuarios para revocar acceso (GES-112)
  - Asignación de roles diferenciados (GES-152)
  - Control de acceso por rol (administrador, cajero, usuario) (GES-201)

- **Recuperación de Contraseña** (GES-4)
  - Sistema de recuperación por email
  - Generación de tokens temporales
  - Validación de identidad

### 🚧 2. Gestión Completa de Productos (GES-47, GES-58, GES-69, GES-77, GES-85, GES-94, GES-103, GES-131)

- **CRUD de Productos**

  - Registro de productos en inventario (GES-47)
  - Actualización de categoría, nombre, precio (GES-58)
  - Visualización individual de productos (GES-69)
  - Vista general del inventario completo (GES-77)
  - Actualización de existencias (GES-85)
  - Eliminación de productos del sistema (GES-94)

- **Control de Stock**
  - Configuración de stock mínimo por producto (GES-131)
  - Filtrado por categoría, precio, existencias (GES-103)

### 🚧 3. Sistema RFID y Control de Lotes (GES-159, GES-160)

- **Carga Masiva con RFID**
  - Escaneo de etiquetas RFID para registro automático (GES-159)
  - Validación automática de duplicados (GES-160)
  - Registro de lotes con trazabilidad completa
  - Integración con hardware RFID

### 🚧 4. Sistema de Alertas y Trazabilidad (GES-118, GES-119, GES-203)

- **Alertas de Stock**
  - Notificaciones automáticas por stock bajo (GES-118)
  - Alertas diarias hasta reposición (GES-203)
  - Dashboard de alertas activas

### 🚧 5. Módulo de Ventas Básico (GES-162, GES-164, GES-204, GES-205)

- **Punto de Venta Simplificado**

  - Búsqueda de productos para venta (GES-162)
  - Emisión de comprobantes básicos (GES-164)
  - Validación en tiempo real del inventario (GES-204)
  - Control de acceso por rol cajero/admin (GES-205)

- **Registro de Salidas de Prueba**
  - Simulación de movimientos sin ventas reales
  - Registro de salidas para testing
  - Control de stock en tiempo real

### 🚧 6. Sistema de Reportes y Consolidados (GES-166, GES-167, GES-168, GES-206, GES-211, GES-212)

- **Reportes Operativos**
  - Reporte general de inventario por producto (GES-166)
  - Reporte de productos vendidos por categoría (GES-167)
  - Reporte de ingresos por lote RFID (GES-168)
  - Consolidado de stock por producto (GES-211)

### 🚧 7. Cierres Mensuales (GES-213, GES-214, GES-215)

- **Cierres Automáticos**
  - Snapshot automático mensual del inventario (GES-213)
  - Bloqueo de movimientos anteriores al cierre (GES-214)
  - Preservación de integridad histórica

## Modelo de Datos

### Entidades del Sistema

#### 🔐 **Usuarios y Autenticación**

##### **Users**

| Campo    | Tipo de datos | **Descripción**                                                     | Restricciones  |
| -------- | ------------- | ------------------------------------------------------------------- | -------------- |
| User_id  | SERIAL        | Identificador único del usuario.                                    | Llave primaria |
| Name     | VARCHAR(25)   | Nombre completo del usuario.                                        | Obligatorio    |
| Email    | VARCHAR(254)  | Correo electrónico del usuario (para autenticación y contacto).     | Obligatorio    |
| Password | VARCHAR(40)   | Contraseña encriptada del usuario.                                  | Obligatorio    |
| Role_id  | INT           | Referencia al rol que tiene asignado el usuario.                    | Llave foránea  |
| State_id | INT           | **Estado** del usuario en el sistema (activo, inactivo, bloqueado). | Llave foránea  |

##### **Roles**

| Campo     | Tipo de datos | **Descripción**                                             | Restricciones  |
| --------- | ------------- | ----------------------------------------------------------- | -------------- |
| Role_Id   | SERIAL        | Identificador único del rol en el sistema.                  | Llave primaria |
| Role_name | VARCHAR       | Nombre del rol (ejemplo: Administrador, Operador, Cliente). | Obligatorio    |

##### **User_states**

| Campo      | Tipo de datos | **Descripción**                                           | Restricciones      |
| ---------- | ------------- | --------------------------------------------------------- | ------------------ |
| State_id   | SERIAL        | Identificador del **Estado** de usuario.                  | Llave primaria     |
| State_name | VARCHAR(20)   | Nombre del **Estado** (ej.: activo, inactivo, bloqueado). | Obligatorio; Único |

#### 📦 **Productos**

##### **Products**

| Campo               | Tipo de datos | **Descripción**                                        | Restricciones  |
| ------------------- | ------------- | ------------------------------------------------------ | -------------- |
| Product_id          | SERIAL        | Identificador único del producto.                      | Llave primaria |
| Product_name        | VARCHAR       | Nombre del producto.                                   | Obligatorio    |
| Product_description | VARCHAR       | **Descripción** breve del producto.                    |                |
| Product_code        | VARCHAR       | Código interno del producto.                           |                |
| Unit_price          | DECIMAL(10,2) | Precio unitario vigente.                               | Obligatorio    |
| Category_id         | INT           | Referencia a la categoría del producto.                | Llave foránea  |
| Measurement_id      | INT           | Id de la unidad de medida                              | Llave foránea  |
| State_id            | INT           | **Estado** del producto (activo, descontinuado, etc.). | Llave foránea  |

##### **Product_categories**

| Campo         | Tipo de datos | **Descripción**                                           | Restricciones      |
| ------------- | ------------- | --------------------------------------------------------- | ------------------ |
| Category_id   | SERIAL        | Identificador único de la categoría de producto.          | Llave primaria     |
| Category_name | VARCHAR       | Nombre de la categoría de producto (ej: bebidas, snacks). | Obligatorio; Único |

##### **Product_states**

| Campo      | Tipo de datos | **Descripción**                                | Restricciones      |
| ---------- | ------------- | ---------------------------------------------- | ------------------ |
| State_id   | SERIAL        | Identificador del **Estado** del producto.     | Llave primaria     |
| State_name | VARCHAR       | Nombre del **Estado** (activo, descontinuado). | Obligatorio; Único |

##### **Measurements_types**

| Campo            | Tipo de datos | **Descripción**                                 | Restricciones      |
| ---------------- | ------------- | ----------------------------------------------- | ------------------ |
| Measurement_id   | SERIAL        | Identificador de la unidad de medida.           | Llave primaria     |
| Measurement_name | VARCHAR       | Nombre de la unidad (unidad, kilogramo, litro). | Obligatorio; Único |

#### 📦 **Sistema RFID y Lotes**

##### **Batches**

| Campo       | Tipo de datos | **Descripción**                                  | Restricciones  |
| ----------- | ------------- | ------------------------------------------------ | -------------- |
| Lot_id      | SERIAL        | Identificador único del lote de productos.       | Llave primaria |
| RFID_code   | VARCHAR(40)   | Código RFID para identificar y rastrear el lote. | Obligatorio    |
| Description | VARCHAR(200)  | Breve **Descripción** del lote.                  |                |
| Entry_date  | DATETIME      | Fecha de ingreso del lote al inventario.         | Obligatorio    |

#### 📊 **Control de Inventario**

##### **Inventory**

| Campo         | Tipo de datos | **Descripción**                                            | Restricciones  |
| ------------- | ------------- | ---------------------------------------------------------- | -------------- |
| Inventory_id  | SERIAL        | Identificador del registro de inventario para un producto. | Llave primaria |
| Product_id    | INT           | Producto al que corresponde este stock.                    | Llave foránea  |
| Lot_id        | INT           | Lote específico al que corresponde este stock.             | Llave foránea  |
| Actual_stock  | INT           | Cantidad actual disponible en inventario.                  | Obligatorio    |
| Minimum_stock | INT           | Cantidad mínima para activar alerta de reposición.         |                |

##### **Inventory_movements**

| Campo         | Tipo de datos   | **Descripción**                                   | Restricciones              |
| ------------- | --------------- | ------------------------------------------------- | -------------------------- |
| Movement_id   | SERIAL          | Identificador único del movimiento de inventario. | Llave primaria             |
| Product_id    | INT             | Producto asociado al movimiento.                  | Llave foránea; Obligatorio |
| Lot_id        | INT             | Lote relacionado al movimiento.                   | Llave foránea              |
| Movement_type | VARCHAR         | Tipo de movimiento (entrada, salida, ajuste).     | Obligatorio                |
| Quantity      | INT             | Cantidad involucrada en el movimiento.            | Obligatorio                |
| Movement_date | TIMESTAMP NOW() | Fecha y hora del movimiento.                      | Obligatorio                |
| Reference     | VARCHAR         | Referencia opcional                               |                            |
| User_id       | INT             | Usuario responsable del movimiento.               | Llave foránea              |

##### **Inventory_closure**

| Campo        | Tipo de datos | **Descripción**                               | Restricciones              |
| ------------ | ------------- | --------------------------------------------- | -------------------------- |
| Closure_id   | SERIAL        | Identificador único del cierre de inventario. | Llave primaria             |
| Product_id   | INT           | Producto incluido en el cierre.               | Llave foránea; Obligatorio |
| Lot_id       | INT           | Lote incluido en el cierre.                   | Llave foránea              |
| Final_stock  | INT           | Cantidad final registrada en el cierre.       | Obligatorio                |
| Closure_date | TIMESTAMP     | Fecha en la que se realizó el cierre.         | Obligatorio                |
| User_id      | INT           | Usuario que ejecutó el cierre.                | Llave foránea              |

#### 💰 **Sistema de Ventas**

##### **Sales**

| Campo         | Tipo de datos | **Descripción**                  | Restricciones  |
| ------------- | ------------- | -------------------------------- | -------------- |
| Sale_id       | SERIAL        | Identificador único de la venta. | Llave primaria |
| Date          | DATETIME      | Fecha y hora de la venta.        | Obligatorio    |
| Total_sale    | DECIMAL(10,2) | Valor total de la venta.         | Obligatorio    |
| Sale_state_id | INT           | Id del **Estado** de la venta.   | Llave foránea  |
| User_id       | INT           | Usuario que registró la venta.   | Llave foránea  |
| Observation   | VARCHAR(255)  | Nota u observación asociada.     |                |

##### **Sale_detail**

| Campo          | Tipo de datos | **Descripción**                           | Restricciones  |
| -------------- | ------------- | ----------------------------------------- | -------------- |
| Sale_detail_id | SERIAL        | Identificador único del detalle de venta. | Llave primaria |
| Sale_id        | INT           | Referencia a la venta asociada.           | Obligatorio    |
| Product_id     | INT           | Producto vendido en la transacción.       | Obligatorio    |
| Quantity       | INT           | Cantidad del producto vendida.            | Obligatorio    |
| Unit_price     | DECIMAL(10,2) | Precio unitario aplicado.                 | Obligatorio    |
| Subtotal       | DECIMAL(10,2) | Subtotal (Cantidad × Precio unitario).    | Obligatorio    |

##### **Sales_states**

| Campo         | Tipo de datos | **Descripción**                              | Restricciones      |
| ------------- | ------------- | -------------------------------------------- | ------------------ |
| Sale_state_id | SERIAL        | Identificador del **Estado** de la venta.    | Llave primaria     |
| State_name    | VARCHAR(20)   | Nombre del **Estado** (registrada, anulada). | Obligatorio; Único |

### Diagrama de Entidad-Relación

![Diagrama de entidad relación](https://i.imgur.com/292cYSe.png)

> Puedes acceder al modelo entidad relación con más detalle: https://i.imgur.com/292cYSe.png

### Detalle historias de usuario

1. - **Historia de usuario**:: GES-2
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como administrador/usuario necesito poder registrar usuarios en el sistema de inventarios para que el personal tenga acceso al sistema de inventarios
   - **Estado**:: Completo

2. - **Historia de usuario**:: GES-3
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito poder iniciar sesión en el sistema de inventarios para poder gestionar el inventario.
   - **Estado**:: Completo

3. - **Historia de usuario**:: GES-4
   - **Autor**:: Juan Pablo Cardona Bedoya
   - **Descripción**:: Yo como usuario necesito poder recuperar mi contraseña en caso de olvidarla para recuperar el acceso a mi cuenta.
   - **Estado**:: Completo

4. - **Historia de usuario**:: GES-47
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito registrar un producto en el gestor de inventarios para gestionarlo después
   - **Estado**:: Completo

5. - **Historia de usuario**:: GES-58
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito actualizar categoría, nombre, precio de un producto en el sistema de inventario en caso de que requiera cambiar información ya registrada
   - **Estado**:: Completo

6. - **Historia de usuario**:: GES-69
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito poder visualizar el producto ya creado en el sistema de inventario
   - **Estado**:: Completo

7. - **Historia de usuario**:: GES-77
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito poder tener una vista general de todo el sistema de inventario donde visualice todos los atributos de cada producto.
   - **Estado**:: Completo

8. - **Historia de usuario**:: GES-85
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como usuario necesito poder actualizar las existencias de un producto ya creado en el sistema de inventario
   - **Estado**:: Completo

9. - **Historia de usuario**:: GES-94
   - **Autor**:: Felipe Villa Jaramillo
   - **Descripción**:: Yo como un usuario necesito poder eliminar un producto del sistema de inventario
   - **Estado**:: Completo

10. - **Historia de usuario**:: GES-103
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como usuario necesito poder filtrar la visualización del inventario por atributos del producto como: categoría, precio, existencias
    - **Estado**:: Completo

11. - **Historia de usuario**:: GES-112
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito poder eliminar usuarios para revocar su acceso cuando ya no hacen parte del equipo.
    - **Estado**:: Completo

12. - **Historia de usuario**:: GES-117
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito poder ver un listado de todos los usuarios registrados en el sistema para llevar control del personal con acceso.
    - **Estado**:: Completo

13. - **Historia de usuario**:: GES-118
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como usuario necesito recibir una alerta cuando las existencias de un producto estén por debajo de un umbral mínimo para tomar decisiones de reposición.
    - **Estado**:: Completo

14. - **Historia de usuario**:: GES-119
    - **Autor**::
    - **Descripción**:: Yo como usuario necesito poder consultar un historial de modificaciones realizadas a los productos para rastrear cambios importantes.
    - **Estado**:: Incompleto

15. - **Historia de usuario**:: GES-131
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como usuario necesito poder determinar cual es el stock mínimo de un producto para que se dispare la alerta de bajas existencias de producto
    - **Estado**:: Completo

16. - **Historia de usuario**:: GES-152
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito asignar diferentes roles a los usuarios para delimitar sus funciones dentro del sistema.
    - **Estado**:: Completo

17. - **Historia de usuario**:: GES-159
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como administrador necesito escanear una etiqueta RFID de un lote para que el sistema registre automáticamente los productos que contiene.
    - **Estado**:: Completo

18. - **Historia de usuario**:: GES-160
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario necesito que el sistema valide si el lote ya fue ingresado anteriormente para evitar duplicados en el inventario.
    - **Estado**:: Completo

19. - **Historia de usuario**:: GES-162
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como cajero necesito buscar un producto desde el sistema para añadirlo a la venta.
    - **Estado**:: Completo

20. - **Historia de usuario**:: GES-164
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como cajero necesito emitir un comprobante de venta que muestre productos, cantidades, precios y totales.
    - **Estado**:: Completo

21. - **Historia de usuario**:: GES-166
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito generar un reporte general del inventario con las unidades disponibles por producto.
    - **Estado**:: Completo

22. - **Historia de usuario**:: GES-167
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito generar un reporte de productos vendidos por categoría para entender la demanda.
    - **Estado**:: Completo

23. - **Historia de usuario**:: GES-168
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador necesito generar un reporte de ingresos por lote para conocer cuándo y qué productos entraron.
    - **Estado**:: Completo

24. - **Historia de usuario**:: GES-200
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: La aplicación debe validar en menos de 2 segundos si las credenciales son correctas al iniciar sesión.
    - **Estado**:: Por validar

25. - **Historia de usuario**:: GES-201
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Solo los usuarios con el rol de administrador deben tener acceso a las funciones de registro, eliminación y asignación de roles.
    - **Estado**:: Completo

26. - **Historia de usuario**:: GES-202
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: La búsqueda de productos en el inventario debe completarse en menos de 2 segundos.
    - **Estado**:: Por validar

27. - **Historia de usuario**:: GES-203
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Las alertas de stock mínimo deben mostrarse al menos una vez por día hasta que se reponga el inventario.
    - **Estado**:: Completo

28. - **Historia de usuario**:: GES-204
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: El sistema debe evitar la sobreventa mediante validación en tiempo real del inventario actualizado.
    - **Estado**:: Completo

29. - **Historia de usuario**:: GES-205
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Las operaciones de venta deben estar disponibles únicamente para usuarios con el rol de cajero o administrador.
    - **Estado**:: Completo

30. - **Historia de usuario**:: GES-206
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Todos los reportes deben poder exportarse a formato Excel.
    - **Estado**:: Completo

31. - **Historia de usuario**:: GES-208
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: La aplicación debe ser accesible desde cualquier navegador moderno.
    - **Estado**:: Completo

32. - **Historia de usuario**:: GES-210
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: La interfaz debe estar diseñada para ser intuitiva y usable por personal sin conocimientos técnicos avanzados.
    - **Estado**:: Completo

33. - **Historia de usuario**:: GES-211
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador, quiero calcular y visualizar el stock consolidado por producto, para tener claridad del inventario real disponible.
    - **Estado**:: Completo

34. - **Historia de usuario**:: GES-212
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como administrador, quiero exportar el consolidado a PDF o Excel, para compartir y analizar la información fácilmente.
    - **Estado**:: Completo

35. - **Historia de usuario**:: GES-213
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como administrador, quiero que se registre automáticamente un snapshot del inventario al final de cada mes, para contar con un historial confiable de cierres mensuales.
    - **Estado**:: Completo

36. - **Historia de usuario**:: GES-214
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como administrador, quiero que los movimientos anteriores al cierre mensual queden bloqueados y no puedan ser modificados, para preservar la integridad del inventario histórico.
    - **Estado**:: Completo

37. - **Historia de usuario**:: GES-215
    - **Autor**:: Felipe Villa Jaramillo
    - **Descripción**:: Yo como administrador, quiero consultar y exportar los cierres mensuales históricos, para realizar análisis y auditorías de inventario.
    - **Estado**:: Completo

38. - **Historia de usuario**:: GES-216
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario necesito acceder a la vista de inventario para consultar los productos disponibles y sus atributos.
    - **Estado**:: Completo

39. - **Historia de usuario**:: GES-217
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como administrador necesito acceder a la vista de reportes para generar, filtrar y visualizar la información consolidada.
    - **Estado**:: Completo

40. - **Historia de usuario**:: GES-218
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como administrador necesito acceder a la vista de clientes para gestionar y consultar la información de los clientes registrados.
    - **Estado**:: Completo

41. - **Historia de usuario**:: GES-219
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como administrador necesito acceder a la vista de proveedores para gestionar la información de los proveedores y validar sus estados.
    - **Estado**:: Completo

42. - **Historia de usuario**:: GES-220
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario necesito acceder a la vista de historial de movimientos para consultar entradas y salidas de productos.
    - **Estado**:: Completo

43. - **Historia de usuario**:: GES-221
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario/administrador necesito acceder a la vista de compras para registrar y consultar las compras realizadas.
    - **Estado**:: Completo

44. - **Historia de usuario**:: GES-222
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario/administrador necesito acceder a la vista de alertas para monitorear el estado crítico de productos y actuar a tiempo.
    - **Estado**:: Completo

45. - **Historia de usuario**:: GES-223
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como administrador necesito acceder a la vista de proyecciones para consultar predicciones de inventario y tomar decisiones estratégicas.
    - **Estado**:: Completo

46. - **Historia de usuario**:: GES-224
    - **Autor**:: Luis Pablo Goez Sepulveda
    - **Descripción**:: Yo como usuario/administrador necesito acceder al dashboard para visualizar métricas clave y tener una visión general del sistema.
    - **Estado**:: Completo

47. - **Historia de usuario**:: GES-225
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como usuario necesito acceder a la vista de inicio de sesión para ingresar al sistema con mis credenciales y gestionar el inventario.
    - **Estado**:: Completo

48. - **Historia de usuario**:: GES-226
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como usuario necesito acceder a la vista de registro de usuarios para crear mi nueva cuenta.
    - **Estado**:: Completo

49. - **Historia de usuario**:: GES-227
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como usuario necesito acceder a la vista de recuperación de contraseña para restablecer mi clave en caso de olvido y recuperar el acceso al sistema.
    - **Estado**:: Completo

50. - **Historia de usuario**:: GES-228
    - **Autor**:: Juan Pablo Cardona Bedoya
    - **Descripción**:: Yo como usuario necesito poder cambiar la contraseña de mi cuenta para tener control de la misma.
    - **Estado**:: Completo

---

**Equipo de Desarrollo**: GeStock Development Team  
**Versión**: 1.0.0  
**Fecha**: Noviembre 2025

18. - **Historia de usuario**:: GES-162
    - **Autor**::
    - **Descripción**:: Yo como cajero necesito buscar un producto desde el sistema para añadirlo a la venta.
    - **Estado**:: Incompleto

19. - **Historia de usuario**:: GES-164
    - **Autor**::
    - **Descripción**:: Yo como cajero necesito emitir un comprobante de venta que muestre productos, cantidades, precios y totales.
    - **Estado**:: Incompleto

20. - **Historia de usuario**:: GES-166
    - **Autor**::
    - **Descripción**:: Yo como administrador necesito generar un reporte general del inventario con las unidades disponibles por producto.
    - **Estado**:: Incompleto

21. - **Historia de usuario**:: GES-167
    - **Autor**::
    - **Descripción**:: Yo como administrador necesito generar un reporte de productos vendidos por categoría para entender la demanda.
    - **Estado**:: Incompleto

22. - **Historia de usuario**:: GES-168
    - **Autor**::
    - **Descripción**:: Yo como administrador necesito generar un reporte de ingresos por lote para conocer cuándo y qué productos entraron.
    - **Estado**:: Incompleto

23. - **Historia de usuario**:: GES-200
    - **Autor**::
    - **Descripción**:: La aplicación debe validar en menos de 2 segundos si las credenciales son correctas al iniciar sesión.
    - **Estado**:: Incompleto

24. - **Historia de usuario**:: GES-201
    - **Autor**::
    - **Descripción**:: Solo los usuarios con el rol de administrador deben tener acceso a las funciones de registro, eliminación y asignación de roles.
    - **Estado**:: Incompleto

25. - **Historia de usuario**:: GES-202
    - **Autor**::
    - **Descripción**:: La búsqueda de productos en el inventario debe completarse en menos de 2 segundos.
    - **Estado**:: Incompleto

26. - **Historia de usuario**:: GES-203
    - **Autor**::
    - **Descripción**:: Las alertas de stock mínimo deben mostrarse al menos una vez por día hasta que se reponga el inventario.
    - **Estado**:: Incompleto

27. - **Historia de usuario**:: GES-204
    - **Autor**::
    - **Descripción**:: El sistema debe evitar la sobreventa mediante validación en tiempo real del inventario actualizado.
    - **Estado**:: Incompleto

28. - **Historia de usuario**:: GES-205
    - **Autor**::
    - **Descripción**:: Las operaciones de venta deben estar disponibles únicamente para usuarios con el rol de cajero o administrador.
    - **Estado**:: Incompleto

29. - **Historia de usuario**:: GES-206
    - **Autor**::
    - **Descripción**:: Todos los reportes deben poder exportarse a formatos PDF y Excel.
    - **Estado**:: Incompleto

30. - **Historia de usuario**:: GES-208
    - **Autor**::
    - **Descripción**:: La aplicación debe ser accesible desde cualquier navegador moderno.
    - **Estado**:: Incompleto

31. - **Historia de usuario**:: GES-209
    - **Autor**::
    - **Descripción**:: La aplicación debe contar con respaldo automático de la base de datos al menos una vez a la semana.
    - **Estado**:: Incompleto

32. - **Historia de usuario**:: GES-210
    - **Autor**::
    - **Descripción**:: La interfaz debe estar diseñada para ser intuitiva y usable por personal sin conocimientos técnicos avanzados.
    - **Estado**:: Incompleto

33. - **Historia de usuario**:: GES-211
    - **Autor**::
    - **Descripción**:: Yo como administrador, quiero calcular y visualizar el stock consolidado por producto, para tener claridad del inventario real disponible.
    - **Estado**:: Incompleto

34. - **Historia de usuario**:: GES-212
    - **Autor**::
    - **Descripción**:: Yo como administrador, quiero exportar el consolidado a PDF o Excel, para compartir y analizar la información fácilmente.
    - **Estado**:: Incompleto

35. - **Historia de usuario**:: GES-213
    - **Autor**::
    - **Descripción**:: Yo como administrador, quiero que se registre automáticamente un snapshot del inventario al final de cada mes, para contar con un historial confiable de cierres mensuales.
    - **Estado**:: Incompleto

36. - **Historia de usuario**:: GES-214
    - **Autor**::
    - **Descripción**:: Yo como administrador, quiero que los movimientos anteriores al cierre mensual queden bloqueados y no puedan ser modificados, para preservar la integridad del inventario histórico.
    - **Estado**:: Incompleto

37. - **Historia de usuario**:: GES-215
    - **Autor**::
    - **Descripción**:: Yo como administrador, quiero consultar y exportar los cierres mensuales históricos, para realizar análisis y auditorías de inventario.
    - **Estado**:: Incompleto

---

**Equipo de Desarrollo**: GeStock Development Team  
**Versión**: 1.0.0  
**Fecha**: Octubre 2025
