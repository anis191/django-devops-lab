FROM python:3.13-slim

COPY --from=ghcr.io/astral-sh/uv:0.10.10 /uv /uvx /bin/

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /django-devops-lab

COPY pyproject.toml /django-devops-lab/
COPY uv.lock /django-devops-lab/

RUN uv sync --locked

COPY . /django-devops-lab/

