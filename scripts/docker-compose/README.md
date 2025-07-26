# Docker Compose Scripts 🐳

Scripts for local development with Docker Compose.

## 📦 Available Scripts

- **`start.sh`** (Linux/Mac/WSL) - Start application with Docker Compose
- **`start.ps1`** (Windows) - Start application with Docker Compose

## 🚀 Quick Start

```bash
# Linux/Mac/WSL
./scripts/docker-compose/start.sh

# Windows PowerShell
scripts\docker-compose\start.ps1
```

## 📋 Prerequisites

- Docker Desktop installed
- Docker Compose available
- Git (to clone the repository)

## 🔧 What These Scripts Do

1. ✅ **Validate Environment**: Check Docker and Docker Compose installation
2. ✅ **Build Services**: Build backend and frontend containers
3. ✅ **Start Services**: Launch all services in detached mode
4. ✅ **Show Status**: Display container status and health
5. ✅ **Provide Access**: Show URLs and access instructions

## 🌐 Access After Start

- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

## 🛠️ Additional Commands

```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Complete cleanup
docker-compose down -v --rmi all
```

## 🔄 Development Workflow

1. Make code changes
2. Run the start script to rebuild and restart
3. Access the application at http://localhost
4. Use `docker-compose logs -f` to monitor

## 🆘 Troubleshooting

If containers fail to start:
```bash
# Check Docker status
docker info

# Rebuild from scratch
docker-compose down -v
docker-compose up --build
```
