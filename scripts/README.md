# Deployment Scripts 🚀

This directory contains automated deployment scripts for the Exploras Agent application across different environments.

## 📁 Directory Structure

```
scripts/
├── docker-compose/          # Docker Compose deployment scripts
│   ├── start.sh            # Linux/Mac/WSL Docker Compose startup
│   └── start.ps1           # Windows Docker Compose startup
├── kubernetes/             # Kubernetes/MicroK8s deployment scripts
│   ├── deploy-all.sh       # Complete Kubernetes deployment (Linux/Mac/WSL)
│   ├── deploy-all.bat      # Complete Kubernetes deployment (Windows)
│   ├── deploy-backend.sh   # Backend-only deployment (Linux/Mac/WSL)
│   ├── deploy-backend.bat  # Backend-only deployment (Windows)
│   ├── deploy-frontend.sh  # Frontend-only deployment (Linux/Mac/WSL)
│   └── deploy-frontend.bat # Frontend-only deployment (Windows)
└── README.md               # This documentation
```

## 🐳 Docker Compose (Development Environment)

For quick local development and testing:

### Usage
```bash
# Linux/Mac/WSL
./scripts/docker-compose/start.sh

# Windows
scripts\docker-compose\start.ps1
```

### What it does
- ✅ Validates Docker and Docker Compose installation
- ✅ Builds and starts all services via docker-compose.yml
- ✅ Shows service status and access URLs
- ✅ Provides troubleshooting commands

### Access
- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

## ☸️ Kubernetes (Production Environment)

For production-ready deployment on MicroK8s:

### Prerequisites
- Ubuntu 24.04 (or WSL2 with Ubuntu)
- MicroK8s installed with registry, storage, and ingress addons
- Docker for building images

### Complete Deployment
```bash
# Linux/Mac/WSL
./scripts/kubernetes/deploy-all.sh

# Windows
scripts\kubernetes\deploy-all.bat
```

### Individual Component Deployment
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

## 🛠️ Script Features

### Error Handling
- ✅ Each step validates success before proceeding
- ✅ Clear error messages with suggestions
- ✅ Graceful exit on failures

### Progress Tracking
- ✅ Step-by-step progress indicators
- ✅ Success confirmations with checkmarks
- ✅ Final status summary

### Cross-Platform Support
- ✅ Windows batch files (`.bat`)
- ✅ Linux/Mac shell scripts (`.sh`)
- ✅ Identical functionality across platforms

### User-Friendly Output
- ✅ Clear instructions for next steps
- ✅ Access URLs and commands provided
- ✅ Troubleshooting hints included

## 🔄 Redeployment

To redeploy after code changes:

```bash
# Quick redeploy (rebuilds and redeploys everything)
./scripts/kubernetes/deploy-all.sh

# Or redeploy individual components
./scripts/deploy-backend.sh    # After backend changes
./scripts/deploy-frontend.sh   # After frontend changes
```

## 🧹 Cleanup

To remove all deployed resources:

```bash
# Remove all deployments
microk8s kubectl delete -f k8s/

# Or use the cleanup script if available
cd k8s && ./cleanup.sh
```

## ⚡ Performance Tips

1. **Parallel Deployment**: Frontend and backend can be deployed in parallel for faster deployment
2. **Image Caching**: Docker images are cached, subsequent builds are faster
3. **Rolling Updates**: Kubernetes handles zero-downtime updates automatically

## 📝 Customization

To modify deployment parameters:
- Edit the Kubernetes manifests in `k8s/` directory
- Modify Docker build arguments in the scripts
- Adjust resource limits in `k8s/backend.yaml` and `k8s/frontend.yaml`

## 🆘 Support

If you encounter issues:
1. Check the script output for specific error messages
2. Verify MicroK8s status: `microk8s status`
3. Check pod logs: `microk8s kubectl logs <pod-name>`
4. Refer to the main project README.md for detailed troubleshooting

---

**Happy Deploying! 🚀✨**
