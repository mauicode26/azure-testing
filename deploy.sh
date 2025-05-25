#!/bin/bash

# GM Financial DevOps Demo Deployment Script
# This script deploys the infrastructure and applications

set -e

echo "🚀 Starting GM Financial DevOps Demo Deployment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if required tools are installed
check_tools() {
    echo -e "${YELLOW}Checking required tools...${NC}"
    
    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}Terraform is not installed${NC}"
        exit 1
    fi
    
    if ! command -v az &> /dev/null; then
        echo -e "${RED}Azure CLI is not installed${NC}"
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}kubectl is not installed${NC}"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}All required tools are installed${NC}"
}

# Deploy infrastructure
deploy_infrastructure() {
    echo -e "${YELLOW}Deploying Azure infrastructure...${NC}"
    
    terraform init
    terraform plan -var-file="tfvars/prod.tfvars" -out="plans/deployment.plan"
    terraform apply "plans/deployment.plan"
    
    echo -e "${GREEN}Infrastructure deployed successfully${NC}"
}

# Build and push Docker images
build_and_push_images() {
    echo -e "${YELLOW}Building and pushing Docker images...${NC}"
    
    # Get ACR login server
    ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server 2>/dev/null || echo "seanshickeyacr.azurecr.io")
    
    # Login to ACR
    az acr login --name seanshickeyacr
    
    # Build and push loan API
    echo "Building loan-api..."
    cd apps/loan-api
    docker build -t ${ACR_LOGIN_SERVER}/loan-api:latest .
    docker push ${ACR_LOGIN_SERVER}/loan-api:latest
    cd ../..
    
    # Build and push vehicle telemetry API
    echo "Building vehicle-telemetry-api..."
    cd apps/vehicle-telemetry-api
    docker build -t ${ACR_LOGIN_SERVER}/vehicle-telemetry-api:latest .
    docker push ${ACR_LOGIN_SERVER}/vehicle-telemetry-api:latest
    cd ../..
    
    echo -e "${GREEN}Docker images built and pushed successfully${NC}"
}

# Configure kubectl
configure_kubectl() {
    echo -e "${YELLOW}Configuring kubectl for AKS...${NC}"
    
    az aks get-credentials --resource-group k8s-resource-group --name k8s-cluster --overwrite-existing
    
    echo -e "${GREEN}kubectl configured successfully${NC}"
}

# Create Kubernetes secrets
create_secrets() {
    echo -e "${YELLOW}Creating Kubernetes secrets...${NC}"
    
    # Get secrets from Terraform outputs
    REDIS_PASSWORD=$(terraform output -raw redis_primary_key 2>/dev/null || echo "")
    EVENTHUB_CONNECTION=$(terraform output -raw eventhub_connection_string 2>/dev/null || echo "")
    
    if [ ! -z "$REDIS_PASSWORD" ]; then
        kubectl create secret generic redis-secret \
            --from-literal=password="$REDIS_PASSWORD" \
            --dry-run=client -o yaml | kubectl apply -f -
    fi
    
    if [ ! -z "$EVENTHUB_CONNECTION" ]; then
        kubectl create secret generic eventhub-secret \
            --from-literal=connection-string="$EVENTHUB_CONNECTION" \
            --dry-run=client -o yaml | kubectl apply -f -
    fi
    
    echo -e "${GREEN}Secrets created successfully${NC}"
}

# Deploy applications to Kubernetes
deploy_applications() {
    echo -e "${YELLOW}Deploying applications to Kubernetes...${NC}"
    
    # Deploy APIs
    kubectl apply -f modules/k8s-manifests/apis.yaml
    
    # Deploy monitoring
    kubectl apply -f modules/k8s-manifests/monitoring.yaml
    
    # Wait for deployments to be ready
    echo "Waiting for deployments to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/loan-api
    kubectl wait --for=condition=available --timeout=300s deployment/vehicle-telemetry-api
    kubectl wait --for=condition=available --timeout=300s deployment/prometheus
    kubectl wait --for=condition=available --timeout=300s deployment/grafana
    
    echo -e "${GREEN}Applications deployed successfully${NC}"
}

# Show deployment information
show_info() {
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Services:${NC}"
    kubectl get services
    echo ""
    echo -e "${YELLOW}Access your applications:${NC}"
    
    # Get LoadBalancer IPs
    LOAN_API_IP=$(kubectl get service loan-api-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "Pending...")
    VEHICLE_API_IP=$(kubectl get service vehicle-telemetry-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "Pending...")
    GRAFANA_IP=$(kubectl get service grafana-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "Pending...")
    PROMETHEUS_IP=$(kubectl get service prometheus-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "Pending...")
    
    echo "Loan API: http://${LOAN_API_IP}/health"
    echo "Vehicle Telemetry API: http://${VEHICLE_API_IP}/health"
    echo "Grafana: http://${GRAFANA_IP}:3000 (admin/admin123)"
    echo "Prometheus: http://${PROMETHEUS_IP}:9090"
    echo ""
    echo -e "${YELLOW}DNS Configuration:${NC}"
    echo "Update your DNS records to point:"
    echo "loan-api.seanshickey.com -> ${LOAN_API_IP}"
    echo "vehicle-api.seanshickey.com -> ${VEHICLE_API_IP}"
    echo "grafana.seanshickey.com -> ${GRAFANA_IP}"
    echo ""
    echo -e "${YELLOW}Useful Commands:${NC}"
    echo "kubectl get pods"
    echo "kubectl logs -f deployment/loan-api"
    echo "kubectl logs -f deployment/vehicle-telemetry-api"
}

# Main execution
main() {
    check_tools
    deploy_infrastructure
    build_and_push_images
    configure_kubectl
    create_secrets
    deploy_applications
    show_info
}

# Run main function
main
