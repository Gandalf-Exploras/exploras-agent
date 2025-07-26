# Makefile per Exploras Agent

.PHONY: help build up down logs clean restart status

# Help
help:
	@echo "🚀 Exploras Agent - Docker Commands"
	@echo ""
	@echo "Comandi disponibili:"
	@echo "  make build     - Build dei container"
	@echo "  make up        - Avvia i servizi"
	@echo "  make down      - Ferma i servizi"
	@echo "  make restart   - Riavvia i servizi"
	@echo "  make logs      - Mostra i log"
	@echo "  make status    - Status dei container"
	@echo "  make clean     - Rimuove container e immagini"

# Build dei container
build:
	@echo "🔨 Building dei container..."
	docker-compose build

# Avvia i servizi
up:
	@echo "🚀 Avvio dei servizi..."
	docker-compose up -d
	@echo "✅ Servizi avviati!"
	@echo "   Frontend: http://localhost"
	@echo "   Backend: http://localhost:8000"

# Ferma i servizi
down:
	@echo "🛑 Fermando i servizi..."
	docker-compose down

# Riavvia i servizi
restart: down up

# Mostra i log
logs:
	docker-compose logs -f

# Status dei container
status:
	docker-compose ps

# Pulizia completa
clean:
	@echo "🧹 Pulizia completa..."
	docker-compose down -v --rmi all --remove-orphans

# Build e avvio rapido
start: build up

# Sviluppo (con rebuild automatico)
dev:
	@echo "🔧 Modalità sviluppo..."
	docker-compose up --build
