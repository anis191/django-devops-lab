FROM python:3.13-slim

# copy uv runtime (as you had)
COPY --from=ghcr.io/astral-sh/uv:0.10.10 /uv /uvx /bin/

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /django-devops-lab

# copy lockfiles first for cached installs
COPY pyproject.toml uv.lock /django-devops-lab/

# install dependencies (uv sync)
RUN uv sync --locked

# copy project files
COPY . /django-devops-lab/

# create non-root user for running app
RUN useradd --create-home appuser && chown -R appuser:appuser /django-devops-lab

USER appuser

# expose port (Render injects $PORT at runtime)
EXPOSE 8000

# make sure entrypoint is executable
ENTRYPOINT ["/django-devops-lab/entrypoint.sh"]


# FROM python:3.13-slim

# COPY --from=ghcr.io/astral-sh/uv:0.10.10 /uv /uvx /bin/

# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1

# WORKDIR /django-devops-lab

# COPY pyproject.toml /django-devops-lab/
# COPY uv.lock /django-devops-lab/

# RUN uv sync --locked

# COPY . /django-devops-lab/

