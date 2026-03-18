FROM python:3.13-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.10.10 /uv /uvx /bin/

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV UV_PROJECT_ENVIRONMENT=/django-devops-lab/.venv

WORKDIR /django-devops-lab

# Copy dependency files first
COPY pyproject.toml uv.lock ./

# Install dependencies (system-wide for speed)
RUN uv sync --locked --no-dev

# Copy the rest of the code
COPY . .

# Collect static files at build time (WhiteNoise)
# RUN uv run python manage.py collectstatic --noinput

# Copy start script and make executable
COPY start.sh .
RUN chmod +x start.sh

# Render expects the app to listen on $PORT (default 10000)
EXPOSE 10000

# Final command
CMD ["./start.sh"]


# FROM python:3.13-slim

# COPY --from=ghcr.io/astral-sh/uv:0.10.10 /uv /uvx /bin/

# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1

# WORKDIR /django-devops-lab

# COPY pyproject.toml /django-devops-lab/
# COPY uv.lock /django-devops-lab/

# RUN uv sync --locked

# COPY . /django-devops-lab/

