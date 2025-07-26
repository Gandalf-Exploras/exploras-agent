# Kubernetes Deployment Guide

This directory contains all Kubernetes manifests and scripts for deploying Exploras Agent on MicroK8s.

## 🎯 Overview

The Kubernetes deployment provides a production-ready setup with:
- **Backend Service**: FastAPI application with EPUB processing
- **Frontend Service**: Angular + Nginx serving static files and proxying API calls
- **Ingress Controller**: External access via domain name
- **Service Mesh**: Internal DNS resolution between services
- **Container Registry**: MicroK8s local registry for images

## 📁 Files Structure

```
k8s/
├── backend.yaml        # Backend deployment, service, and configuration
├── frontend.yaml       # Frontend deployment, service, and configuration  
├── ingress.yaml        # Ingress controller configuration
├── configmap.yaml      # Configuration maps for environment variables
├── deploy.sh           # Automated deployment script
├── cleanup.sh          # Cleanup and removal script
├── Makefile           # Make commands for common operations
└── README.md          # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Ubuntu 24.04** (or WSL2 with Ubuntu)
2. **MicroK8s installed and running**:
   ```bash
   sudo snap install microk8s --classic
   sudo usermod -a -G microk8s $USER
   newgrp microk8s
   ```

3. **Required MicroK8s addons**:
   ```bash
   microk8s enable registry storage ingress
   ```

### Deployment Steps

1. **Build and push container images**:
   ```bash
   # Build backend
   sudo docker build -t localhost:32000/exploras-backend:latest ../backend/
   sudo docker push localhost:32000/exploras-backend:latest
   
   # Build frontend
   sudo docker build -t localhost:32000/exploras-frontend:latest ../frontend/
   sudo docker push localhost:32000/exploras-frontend:latest
   ```

2. **Deploy to Kubernetes**:
   ```bash
   # Option 1: Use deployment script
   chmod +x deploy.sh
   ./deploy.sh
   
   # Option 2: Manual deployment
   microk8s kubectl apply -f backend.yaml
   microk8s kubectl apply -f frontend.yaml
   microk8s kubectl apply -f ingress.yaml
   
   # Option 3: Use Makefile
   make deploy
   ```

3. **Verify deployment**:
   ```bash
   make status
   # Or manually:
   microk8s kubectl get pods
   microk8s kubectl get services
   microk8s kubectl get ingress
   ```

## 🌐 Accessing the Application

### Method 1: Port Forward (Temporary Access)
```bash
# Frontend access
microk8s kubectl port-forward service/exploras-frontend-service 8080:80

# Backend access (for API testing)
microk8s kubectl port-forward service/exploras-backend-service 8001:8000

# Then visit:
# - Frontend: http://localhost:8080
# - Backend API: http://localhost:8001
```

### Method 2: Ingress (Permanent Access)
```bash
# Add to your hosts file:
# Linux/Mac: /etc/hosts
# Windows: C:\Windows\System32\drivers\etc\hosts
echo "127.0.0.1 exploras.local" | sudo tee -a /etc/hosts

# Then visit: http://exploras.local
```

## 🏗️ Architecture Details

### Service Communication
```
Internet → Ingress → Frontend Service → Frontend Pod (Nginx)
                                     ↓
                                   Backend Service → Backend Pod (FastAPI)
```

### DNS Resolution
- Frontend communicates with backend via: `http://exploras-backend-service:8000`
- Services are accessible within the cluster using their service names
- Kubernetes provides internal DNS resolution automatically

### Container Images
- **Backend**: `localhost:32000/exploras-backend:latest`
- **Frontend**: `localhost:32000/exploras-frontend:latest`
- Images are stored in MicroK8s local registry (`localhost:32000`)

## 🔧 Configuration Details

### Backend Configuration
- **Deployment**: `exploras-backend`
- **Service**: `exploras-backend-service`
- **Port**: 8000 (internal)
- **Replicas**: 1
- **Image**: Multi-stage Python build with FastAPI + dependencies

### Frontend Configuration
- **Deployment**: `exploras-frontend`
- **Service**: `exploras-frontend-service`
- **Port**: 80 (internal)
- **Replicas**: 1
- **Image**: Multi-stage build (Angular build + Nginx serving)
- **Nginx Proxy**: `/api/*` → `http://exploras-backend-service:8000/`

### Ingress Configuration
- **Host**: `exploras.local`
- **Class**: `public` (nginx ingress controller)
- **Rules**: All traffic routed to frontend service

## 🛠️ Make Commands

```bash
make build      # Build and push both container images
make deploy     # Deploy all Kubernetes resources
make status     # Check deployment status
make logs       # View pod logs
make test       # Test connectivity between services
make clean      # Remove all resources
make rebuild    # Clean + build + deploy (full refresh)
```

## 🔍 Troubleshooting

### Check Pod Status
```bash
microk8s kubectl get pods -o wide
microk8s kubectl describe pod <pod-name>
```

### View Pod Logs
```bash
microk8s kubectl logs <pod-name>
microk8s kubectl logs -f <pod-name>  # Follow logs
```

### Test Service Connectivity
```bash
# Test backend health from frontend pod
microk8s kubectl exec -it <frontend-pod> -- wget -q -O - http://exploras-backend-service:8000/health

# Test frontend service from backend pod
microk8s kubectl exec -it <backend-pod> -- python -c "import requests; print(requests.get('http://exploras-frontend-service/').status_code)"
```

### Common Issues

1. **Pod not starting**: Check `microk8s kubectl describe pod <pod-name>` for events
2. **Image pull errors**: Verify images exist in registry with `sudo docker images localhost:32000/*`
3. **Service not accessible**: Check service endpoints with `microk8s kubectl get endpoints`
4. **Ingress not working**: Verify ingress controller is running with `microk8s kubectl get pods -n ingress`

### Debug Commands
```bash
# Check MicroK8s status
microk8s status

# Check registry
sudo docker images localhost:32000/*

# Check DNS resolution
microk8s kubectl run -it --rm debug --image=busybox -- nslookup exploras-backend-service

# Check network connectivity
microk8s kubectl run -it --rm debug --image=busybox -- wget -q -O - http://exploras-backend-service:8000/health
```

## 🔄 Updates and Maintenance

### Update Application
```bash
# Rebuild images
make build

# Rolling update (zero downtime)
microk8s kubectl rollout restart deployment/exploras-backend
microk8s kubectl rollout restart deployment/exploras-frontend

# Check rollout status
microk8s kubectl rollout status deployment/exploras-backend
microk8s kubectl rollout status deployment/exploras-frontend
```

### Scale Applications
```bash
# Scale backend
microk8s kubectl scale deployment exploras-backend --replicas=3

# Scale frontend
microk8s kubectl scale deployment exploras-frontend --replicas=2
```

### Complete Cleanup
```bash
make clean
# Or manually:
microk8s kubectl delete -f .
```

## 📊 Resource Requirements

### Minimum Requirements
- **CPU**: 2 cores
- **Memory**: 2GB RAM
- **Storage**: 5GB for images and data

### Production Recommendations
- **CPU**: 4+ cores
- **Memory**: 4GB+ RAM
- **Storage**: 20GB+ SSD storage
- **Network**: Stable internet connection for image pulls

## 🔐 Security Notes

- Services communicate internally using Kubernetes DNS
- No external access to backend API (only via frontend proxy)
- Ingress provides external access only to frontend
- Container images run with non-root users where possible
- All communication within cluster is unencrypted (consider service mesh for production)

## 📝 Next Steps

For production deployment, consider:
- Adding persistent volumes for data storage
- Implementing horizontal pod autoscaling
- Adding monitoring and logging (Prometheus, Grafana, ELK stack)
- Setting up SSL/TLS certificates for HTTPS
- Implementing proper secrets management
- Adding network policies for enhanced security
