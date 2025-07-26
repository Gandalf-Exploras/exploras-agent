# Exploras Backend - FastAPI Service

FastAPI backend service for the Exploras Agent EPUB Knowledge Explorer.

## 🎯 Purpose

The backend provides:
- **EPUB Processing**: TOC extraction and content parsing using ebooklib
- **API Endpoints**: RESTful API for frontend integration
- **Q&A Service**: Mock responses (ready for OpenAI integration)
- **Health Monitoring**: Health check endpoints for containerized deployments
- **CORS Support**: Cross-origin resource sharing for frontend access

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│            FastAPI App              │
├─────────────────────────────────────┤
│  Endpoints:                         │
│  • GET  /                (root)     │
│  • GET  /health          (health)   │
│  • GET  /toc             (contents) │
│  • POST /question        (Q&A)      │
├─────────────────────────────────────┤
│  Services:                          │
│  • EPUB processing (ebooklib)       │
│  • TOC extraction                   │
│  • Content selection                │
│  • Mock Q&A responses              │
└─────────────────────────────────────┘
```

## 📁 Files

- **`main.py`**: Main FastAPI application with all endpoints
- **`requirements.txt`**: Python dependencies
- **`Dockerfile`**: Multi-stage container build configuration
- **`README.md`**: This documentation

## 🚀 Running the Backend

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run development server
python main.py

# Access API at http://localhost:8000
# Access API docs at http://localhost:8000/docs
```

### Docker Container
```bash
# Build container
docker build -t exploras-backend .

# Run container
docker run -p 8000:8000 exploras-backend

# Or using docker-compose from project root
docker-compose up backend
```

### Kubernetes Deployment
```bash
# Build and push to MicroK8s registry
sudo docker build -t localhost:32000/exploras-backend:latest .
sudo docker push localhost:32000/exploras-backend:latest

# Deploy using k8s manifests
microk8s kubectl apply -f ../k8s/backend.yaml

# Check deployment
microk8s kubectl get pods -l app=exploras-backend
```

## 🔌 API Endpoints

### GET `/`
**Root endpoint**
```bash
curl http://localhost:8000/
```
Response: `{"message": "Exploras-Agent API is running", "epub_loaded": false}`

### GET `/health`
**Health check endpoint**
```bash
curl http://localhost:8000/health
```
Response: `{"status": "healthy", "epub_loaded": false, "toc_items_count": 0}`

### GET `/toc`
**Get Table of Contents**
```bash
curl http://localhost:8000/toc
```
Response: TOC structure with hierarchical chapters and sections

### POST `/question`
**Ask a question about selected content**
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"toc_id":"toc_0_0","question":"What is this chapter about?"}' \
  http://localhost:8000/question
```
Response: Mock answer with metadata (ready for OpenAI integration)

## 📦 Dependencies

### Core Dependencies
- **FastAPI**: Modern web framework for building APIs
- **uvicorn**: ASGI server for running FastAPI
- **ebooklib**: EPUB file processing and parsing
- **python-multipart**: File upload support

### Development Dependencies
- **pytest**: Testing framework (planned)
- **httpx**: HTTP client for testing (planned)

### Container Dependencies
- **Python 3.11**: Base runtime environment
- **Alpine Linux**: Lightweight container base image

## 🐳 Container Details

### Multi-stage Build
The Dockerfile uses a multi-stage build for optimization:

1. **Base Stage**: Python 3.11 slim with system dependencies
2. **Builder Stage**: Install Python dependencies
3. **Final Stage**: Copy dependencies and application code

### Container Features
- **Non-root user**: Runs as user 'app' for security
- **Health check**: Built-in health endpoint for orchestration
- **Port exposure**: Exposes port 8000 for HTTP traffic
- **Optimized size**: Multi-stage build reduces final image size

## 🔧 Configuration

### Environment Variables
- **HOST**: Binding host (default: 0.0.0.0)
- **PORT**: Binding port (default: 8000)
- **EPUB_PATH**: Path to EPUB files (default: ../ebook/)

### CORS Configuration
Configured to allow:
- All origins during development
- Specific origins in production
- All HTTP methods
- All headers

## 🧪 Testing

### Health Check
```bash
# Local testing
curl http://localhost:8000/health

# Container testing
docker run -p 8000:8000 exploras-backend
curl http://localhost:8000/health

# Kubernetes testing
microk8s kubectl exec -it <frontend-pod> -- wget -q -O - http://exploras-backend-service:8000/health
```

### API Testing
```bash
# Test all endpoints
curl http://localhost:8000/
curl http://localhost:8000/health
curl http://localhost:8000/toc
curl -X POST -H "Content-Type: application/json" -d '{"toc_id":"toc_0_0","question":"test"}' http://localhost:8000/question
```

## 🔄 Development Workflow

### Local Development
1. Edit `main.py`
2. Run `python main.py`
3. Test changes at http://localhost:8000
4. View API docs at http://localhost:8000/docs

### Container Development
1. Edit code
2. Run `docker build -t exploras-backend .`
3. Run `docker run -p 8000:8000 exploras-backend`
4. Test changes

### Kubernetes Development
1. Edit code
2. Build and push: `sudo docker build -t localhost:32000/exploras-backend:latest . && sudo docker push localhost:32000/exploras-backend:latest`
3. Restart deployment: `microk8s kubectl rollout restart deployment/exploras-backend`
4. Test in cluster

## 🚀 Future Enhancements

### Planned Features
- **OpenAI Integration**: Replace mock responses with real AI
- **Database Integration**: Persistent storage for processed EPUBs
- **Authentication**: API key or JWT-based authentication
- **Caching**: Redis cache for frequently accessed content
- **Logging**: Structured logging with correlation IDs
- **Metrics**: Prometheus metrics for monitoring
- **Rate Limiting**: API rate limiting and throttling

### OpenAI Integration Template
```python
import openai

async def ask_openai(context: str, question: str) -> str:
    response = await openai.ChatCompletion.acreate(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant for EPUB content analysis."},
            {"role": "user", "content": f"Context: {context}\n\nQuestion: {question}"}
        ]
    )
    return response.choices[0].message.content
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
   # Find process using port 8000
   lsof -i :8000
   # Kill process or use different port
   ```

2. **Module not found**:
   ```bash
   # Ensure dependencies are installed
   pip install -r requirements.txt
   ```

3. **EPUB not loading**:
   ```bash
   # Check EPUB file exists
   ls -la ../ebook/
   # Verify file permissions
   ```

4. **Container won't start**:
   ```bash
   # Check container logs
   docker logs <container-id>
   # Check if port is available
   netstat -tulpn | grep 8000
   ```

### Debug Commands
```bash
# Check container status
docker ps
docker logs <container-id>

# Check Kubernetes pod status
microk8s kubectl get pods -l app=exploras-backend
microk8s kubectl logs -l app=exploras-backend
microk8s kubectl describe pod <pod-name>

# Test connectivity
curl -v http://localhost:8000/health
```
