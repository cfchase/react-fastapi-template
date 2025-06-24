# React FastAPI Template

A full-stack application template with React frontend (Vite) and FastAPI backend, ready for deployment to OpenShift.

## Architecture

- **Frontend**: React with TypeScript and Vite - simple UI with health check button
- **Backend**: FastAPI with Python - minimal API with health check endpoint
- **Containerization**: Docker and Docker Compose
- **Deployment**: OpenShift with Kustomize
- **Container Registry**: Quay.io
- **API Routing**: Vite proxy for local development, Nginx proxy for production

## Quick Start

### Prerequisites

- Node.js 22+
- Python 3.11+
- Docker
- OpenShift CLI (`oc`)
- Kustomize

### Local Development

1. **Clone and setup**:
   ```bash
   git clone <this-repo>
   cd react-fastapi-template
   make setup
   # or alternatively: npm run setup
   ```

2. **Run locally**:
   ```bash
   # Run both frontend and backend
   make dev
   
   # Or run separately
   make dev-backend   # Backend on http://localhost:8000
   make dev-frontend  # Frontend on http://localhost:3000
   
   # Alternative npm commands
   npm run dev        # Run both
   npm run dev:backend npm run dev:frontend
   ```

### Building

```bash
# Build frontend and container images
make build
```

## Project Structure

```
├── backend/              # FastAPI backend
│   ├── main.py          # FastAPI application
│   ├── requirements.txt # Python dependencies
│   ├── Dockerfile       # Backend container
│   └── .env.example     # Environment variables
├── frontend/            # React frontend
│   ├── src/             # Source code
│   ├── package.json     # Node dependencies
│   ├── Dockerfile       # Frontend container
│   ├── nginx.conf       # Nginx configuration
│   └── .env.example     # Environment variables
├── k8s/                 # Kubernetes/OpenShift manifests
│   ├── base/           # Base kustomize resources
│   └── overlays/       # Environment-specific configs
│       ├── dev/        # Development environment
│       └── prod/       # Production environment
├── scripts/            # Deployment scripts
│   ├── build-and-push.sh
│   └── deploy.sh
└── docker-compose.yml  # Local development with Docker
```

## Deployment

### Container Images

Build and push to quay.io:

```bash
# Build frontend and container images
make build

# Build with specific tag and registry
make build TAG=v1.0.0 REGISTRY=quay.io/cfchase

# Push images (must build first)
make push TAG=v1.0.0

# Build and push (two steps)
make build TAG=v1.0.0
make push TAG=v1.0.0

# Alternative script usage
./scripts/build-images.sh v1.0.0 quay.io/cfchase
./scripts/push-images.sh v1.0.0 quay.io/cfchase
```

### OpenShift Deployment

1. **Login to OpenShift**:
   ```bash
   oc login --server=https://your-openshift-cluster
   ```

2. **Deploy to development**:
   ```bash
   make deploy-dev
   # or: ./scripts/deploy.sh dev
   ```

3. **Deploy to production**:
   ```bash
   make deploy-prod
   # or: ./scripts/deploy.sh prod
   ```

4. **Preview deployments**:
   ```bash
   make kustomize-dev   # Preview dev manifests
   make kustomize-prod  # Preview prod manifests
   ```

5. **Remove deployments**:
   ```bash
   make undeploy-dev    # Remove development deployment
   make undeploy-prod   # Remove production deployment
   ```

## Configuration

### Backend Configuration

Copy `backend/.env.example` to `backend/.env` and configure:

```env
PORT=8000
ENVIRONMENT=development
```

### Frontend Configuration

Copy `frontend/.env.example` to `frontend/.env` and configure:

```env
VITE_API_URL=http://localhost:8000
```

## API Endpoints

The backend provides the following endpoints:

- `GET /` - Root endpoint
- `GET /api/health` - Health check endpoint

## Customization

### Update Container Registry

1. Update image references in `k8s/base/kustomization.yaml`
2. Update registry in `scripts/build-and-push.sh`
3. Update image references in overlay files

### Add Environment Variables

1. Add to `.env.example` files
2. Update deployment manifests in `k8s/base/`
3. Update Docker configurations

## License

Apache License 2.0