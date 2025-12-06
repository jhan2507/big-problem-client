#!/bin/bash
# Script xem metrics chi tiết của hệ thống

echo "📊 Client Metrics"
echo "=================="
echo ""

# Container metrics
echo "🐳 Container Metrics:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}" | grep -E "learning-platform|NAME"
echo ""

echo ""

# Service-specific metrics
echo "🔧 Service Metrics:"
CONTAINER_ID=$(docker compose ps -q learning-platform)
if [ ! -z "$CONTAINER_ID" ]; then
    STATS=$(docker stats --no-stream --format "{{.CPUPerc}}\t{{.MemUsage}}" "$CONTAINER_ID")
    echo "  learning-platform: $STATS"
fi

echo ""
echo "💡 For real-time metrics: docker stats"
