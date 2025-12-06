#!/bin/bash
# Script build Docker images với version

set -e

VERSION_FILE="../VERSION"
VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "0.0.0")
REGISTRY=${DOCKER_REGISTRY:-""}
IMAGE_PREFIX=${IMAGE_PREFIX:-"big-problem-client"}

echo "🔨 Building Docker images..."
echo "Version: $VERSION"
echo ""

image_name="${IMAGE_PREFIX}-learning-platform"
if [ ! -z "$REGISTRY" ]; then
    full_image="${REGISTRY}/${image_name}"
else
    full_image="$image_name"
fi

echo "📦 Building learning-platform..."
echo "   Image: ${full_image}:${VERSION}"
echo "   Image: ${full_image}:latest"

docker build \
    -f "apps/learning-platform/Dockerfile" \
    -t "${full_image}:${VERSION}" \
    -t "${full_image}:latest" \
    .

echo "✅ learning-platform built successfully"
echo ""

echo "✅ All images built successfully!"
echo ""
echo "📋 Built images:"
echo "  - ${full_image}:${VERSION}"
echo "  - ${full_image}:latest"

echo ""
echo "💡 To push images: ./scripts/release/push.sh"
echo "💡 To deploy: ./scripts/release/deploy.sh <environment>"
