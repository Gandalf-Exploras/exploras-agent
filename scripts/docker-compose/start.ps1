# Script PowerShell per avviare Exploras Agent con Docker

Write-Host "🚀 Avvio di Exploras Agent con Docker..." -ForegroundColor Green

# Controlla se Docker è installato
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Docker non è installato. Installare Docker Desktop prima di continuare." -ForegroundColor Red
    exit 1
}

# Controlla se Docker Compose è disponibile
try {
    docker-compose --version | Out-Null
} catch {
    Write-Host "❌ Docker Compose non è disponibile. Assicurarsi che Docker Desktop sia installato correttamente." -ForegroundColor Red
    exit 1
}

# Build e avvio dei container
Write-Host "🔨 Building dei container..." -ForegroundColor Yellow
docker-compose build

Write-Host "🚀 Avvio dei servizi..." -ForegroundColor Yellow
docker-compose up -d

# Attendi che i servizi siano pronti
Write-Host "⏳ Attendo che i servizi siano pronti..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Controlla lo stato dei container
Write-Host "📊 Status dei container:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "✅ Exploras Agent è ora disponibile su:" -ForegroundColor Green
Write-Host "   Frontend: http://localhost" -ForegroundColor White
Write-Host "   Backend API: http://localhost:8000" -ForegroundColor White
Write-Host ""
Write-Host "Per fermare i servizi: docker-compose down" -ForegroundColor Yellow
Write-Host "Per vedere i log: docker-compose logs -f" -ForegroundColor Yellow
