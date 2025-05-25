# GM Financial DevOps Demo

This project demonstrates a comprehensive DevOps setup on Azure, showcasing technologies and practices relevant to GM Financial's requirements.

## 🏗️ Architecture

### Infrastructure Components
- **Azure Kubernetes Service (AKS)** - Container orchestration
- **Azure Container Registry (ACR)** - Private container registry
- **Azure Event Hub** - Event streaming service
- **Azure Redis Cache** - In-memory caching
- **Azure Blob Storage** - Object storage
- **Azure DNS** - Domain name management
- **Azure Monitor + Application Insights** - Monitoring and logging

### Applications
1. **Loan API** (`loan-api`) - Express.js API for loan application processing
2. **Vehicle Telemetry API** (`vehicle-telemetry-api`) - Express.js API for vehicle data

### Monitoring Stack
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Azure Monitor** - Cloud-native monitoring

## 🚀 Deployment

### Prerequisites
- Azure CLI installed and logged in
- Terraform installed
- kubectl installed
- Docker installed

### Quick Start
```bash
# Clone and navigate to the project
cd /path/to/azure-testing

# Run the deployment script
./deploy.sh
```

### Manual Deployment Steps

1. **Deploy Infrastructure**
   ```bash
   terraform init
   terraform plan -var-file="tfvars/prod.tfvars"
   terraform apply -var-file="tfvars/prod.tfvars"
   ```

2. **Build and Push Images**
   ```bash
   # Login to ACR
   az acr login --name seanshickeyacr
   
   # Build loan-api
   cd apps/loan-api
   docker build -t seanshickeyacr.azurecr.io/loan-api:latest .
   docker push seanshickeyacr.azurecr.io/loan-api:latest
   
   # Build vehicle-telemetry-api
   cd ../vehicle-telemetry-api
   docker build -t seanshickeyacr.azurecr.io/vehicle-telemetry-api:latest .
   docker push seanshickeyacr.azurecr.io/vehicle-telemetry-api:latest
   ```

3. **Configure kubectl**
   ```bash
   az aks get-credentials --resource-group k8s-resource-group --name k8s-cluster
   ```

4. **Deploy Applications**
   ```bash
   kubectl apply -f modules/k8s-manifests/
   ```

## 📋 API Endpoints

### Loan API (Port 3001)
- `GET /health` - Health check
- `POST /api/loan/apply` - Submit loan application
- `GET /api/loan/:id` - Get loan application details
- `GET /api/loan/status/:id` - Get loan application status
- `GET /api/stats` - Get loan statistics

### Vehicle Telemetry API (Port 3002)
- `GET /health` - Health check
- `GET /metrics` - Prometheus metrics
- `GET /api/vehicle/telemetry/:vehicleId` - Get vehicle telemetry
- `GET /api/vehicle/fleet-status` - Get fleet status
- `POST /api/vehicle/alert` - Create vehicle alert
- `GET /api/vehicle/maintenance/:vehicleId` - Get maintenance info

## 🔧 Technologies Demonstrated

### Cloud Technologies
- ✅ Azure Kubernetes Service (AKS)
- ✅ Azure Event Hub
- ✅ Azure Virtual Machines
- ✅ Azure Blob Storage
- ✅ Azure DNS
- ✅ Azure Redis Cache
- ✅ Azure Container Registry

### DevOps Tools
- ✅ Terraform (Infrastructure as Code)
- ✅ Docker (Containerization)
- ✅ Kubernetes (Orchestration)
- ✅ Prometheus (Monitoring)
- ✅ Grafana (Visualization)

### Development
- ✅ Node.js/Express.js APIs
- ✅ RESTful API design
- ✅ Microservices architecture
- ✅ Health checks and metrics

### Monitoring & Operations
- ✅ Prometheus metrics collection
- ✅ Grafana dashboards
- ✅ Azure Monitor integration
- ✅ Application Insights

## 🌐 DNS Configuration

Update your DNS provider to point these subdomains to the LoadBalancer IPs:

```
loan-api.seanshickey.com -> [LOAN_API_IP]
vehicle-api.seanshickey.com -> [VEHICLE_API_IP]
grafana.seanshickey.com -> [GRAFANA_IP]
```

## 📊 Monitoring

### Grafana Access
- URL: `http://[GRAFANA_IP]:3000`
- Username: `admin`
- Password: `admin123`

### Prometheus Access
- URL: `http://[PROMETHEUS_IP]:9090`

### Example Queries
```promql
# HTTP request rate
rate(http_request_duration_ms_count[5m])

# Vehicle data events
rate(vehicle_data_events_total[5m])

# Memory usage
container_memory_usage_bytes
```

## 🔄 CI/CD Integration

This setup is ready for CI/CD integration with:
- **Azure DevOps** - Azure-native CI/CD
- **Jenkins** - Open-source automation
- **GitHub Actions** - Git-integrated CI/CD

## 🧪 Testing the APIs

### Test Loan API
```bash
# Submit a loan application
curl -X POST http://loan-api.seanshickey.com/api/loan/apply \
  -H "Content-Type: application/json" \
  -d '{
    "applicantName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "annualIncome": 75000,
    "loanAmount": 25000,
    "loanPurpose": "vehicle",
    "creditScore": 720,
    "employmentStatus": "employed"
  }'
```

### Test Vehicle API
```bash
# Get vehicle telemetry
curl http://vehicle-api.seanshickey.com/api/vehicle/telemetry/GM1234

# Get fleet status
curl http://vehicle-api.seanshickey.com/api/vehicle/fleet-status
```

## 📂 Project Structure

```
.
├── apps/
│   ├── loan-api/                 # Loan processing API
│   └── vehicle-telemetry-api/    # Vehicle telemetry API
├── modules/
│   ├── azure-services/           # Azure services (ACR, Event Hub, etc.)
│   ├── k8s/                      # Kubernetes cluster
│   ├── k8s-manifests/           # Kubernetes deployments
│   ├── monitoring/              # Monitoring infrastructure
│   └── vm/                      # Virtual machine module
├── tfvars/
│   └── prod.tfvars              # Production variables
├── main.tf                      # Main Terraform configuration
├── deploy.sh                    # Deployment script
└── README.md                    # This file
```

## 🎯 Skills Demonstrated

This project showcases experience with:

1. **Cloud Computing**: Azure services, hybrid cloud concepts
2. **Infrastructure as Code**: Terraform, Azure ARM Templates equivalent
3. **Containerization**: Docker, Kubernetes, AKS
4. **Monitoring**: Prometheus, Grafana, Azure Monitor
5. **APIs**: RESTful services, microservices architecture
6. **DevOps**: CI/CD readiness, automation, configuration management
7. **Scripting**: Bash automation, deployment scripts
8. **Networking**: DNS management, Load Balancers, Ingress
9. **Security**: Secrets management, RBAC, network security

Perfect for demonstrating DevOps capabilities for GM Financial! 🚗💰
