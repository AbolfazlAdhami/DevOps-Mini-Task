#!/usr/bin/env bash
set -euo pipefail

REGISTRY_URL="${REGISTRY_URL:-https://upload.pypi.org/legacy/}"
PYTHON_VERSIONS=("3.9" "3.10" "3.11" "3.12")
BUMP="${BUMP:-}"

# 1. Optional version bump
if [[ -n "$BUMP" ]]; then
  echo ">>> Bumping: $BUMP"
  docker run --rm -v "$(pwd)":/app -w /app python:3.11-slim \
    bash -c "pip install -q bump2version && bump2version $BUMP"
fi

# 2. Multi-version tests
for PY in "${PYTHON_VERSIONS[@]}"; do
  echo ">>> Testing python:${PY}"
  docker run --rm -v "$(pwd)":/app -w /app "python:${PY}-slim" \
    bash -c "pip install -q pytest && pip install -q -e . && pytest tests/ -q"
done

# 3. Build
echo ">>> Building"
docker run --rm -v "$(pwd)":/app -w /app python:3.11-slim \
  bash -c "pip install -q build && python -m build"

# 4. Upload
echo ">>> Uploading to $REGISTRY_URL"
docker run --rm -v "$(pwd)":/app -w /app \
  -e TWINE_USERNAME \
  -e TWINE_PASSWORD \
  python:3.11-slim \
  bash -c "pip install -q twine && twine upload --repository-url '$REGISTRY_URL' dist/*"

echo ">>> Done!"
