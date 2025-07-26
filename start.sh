#!/bin/bash

# Script di avvio per Exploras Agent con Docker

echo "🚀 Avvio di Exploras Agent con Docker..."

# Controlla se Docker è installato
if ! command -v docker &> /dev/null; then
    echo "❌ Docker non è installato. Installare Docker prima di continuare."
    exit 1
fi

# Controlla se Docker Compose è installato
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose non è installato. Installare Docker Compose prima di continuare."
    exit 1
fi

# Build e avvio dei container
echo "🔨 Building dei container..."
docker-compose build

echo "🚀 Avvio dei servizi..."
docker-compose up -d

# Attendi che i servizi siano pronti
echo "⏳ Attendo che i servizi siano pronti..."
sleep 10

# Controlla lo stato dei container
echo "📊 Status dei container:"
docker-compose ps

echo ""
echo "✅ Exploras Agent è ora disponibile su:"
echo "   Frontend: http://localhost"
echo "   Backend API: http://localhost:8000"
echo ""
echo "Per fermare i servizi: docker-compose down"
echo "Per vedere i log: docker-compose logs -f"
