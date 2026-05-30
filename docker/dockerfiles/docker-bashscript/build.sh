#!/bin/bash
set -e

IMAGE="pip-builder"
DIST_DIR="./dist"

# Build Docker image
docker build -t $IMAGE .

# Run build inside container, copy output to host
docker run --rm -v "$PWD/$DIST_DIR:/app/dist" $IMAGE \
    python -m build

echo "✅ Build complete. Packages in $DIST_DIR"

# Optional: publish to PyPI
if [[ "$1" == "--publish" ]]; then
    docker run --rm \
        -e TWINE_USERNAME="$TWINE_USERNAME" \
        -e TWINE_PASSWORD="$TWINE_PASSWORD" \
        -v "$PWD/$DIST_DIR:/app/dist" \
        $IMAGE twine upload dist/*
    echo "🚀 Published to PyPI"
fi
