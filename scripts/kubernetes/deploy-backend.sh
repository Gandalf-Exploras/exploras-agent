#!/bin/bash

echo "================================================"
echo " Exploras Agent - Backend Deployment Script"
echo "================================================"
echo

echo "[1/4] Building backend Docker image..."
sudo docker build -t localhost:32000/exploras-backend:latest backend/
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build backend image"
    exit 1
fi
echo "✅ Backend image built successfully"

echo
echo "[2/4] Pushing backend image to MicroK8s registry..."
sudo docker push localhost:32000/exploras-backend:latest
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to push backend image"
    exit 1
fi
echo "✅ Backend image pushed successfully"

echo
echo "[3/4] Deploying backend to Kubernetes..."
microk8s kubectl apply -f k8s/backend.yaml
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to deploy backend to Kubernetes"
    exit 1
fi
echo "✅ Backend deployed successfully"

echo
echo "[4/4] Checking backend pod status..."
sleep 5
microk8s kubectl get pods -l app=exploras-backend

echo
echo "================================================"
echo " Backend deployment completed!"
echo "================================================"
echo
echo "To check backend logs:"
echo "  microk8s kubectl logs -l app=exploras-backend -f"
echo
echo "To check backend service:"
echo "  microk8s kubectl get service exploras-backend-service"
echo
echo "To test backend API:"
echo "  microk8s kubectl port-forward service/exploras-backend-service 8001:8000"
echo "  curl http://localhost:8001/toc"
echo
