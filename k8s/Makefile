# Makefile per Exploras Agent su MicroK8s

.PHONY: help setup build deploy status logs clean

# Help
help:
	@echo "🚀 Exploras Agent - MicroK8s Commands"
	@echo ""
	@echo "Comandi disponibili:"
	@echo "  make setup     - Setup addon MicroK8s"
	@echo "  make build     - Build delle immagini Docker"
	@echo "  make deploy    - Deploy completo su MicroK8s"
	@echo "  make status    - Status di pod e servizi"
	@echo "  make logs      - Log dei pod"
	@echo "  make clean     - Rimuovi tutto da MicroK8s"

# Setup addon MicroK8s
setup:
	@echo "🔧 Setup addon MicroK8s..."
	microk8s enable storage ingress registry

# Build immagini
build:
	@echo "🔨 Build delle immagini Docker..."
	cd ../backend && docker build -t localhost:32000/exploras-backend:latest .
	cd ../frontend && docker build -t localhost:32000/exploras-frontend:latest .
	docker push localhost:32000/exploras-backend:latest
	docker push localhost:32000/exploras-frontend:latest

# Deploy completo
deploy: setup build
	@echo "📦 Deploy su MicroK8s..."
	microk8s kubectl apply -f configmap.yaml
	microk8s kubectl apply -f backend.yaml
	microk8s kubectl apply -f frontend.yaml
	microk8s kubectl apply -f ingress.yaml
	@echo "⏳ Attendo che i pod siano pronti..."
	microk8s kubectl wait --for=condition=ready pod -l app=exploras-backend --timeout=120s
	microk8s kubectl wait --for=condition=ready pod -l app=exploras-frontend --timeout=120s
	@echo "✅ Deploy completato!"
	@echo "Accedi su: http://exploras.local (aggiungi '127.0.0.1 exploras.local' a /etc/hosts)"

# Status
status:
	@echo "📊 Status MicroK8s:"
	microk8s kubectl get pods,svc,ingress -o wide

# Log dei pod
logs:
	@echo "📋 Log del backend:"
	microk8s kubectl logs -l app=exploras-backend --tail=50
	@echo ""
	@echo "📋 Log del frontend:"
	microk8s kubectl logs -l app=exploras-frontend --tail=50

# Cleanup
clean:
	@echo "🧹 Cleanup..."
	microk8s kubectl delete -f . --ignore-not-found=true
	@echo "✅ Cleanup completato!"

# Deploy rapido per sviluppo
dev: build
	@echo "🔧 Deploy di sviluppo..."
	microk8s kubectl delete -f . --ignore-not-found=true
	sleep 2
	microk8s kubectl apply -f .
	microk8s kubectl wait --for=condition=ready pod -l app=exploras-backend --timeout=120s
	microk8s kubectl wait --for=condition=ready pod -l app=exploras-frontend --timeout=120s
