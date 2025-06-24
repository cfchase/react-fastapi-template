#!/bin/bash

# Build and push container images to Quay.io
# Usage: ./scripts/build-and-push.sh [tag] [registry]

set -e

# Default values
TAG=${1:-latest}
REGISTRY=${2:-quay.io/your-org}
PROJECT_NAME="react-fastapi-template"

echo "Building and pushing images with tag: $TAG"
echo "Registry: $REGISTRY"

# Build backend image
echo "Building backend image..."
docker build -t "${REGISTRY}/${PROJECT_NAME}-backend:${TAG}" ./backend

# Build frontend image
echo "Building frontend image..."
docker build -t "${REGISTRY}/${PROJECT_NAME}-frontend:${TAG}" ./frontend

# Push images
echo "Pushing backend image..."
docker push "${REGISTRY}/${PROJECT_NAME}-backend:${TAG}"

echo "Pushing frontend image..."
docker push "${REGISTRY}/${PROJECT_NAME}-frontend:${TAG}"

echo "Images built and pushed successfully!"
echo "Backend: ${REGISTRY}/${PROJECT_NAME}-backend:${TAG}"
echo "Frontend: ${REGISTRY}/${PROJECT_NAME}-frontend:${TAG}"