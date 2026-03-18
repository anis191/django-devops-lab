#!/usr/bin/env bash
set -e

echo "Waiting for Redis if needed (optional)..."
# sleep 5   # ← optional, usually not needed on Render internal network

echo "Running migrations..."
uv run python manage.py migrate --noinput

echo "Collecting static files..."
uv run python manage.py collectstatic --noinput --clear   # --clear is nice on redeploys

echo "Starting Gunicorn..."
exec uv run gunicorn config.wsgi:application \
    --bind 0.0.0.0:${PORT:-10000} \
    --workers 3 \
    --threads 2 \
    --timeout 120 \
    --log-level info