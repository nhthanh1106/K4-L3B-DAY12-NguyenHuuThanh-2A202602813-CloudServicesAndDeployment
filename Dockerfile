# Install dependencies in a separate stage so build tools and pip cache do not
# end up in the runtime image.
FROM python:3.11-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Keep the runtime image small and run the service as an unprivileged user.
FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

WORKDIR /app
COPY --from=builder /install /usr/local

RUN useradd --system --uid 10001 --create-home appuser
COPY --chown=appuser:appuser app ./app
COPY --chown=appuser:appuser utils ./utils

USER appuser
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.getenv('PORT', '8000') + '/health', timeout=3)"

CMD ["sh", "-c", "exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
