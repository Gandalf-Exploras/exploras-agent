#!/bin/bash

# Script di cleanup per Exploras Agent

echo "🧹 Cleanup di Exploras Agent da MicroK8s..."

# Rimuovi tutti i manifests
microk8s kubectl delete -f .

# Rimuovi le immagini dal registry locale
echo "🗑️ Rimozione immagini dal registry..."
microk8s kubectl delete deployment exploras-backend exploras-frontend
microk8s kubectl delete service exploras-backend-service exploras-frontend-service
microk8s kubectl delete ingress exploras-ingress
microk8s kubectl delete configmap exploras-config

echo "✅ Cleanup completato!"
echo ""
echo "Per rimuovere completamente:"
echo "  docker rmi localhost:32000/exploras-backend:latest"
echo "  docker rmi localhost:32000/exploras-frontend:latest"
