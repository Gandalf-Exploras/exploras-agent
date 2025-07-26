@echo off
echo ================================================
echo  Exploras Agent - Complete Deployment Script
echo ================================================
echo.

echo [1/6] Building backend Docker image...
sudo docker build -t localhost:32000/exploras-backend:latest backend/
if %errorlevel% neq 0 (
    echo ERROR: Failed to build backend image
    pause
    exit /b 1
)
echo ✅ Backend image built successfully

echo.
echo [2/6] Pushing backend image to MicroK8s registry...
sudo docker push localhost:32000/exploras-backend:latest
if %errorlevel% neq 0 (
    echo ERROR: Failed to push backend image
    pause
    exit /b 1
)
echo ✅ Backend image pushed successfully

echo.
echo [3/6] Building frontend Docker image...
sudo docker build -t localhost:32000/exploras-frontend:latest frontend/
if %errorlevel% neq 0 (
    echo ERROR: Failed to build frontend image
    pause
    exit /b 1
)
echo ✅ Frontend image built successfully

echo.
echo [4/6] Pushing frontend image to MicroK8s registry...
sudo docker push localhost:32000/exploras-frontend:latest
if %errorlevel% neq 0 (
    echo ERROR: Failed to push frontend image
    pause
    exit /b 1
)
echo ✅ Frontend image pushed successfully

echo.
echo [5/6] Deploying all services to Kubernetes...
microk8s kubectl apply -f k8s/backend.yaml
microk8s kubectl apply -f k8s/frontend.yaml
microk8s kubectl apply -f k8s/ingress.yaml
if %errorlevel% neq 0 (
    echo ERROR: Failed to deploy to Kubernetes
    pause
    exit /b 1
)
echo ✅ All services deployed successfully

echo.
echo [6/6] Checking deployment status...
timeout /t 10 /nobreak >nul
echo.
echo Pod Status:
microk8s kubectl get pods
echo.
echo Service Status:
microk8s kubectl get services
echo.
echo Ingress Status:
microk8s kubectl get ingress

echo.
echo ================================================
echo  Complete deployment finished!
echo ================================================
echo.
echo Access Options:
echo   1. Port-forward: microk8s kubectl port-forward service/exploras-frontend-service 8080:80
echo      Then visit http://localhost:8080
echo.
echo   2. Ingress: Add '127.0.0.1 exploras.local' to hosts file
echo      Then visit http://exploras.local
echo.
echo Useful Commands:
echo   - Check pods: microk8s kubectl get pods
echo   - View logs: microk8s kubectl logs -l app=exploras-backend -f
echo   - Scale up: microk8s kubectl scale deployment exploras-backend --replicas=2
echo.
pause
