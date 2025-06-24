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

- Node.js 18+
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

### Docker Development

```bash
# Build and run with Docker Compose
make docker-build
make docker-up

# View logs
make docker-logs

# Stop services
make docker-down

# Alternative npm commands
npm run docker:build npm run docker:up npm run docker:logs npm run docker:down
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
# Build and push with default tag
make build-images

# Build and push with specific tag  
make build-images TAG=v1.0.0

# Use different registry
make build-images TAG=v1.0.0 REGISTRY=quay.io/myorg

# Alternative script usage
./scripts/build-and-push.sh v1.0.0 quay.io/myorg
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