#!/usr/bin/env bash
set -e

# apply database migrations
uv run manage.py migrate --noinput

# collect static files
uv run manage.py collectstatic --noinput

# Start Gunicorn
exec gunicorn config.wsgi:application \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 3 \
    --log-file -