# ---------- Builder ----------
FROM python:3.12-slim AS builder

WORKDIR /app

# Copy uv binary
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Copy dependency files first
COPY pyproject.toml uv.lock ./

# Install only production dependencies
RUN uv sync --no-dev --frozen

# Copy application
COPY app ./app

# ---------- Runtime ----------
FROM python:3.12-slim

WORKDIR /app

# Copy virtual environment
COPY --from=builder /app/.venv /app/.venv

# Copy application
COPY --from=builder /app/app ./app

# Use the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]