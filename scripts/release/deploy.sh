#!/bin/bash
# Script deploy lên environment (staging/production)

set -e

ENVIRONMENT=${1:-""}
VERSION_FILE="../VERSION"
VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "latest")
REGISTRY=${DOCKER_REGISTRY:-""}
IMAGE_PREFIX=${IMAGE_PREFIX:-"big-problem-client"}

if [ -z "$ENVIRONMENT" ]; then
    echo "❌ Usage: ./scripts/release/deploy.sh <environment>"
    echo ""
    echo "Environments:"
    echo "  - staging"
    echo "  - production"
    exit 1
fi

if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ]; then
    echo "❌ Invalid environment. Use: staging or production"
    exit 1
fi

echo "🚀 Deploying to $ENVIRONMENT..."
echo "Version: $VERSION"
echo ""

# Confirm deployment
if [ "$ENVIRONMENT" = "production" ]; then
    echo "⚠️  WARNING: You are about to deploy to PRODUCTION!"
    read -p "Are you sure? Type 'yes' to confirm: " confirm
    if [ "$confirm" != "yes" ]; then
        echo "❌ Deployment cancelled"
        exit 0
    fi
fi

# Load environment-specific config
ENV_FILE=".env.${ENVIRONMENT}"
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️  Environment file not found: $ENV_FILE"
    echo "   Using default .env file"
    ENV_FILE=".env"
fi

# Create docker-compose override file
COMPOSE_FILE_ARGS="-f docker-compose.yml"
if [ -f "docker-compose.${ENVIRONMENT}.yml" ]; then
    COMPOSE_FILE_ARGS="-f docker-compose.yml -f docker-compose.${ENVIRONMENT}.yml"
fi

# Set image tags
export IMAGE_VERSION=$VERSION
if [ ! -z "$REGISTRY" ]; then
    export IMAGE_REGISTRY=$REGISTRY
    export IMAGE_PREFIX=$IMAGE_PREFIX
fi

if [ ! -z "$REGISTRY" ]; then
    echo "📥 Pulling client image from registry..."
    image_name="${IMAGE_PREFIX}-learning-platform"
    full_image="${REGISTRY}/${image_name}:${VERSION}"
    echo "📥 Pulling ${full_image}..."
    docker pull "${full_image}" || echo "⚠️  Failed to pull ${full_image}, using local image"
    echo ""
fi

# Deploy
echo "🚀 Deploying client..."
docker compose $COMPOSE_FILE_ARGS --env-file "$ENV_FILE" up -d --build

# Wait for services to be healthy
echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Health check
echo ""
echo "🏥 Running health check..."
./scripts/monitor/health.sh

# Show status
echo ""
echo "📊 Deployment status:"
docker compose $COMPOSE_FILE_ARGS ps

echo ""
echo "✅ Deployment to $ENVIRONMENT completed!"
echo ""
echo "📊 View logs: ./scripts/monitor/logs.sh"
echo "📈 Monitor: ./scripts/monitor/monitor.sh"
