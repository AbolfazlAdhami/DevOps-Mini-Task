FROM python:3.11-slim

WORKDIR /app

COPY setup.cfg setup.py ./
COPY src/ src/

RUN pip install --no-cache-dir -e ".[dev]" build twine bump2version pytest

COPY . .
