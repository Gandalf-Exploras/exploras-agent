# Exploras Frontend - Angular Application

Angular frontend application for the Exploras Agent EPUB Knowledge Explorer.

## 🎯 Purpose

The frontend provides:
- **Interactive UI**: Material Design interface for EPUB exploration
- **TOC Navigation**: Hierarchical table of contents with selection
- **Q&A Interface**: Real-time question answering with context
- **Responsive Design**: Mobile and desktop optimized layouts
- **API Integration**: RESTful communication with FastAPI backend

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│         Angular Application         │
├─────────────────────────────────────┤
│  Components:                        │
│  • AppComponent         (root)      │
│  • EpubExplorerComponent (main)     │
├─────────────────────────────────────┤
│  Services:                          │
│  • HTTP Client (API calls)          │
│  • Material Design (UI)             │
├─────────────────────────────────────┤
│  Build Output: /dist/               │
│  • Static files (HTML, CSS, JS)     │
│  • Served by Nginx in container     │
└─────────────────────────────────────┘
```

## 🎨 UI Framework

### Angular Material Design
- **Theme**: Custom Exploras theme (blue/orange palette)
- **Components**: Cards, buttons, trees, forms, snackbars
- **Typography**: Roboto font family
- **Icons**: Material Design icons
- **Layout**: Responsive flex layouts

### Component Structure
```
src/
├── app/
│   ├── app.component.ts           # Root application component
│   ├── app.module.ts              # Main application module
│   ├── epub-explorer.component.ts # Main EPUB interface component
│   └── README.md                  # Component documentation
├── environments/
│   ├── environment.ts             # Development configuration
│   └── environment.prod.ts        # Production configuration
├── index.html                     # Application entry point
├── main.ts                        # Angular bootstrap
└── styles.scss                    # Global styles and theming
```

## 📁 Files

- **`src/`**: Angular source code directory
- **`angular.json`**: Angular CLI configuration
- **`package.json`**: Node.js dependencies and scripts
- **`tsconfig.json`**: TypeScript configuration
- **`Dockerfile`**: Multi-stage container build
- **`nginx.conf`**: Nginx configuration for serving and API proxy
- **`setup-instructions.md`**: Development setup guide

## 🚀 Running the Frontend

### Local Development
```bash
# Install dependencies (requires Node.js 18+)
npm install

# Start development server
ng serve

# Access application at http://localhost:4200
```

### Production Build
```bash
# Build for production
ng build --configuration production

# Output in dist/ directory
ls dist/exploras-frontend/
```

### Docker Container
```bash
# Build container (includes Angular build + Nginx)
docker build -t exploras-frontend .

# Run container
docker run -p 80:80 exploras-frontend

# Or using docker-compose from project root
docker-compose up frontend
```

### Kubernetes Deployment
```bash
# Build and push to MicroK8s registry
sudo docker build -t localhost:32000/exploras-frontend:latest .
sudo docker push localhost:32000/exploras-frontend:latest

# Deploy using k8s manifests
microk8s kubectl apply -f ../k8s/frontend.yaml

# Check deployment
microk8s kubectl get pods -l app=exploras-frontend
```

## 🔌 API Integration

### Backend Communication
The frontend communicates with the backend via HTTP requests:

```typescript
// Service integration example
export class ApiService {
  private baseUrl = '/api'; // Proxied by Nginx to backend

  getToc(): Observable<any> {
    return this.http.get(`${this.baseUrl}/toc`);
  }

  askQuestion(tocId: string, question: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/question`, {
      toc_id: tocId,
      question: question
    });
  }
}
```

### Nginx Proxy Configuration
The `nginx.conf` handles:
- Static file serving for Angular application
- API proxying to backend service
- SPA routing support (fallback to index.html)

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;

    # Serve Angular static files
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API calls to backend
    location /api/ {
        proxy_pass http://exploras-backend-service:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 📦 Dependencies

### Core Dependencies
- **@angular/core**: Angular framework core
- **@angular/material**: Material Design components
- **@angular/common**: Common Angular utilities
- **@angular/forms**: Reactive forms support
- **rxjs**: Reactive programming library
- **typescript**: TypeScript language support

### Development Dependencies
- **@angular/cli**: Angular development tools
- **@angular-devkit/build-angular**: Build system
- **karma**: Testing framework
- **jasmine**: BDD testing framework
- **typescript**: TypeScript compiler

### Fixed Dependencies
Recent fixes for Angular 17 compatibility:
- **zone.js**: Updated import path from 'zone.js/dist/zone' to 'zone.js'
- **marked@9.0.0**: Specific version for ngx-markdown compatibility
- **@angular/material**: Updated to use mat-chip-set instead of deprecated mat-chip-list

## 🐳 Container Details

### Multi-stage Build
The Dockerfile uses a multi-stage build:

1. **Builder Stage** (node:18-alpine):
   - Install Node.js dependencies
   - Build Angular application for production
   - Generate optimized static files

2. **Runtime Stage** (nginx:alpine):
   - Copy built Angular files to Nginx
   - Copy custom Nginx configuration
   - Expose port 80 for HTTP traffic

### Container Features
- **Optimized Build**: Production Angular build with AOT compilation
- **Static Serving**: Nginx serves static files with gzip compression
- **API Proxy**: Nginx proxies `/api/*` requests to backend service
- **SPA Support**: Fallback routing for Angular single-page application
- **Security Headers**: Custom security headers in Nginx config

## 🎨 Theming and Styling

### Material Design Theme
Custom Exploras theme defined in `styles.scss`:
```scss
$exploras-primary: mat.define-palette(mat.$blue-palette);
$exploras-accent: mat.define-palette(mat.$orange-palette);
$exploras-warn: mat.define-palette(mat.$red-palette);

$exploras-theme: mat.define-light-theme((
  color: (
    primary: $exploras-primary,
    accent: $exploras-accent,
    warn: $exploras-warn,
  )
));
```

### Responsive Design
- **Mobile First**: Mobile-optimized layouts with responsive breakpoints
- **Flex Layout**: CSS flexbox for adaptive component positioning
- **Material Breakpoints**: Angular Material breakpoint system
- **Touch Support**: Touch-friendly interface elements

## 🧪 Testing

### Development Testing
```bash
# Run unit tests
ng test

# Run e2e tests
ng e2e

# Lint code
ng lint
```

### Container Testing
```bash
# Build and test container
docker build -t exploras-frontend .
docker run -p 8080:80 exploras-frontend

# Test frontend access
curl http://localhost:8080/

# Test API proxy (requires backend)
curl http://localhost:8080/api/health
```

### Kubernetes Testing
```bash
# Test pod status
microk8s kubectl get pods -l app=exploras-frontend

# Test service access
microk8s kubectl port-forward service/exploras-frontend-service 8080:80
curl http://localhost:8080/

# Test backend connectivity from frontend pod
microk8s kubectl exec -it <frontend-pod> -- wget -q -O - http://exploras-backend-service:8000/health
```

## 🔧 Development Workflow

### Local Development
1. Start backend: `cd ../backend && python main.py`
2. Start frontend: `ng serve`
3. Access application at http://localhost:4200
4. API calls proxied to http://localhost:8000

### Container Development
1. Edit source code
2. Build container: `docker build -t exploras-frontend .`
3. Run container: `docker run -p 8080:80 exploras-frontend`
4. Test at http://localhost:8080

### Kubernetes Development
1. Edit source code
2. Build and push: `sudo docker build -t localhost:32000/exploras-frontend:latest . && sudo docker push localhost:32000/exploras-frontend:latest`
3. Restart deployment: `microk8s kubectl rollout restart deployment/exploras-frontend`
4. Test via port-forward or ingress

## ⚙️ Configuration

### Environment Configuration
```typescript
// environment.ts (development)
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8000'
};

// environment.prod.ts (production)
export const environment = {
  production: true,
  apiUrl: '/api'  // Proxied by Nginx
};
```

### Angular CLI Configuration
Key settings in `angular.json`:
- Output path: `dist/exploras-frontend`
- Assets: Copy static files and favicon
- Styles: Global SCSS and Material theme
- Build optimization: AOT, tree-shaking, minification

## 🚀 Future Enhancements

### Planned Features
- **File Upload**: EPUB file upload functionality
- **TOC Tree**: Enhanced tree component with search and filtering
- **Chat Interface**: Real-time chat-style Q&A interface
- **History**: Question/answer history with bookmarking
- **Settings**: User preferences and configuration
- **PWA**: Progressive Web App capabilities
- **Dark Mode**: Dark theme support
- **Offline Mode**: Service worker for offline functionality

### Performance Optimizations
- **Lazy Loading**: Route-based code splitting
- **OnPush Strategy**: Change detection optimization
- **Virtual Scrolling**: For large TOC lists
- **Service Worker**: Caching and offline support
- **Bundle Analysis**: Webpack bundle analyzer integration

## 🐛 Troubleshooting

### Common Issues

1. **Build Failures**:
   ```bash
   # Clear node_modules and reinstall
   rm -rf node_modules package-lock.json
   npm install
   
   # Clear Angular cache
   ng cache clean
   ```

2. **Zone.js Import Error**:
   ```typescript
   // Use new import format for Angular 17
   import 'zone.js'; // Not 'zone.js/dist/zone'
   ```

3. **Material Design Issues**:
   ```bash
   # Ensure Material modules are imported
   ng add @angular/material
   
   # Check for deprecated components
   # Use mat-chip-set instead of mat-chip-list
   ```

4. **API Connection Issues**:
   ```bash
   # Check Nginx proxy configuration
   cat nginx.conf
   
   # Test backend connectivity
   curl http://exploras-backend-service:8000/health
   ```

5. **Container Build Issues**:
   ```bash
   # Check Node.js version (requires 18+)
   node --version
   
   # Check build logs
   docker build -t exploras-frontend . --no-cache
   ```

### Debug Commands
```bash
# Check Angular CLI version
ng version

# Analyze bundle size
ng build --source-map
npx webpack-bundle-analyzer dist/exploras-frontend/*.js

# Check container logs
docker logs <container-id>

# Check Kubernetes pod logs
microk8s kubectl logs -l app=exploras-frontend

# Test Nginx configuration
nginx -t -c /path/to/nginx.conf
```

## 📱 Mobile Support

### Responsive Breakpoints
- **xs**: 0-599px (mobile phones)
- **sm**: 600-959px (tablets portrait)
- **md**: 960-1279px (tablets landscape, small desktops)
- **lg**: 1280-1919px (desktops)
- **xl**: 1920px+ (large desktops)

### Touch Optimizations
- Touch-friendly button sizes (minimum 44px)
- Swipe gestures for navigation
- Virtual keyboard handling
- Viewport meta tag for proper scaling

## 🔒 Security

### Content Security Policy
Implemented security headers in Nginx:
- `X-Frame-Options: SAMEORIGIN`
- `X-XSS-Protection: 1; mode=block`
- `X-Content-Type-Options: nosniff`

### Input Sanitization
- Angular sanitizes HTML content by default
- Form validation for user inputs
- CSRF protection with Angular HTTP interceptors
