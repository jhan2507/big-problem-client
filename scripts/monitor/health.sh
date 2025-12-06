#!/bin/bash
# Script kiểm tra health của từng service

echo "🏥 Client Health Check"
echo "======================"
echo ""

check_service() {
    SERVICE=$1
    if docker compose ps "$SERVICE" | grep -q "Up"; then
        ERROR_COUNT=$(docker compose logs --tail=50 "$SERVICE" 2>&1 | grep -i "error\|exception\|failed" | wc -l)
        if [ "$ERROR_COUNT" -gt 0 ]; then
            echo "⚠️  $SERVICE: Running but has $ERROR_COUNT recent errors"
        else
            echo "✅ $SERVICE: Healthy"
        fi
    else
        echo "❌ $SERVICE: Not running"
    fi
}

check_service "learning-platform"

echo ""

echo ""
echo "🔍 HTTP Check:"
curl -fsS http://localhost:4001/ > /dev/null 2>&1 && echo "✅ learning-platform HTTP: OK" || echo "❌ learning-platform HTTP: FAILED"

echo ""
echo "📊 Recent Errors (last 50 lines):"
echo "---------------------------------"
docker compose logs --tail=50 learning-platform 2>&1 | grep -i "error\|exception\|failed" | head -10 || true
