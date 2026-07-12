# Imagen con argumento de build y continuacion de linea
ARG PYTHON_VERSION=3.12
FROM python:3.12-slim

LABEL maintainer="Atomic Code" \
      version="1.0"

WORKDIR /srv/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER 1000
EXPOSE 8080/tcp

ENTRYPOINT ["python", "app.py"]
