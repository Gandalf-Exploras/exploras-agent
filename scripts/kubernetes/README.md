# Kubernetes Deployment Scripts ☸️

Scripts for production deployment on MicroK8s/Kubernetes.

## 📦 Available Scripts

### Complete Deployment
- **`deploy-all.sh`** (Linux/Mac/WSL) - Deploy complete application (backend + frontend + ingress)
- **`deploy-all.bat`** (Windows) - Deploy complete application (backend + frontend + ingress)

### Individual Component Deployment
- **`deploy-backend.sh`** (Linux/Mac/WSL) - Deploy only the FastAPI backend
- **`deploy-backend.bat`** (Windows) - Deploy only the FastAPI backend
- **`deploy-frontend.sh`** (Linux/Mac/WSL) - Deploy only the Angular frontend
- **`deploy-frontend.bat`** (Windows) - Deploy only the Angular frontend

## 🚀 Quick Start

### Complete Deployment (Recommended)
```bash
# Linux/Mac/WSL
./scripts/kubernetes/deploy-all.sh

# Windows
scripts\kubernetes\deploy-all.bat
```

### Individual Components
```bash
# Backend only
./scripts/kubernetes/deploy-backend.sh    # Linux/Mac/WSL
scripts\kubernetes\deploy-backend.bat     # Windows

# Frontend only
./scripts/kubernetes/deploy-frontend.sh   # Linux/Mac/WSL
scripts\kubernetes\deploy-frontend.bat    # Windows
```

## 📋 Prerequisites

Before running these scripts, ensure you have:

1. **MicroK8s installed and configured**:
   ```bash
   sudo snap install microk8s --classic
   sudo usermod -a -G microk8s $USER
   sudo chown -f -R $USER ~/.kube
   newgrp microk8s
   ```

2. **Required addons enabled**:
   ```bash
   microk8s enable registry storage ingress
   ```

3. **Docker installed** (for building images):
   ```bash
   sudo apt update
   sudo apt install docker.io
   sudo usermod -a -G docker $USER
   ```

4. **MicroK8s status verified**:
   ```bash
   microk8s status
   ```

## 🔧 What Each Script Does

### Complete Deployment (`deploy-all.*`)
1. ✅ Build backend Docker image (`localhost:32000/exploras-backend:latest`)
2. ✅ Push backend image to MicroK8s registry
3. ✅ Build frontend Docker image (`localhost:32000/exploras-frontend:latest`)
4. ✅ Push frontend image to MicroK8s registry
5. ✅ Deploy backend to Kubernetes (`k8s/backend.yaml`)
6. ✅ Deploy frontend to Kubernetes (`k8s/frontend.yaml`)
7. ✅ Deploy ingress configuration (`k8s/ingress.yaml`)
8. ✅ Check deployment status and provide access instructions

### Backend Deployment (`deploy-backend.*`)
1. ✅ Build backend Docker image
2. ✅ Push to MicroK8s registry
3. ✅ Deploy backend pod and service
4. ✅ Check pod status and provide testing instructions

### Frontend Deployment (`deploy-frontend.*`)
1. ✅ Build frontend Docker image
2. ✅ Push to MicroK8s registry
3. ✅ Deploy frontend pod and service
4. ✅ Check pod status and provide access instructions

## 🌐 Access Options After Deployment

### Option 1: Port-Forward (Temporary)
```bash
# Access frontend
microk8s kubectl port-forward service/exploras-frontend-service 8080:80
# Then visit http://localhost:8080

# Direct backend API access (for testing)
microk8s kubectl port-forward service/exploras-backend-service 8001:8000
# Then visit http://localhost:8001/docs
```

### Option 2: Ingress (Permanent)
```bash
# Add to hosts file:
# Linux/Mac: /etc/hosts
# Windows: C:\Windows\System32\drivers\etc\hosts
echo "127.0.0.1 exploras.local" | sudo tee -a /etc/hosts

# Then visit http://exploras.local
```

## 🔍 Monitoring and Troubleshooting

### Check Deployment Status
```bash
# Check all pods
microk8s kubectl get pods

# Check specific app pods
microk8s kubectl get pods -l app=exploras-backend
microk8s kubectl get pods -l app=exploras-frontend

# Check services
microk8s kubectl get services

# Check ingress
microk8s kubectl get ingress
```

### View Logs
```bash
# Backend logs
microk8s kubectl logs -l app=exploras-backend -f

# Frontend logs
microk8s kubectl logs -l app=exploras-frontend -f

# All pods logs
microk8s kubectl logs --all-containers -l app=exploras-backend
```

### Debug Connectivity
```bash
# Test backend from frontend pod
microk8s kubectl exec -it <frontend-pod-name> -- wget -q -O - http://exploras-backend-service:8000/health

# Test external connectivity
curl -H "Host: exploras.local" http://localhost/api/toc
```

## 🔄 Redeployment

To redeploy after code changes:

```bash
# Quick redeploy (rebuilds and redeploys everything)
./scripts/kubernetes/deploy-all.sh

# Or redeploy individual components
./scripts/kubernetes/deploy-backend.sh    # After backend changes
./scripts/kubernetes/deploy-frontend.sh   # After frontend changes
```

## 🧹 Cleanup

To remove all deployed resources:

```bash
# Remove all deployments
microk8s kubectl delete -f k8s/

# Or use the cleanup script if available
cd k8s && ./cleanup.sh
```
