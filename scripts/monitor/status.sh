#!/bin/bash
# Script kiểm tra trạng thái hệ thống

echo "📈 Client Status"
echo "================"
echo ""

# Kiểm tra containers
echo "🐳 Docker Containers:"
docker compose ps
echo ""

echo ""

# Kiểm tra services
echo "🔧 Service Status:"
if docker compose ps learning-platform | grep -q "Up"; then
    echo "✅ learning-platform: Running"
else
    echo "❌ learning-platform: Not running"
fi

echo ""
echo "💡 Tips:"
echo "  - View logs: ./scripts/monitor/logs.sh [learning-platform]"
echo "  - Restart service: docker compose restart learning-platform"
echo "  - View detailed logs: docker compose logs --tail=100 learning-platform"
