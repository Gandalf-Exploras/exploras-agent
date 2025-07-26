@echo off
echo ================================================
echo  Exploras Agent - Frontend Deployment Script
echo ================================================
echo.

echo [1/4] Building frontend Docker image...
sudo docker build -t localhost:32000/exploras-frontend:latest frontend/
if %errorlevel% neq 0 (
    echo ERROR: Failed to build frontend image
    pause
    exit /b 1
)
echo ✅ Frontend image built successfully

echo.
echo [2/4] Pushing frontend image to MicroK8s registry...
sudo docker push localhost:32000/exploras-frontend:latest
if %errorlevel% neq 0 (
    echo ERROR: Failed to push frontend image
    pause
    exit /b 1
)
echo ✅ Frontend image pushed successfully

echo.
echo [3/4] Deploying frontend to Kubernetes...
microk8s kubectl apply -f k8s/frontend.yaml
if %errorlevel% neq 0 (
    echo ERROR: Failed to deploy frontend to Kubernetes
    pause
    exit /b 1
)
echo ✅ Frontend deployed successfully

echo.
echo [4/4] Checking frontend pod status...
timeout /t 5 /nobreak >nul
microk8s kubectl get pods -l app=exploras-frontend

echo.
echo ================================================
echo  Frontend deployment completed!
echo ================================================
echo.
echo To check frontend logs:
echo   microk8s kubectl logs -l app=exploras-frontend -f
echo.
echo To check frontend service:
echo   microk8s kubectl get service exploras-frontend-service
echo.
echo To access frontend:
echo   microk8s kubectl port-forward service/exploras-frontend-service 8080:80
echo   Then visit http://localhost:8080
echo.
pause
