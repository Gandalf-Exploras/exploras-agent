#!/bin/bash

# Script di deploy per Exploras Agent su MicroK8s

echo "🚀 Deploy di Exploras Agent su MicroK8s..."

# Verifica che MicroK8s sia attivo
if ! microk8s status | grep -q "microk8s is running"; then
    echo "❌ MicroK8s non è attivo. Avvialo con: microk8s start"
    exit 1
fi

# Abilita addon necessari
echo "🔧 Abilitazione addon MicroK8s..."
microk8s enable storage ingress registry

# Build delle immagini Docker
echo "🔨 Build delle immagini Docker..."

# Build backend
echo "Building backend..."
cd ../backend
docker build -t localhost:32000/exploras-backend:latest .
docker push localhost:32000/exploras-backend:latest

# Build frontend  
echo "Building frontend..."
cd ../frontend
docker build -t localhost:32000/exploras-frontend:latest .
docker push localhost:32000/exploras-frontend:latest

cd ../k8s

# Deploy dei manifests
echo "📦 Deploy dei manifests Kubernetes..."
microk8s kubectl apply -f configmap.yaml
microk8s kubectl apply -f backend.yaml
microk8s kubectl apply -f frontend.yaml

# Attendi che i pod siano pronti
echo "⏳ Attendo che i pod siano pronti..."
microk8s kubectl wait --for=condition=ready pod -l app=exploras-backend --timeout=120s
microk8s kubectl wait --for=condition=ready pod -l app=exploras-frontend --timeout=120s

# Deploy ingress
microk8s kubectl apply -f ingress.yaml

# Mostra stato
echo "📊 Stato del deployment:"
microk8s kubectl get pods,svc,ingress

# Istruzioni per accesso
echo ""
echo "✅ Exploras Agent è ora deployato su MicroK8s!"
echo ""
echo "Per accedere all'applicazione:"
echo "1. Aggiungi al file hosts: echo '127.0.0.1 exploras.local' | sudo tee -a /etc/hosts"
echo "2. Vai su: http://exploras.local"
echo ""
echo "Comandi utili:"
echo "  microk8s kubectl get pods              # Status pod"
echo "  microk8s kubectl logs -f <pod-name>   # Log dei pod"
echo "  microk8s kubectl delete -f .          # Rimuovi tutto"
