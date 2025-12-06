#!/bin/bash
# Script xem logs của hệ thống

SERVICE=${1:-""}

if [ -z "$SERVICE" ]; then
    echo "📊 Viewing logs for client"
    echo "Usage: ./scripts/monitor/logs.sh [learning-platform]"
    echo ""
    echo "Available services:"
    echo "  - learning-platform"
    echo ""
    docker compose logs -f learning-platform
else
    echo "📊 Viewing logs for $SERVICE..."
    docker compose logs -f "$SERVICE"
fi
