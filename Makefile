# React FastAPI Template Makefile

.PHONY: help setup dev build test clean docker-build docker-up docker-down docker-logs deploy-dev deploy-prod

# Default target
help: ## Show this help message
	@echo "React FastAPI Template - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Setup and Installation
setup: ## Install all dependencies
	@echo "Installing frontend dependencies..."
	cd frontend && npm install
	@echo "Installing backend dependencies..."
	cd backend && pip install -r requirements.txt
	@echo "Setup complete!"

setup-frontend: ## Install frontend dependencies only
	cd frontend && npm install

setup-backend: ## Install backend dependencies only
	cd backend && pip install -r requirements.txt

# Development
dev: ## Run both frontend and backend in development mode
	@echo "Starting development servers..."
	npx concurrently "make dev-backend" "make dev-frontend"

dev-frontend: ## Run frontend development server
	cd frontend && npm run dev

dev-backend: ## Run backend development server
	cd backend && python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Building
build: ## Build frontend for production
	cd frontend && npm run build

build-frontend: ## Build frontend for production
	cd frontend && npm run build

# Testing
test: ## Run tests
	cd frontend && npm run test

test-frontend: ## Run frontend tests
	cd frontend && npm run test

lint: ## Run linting on frontend
	cd frontend && npm run lint

# Docker Operations
docker-build: ## Build Docker containers
	docker-compose build

docker-up: ## Start all services with Docker
	docker-compose up -d

docker-down: ## Stop all Docker services
	docker-compose down

docker-logs: ## View Docker container logs
	docker-compose logs -f

docker-clean: ## Clean up Docker containers and images
	docker-compose down -v --rmi all
	docker system prune -f

# Container Registry Operations
REGISTRY ?= quay.io/your-org
TAG ?= latest

build-images: ## Build container images for registry
	@echo "Building images for $(REGISTRY) with tag $(TAG)..."
	./scripts/build-and-push.sh $(TAG) $(REGISTRY)

push-images: build-images ## Build and push images to registry

# OpenShift/Kubernetes Deployment
kustomize-dev: ## Preview development deployment manifests
	kustomize build k8s/overlays/dev

kustomize-prod: ## Preview production deployment manifests
	kustomize build k8s/overlays/prod

deploy-dev: ## Deploy to development environment
	@echo "Deploying to development..."
	./scripts/deploy.sh dev

deploy-prod: ## Deploy to production environment
	@echo "Deploying to production..."
	./scripts/deploy.sh prod

# Environment Setup
env-setup: ## Copy environment example files
	@echo "Setting up environment files..."
	@if [ ! -f backend/.env ]; then cp backend/.env.example backend/.env; echo "Created backend/.env"; fi
	@if [ ! -f frontend/.env ]; then cp frontend/.env.example frontend/.env; echo "Created frontend/.env"; fi

# Health Checks
health-backend: ## Check backend health
	@echo "Checking backend health..."
	@curl -f http://localhost:8000/api/health || echo "Backend not responding"

health-frontend: ## Check if frontend is running
	@echo "Checking frontend..."
	@curl -f http://localhost:3000 || echo "Frontend not responding"

# Cleanup
clean: ## Clean build artifacts and dependencies
	@echo "Cleaning build artifacts..."
	rm -rf frontend/dist
	rm -rf frontend/node_modules
	rm -rf backend/__pycache__
	rm -rf backend/.pytest_cache

clean-all: clean docker-clean ## Clean everything including Docker

# Development Workflow
fresh-start: clean setup env-setup ## Clean setup for new development
	@echo "Fresh development environment ready!"

quick-start: setup env-setup dev ## Quick start for development

# CI/CD Helpers
ci-test: setup test lint ## Run CI tests

ci-build: setup build ## Run CI build

ci-deploy-dev: build-images deploy-dev ## CI deployment to dev

ci-deploy-prod: build-images deploy-prod ## CI deployment to prod