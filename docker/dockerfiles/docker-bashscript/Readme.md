# Usage
```bash
chmod +x build.sh

./build.sh             # just build
./build.sh --publish   # build + publish to PyPI

```

# Publish
```bash
export TWINE_USERNAME=__token__
export TWINE_PASSWORD=pypi-your-token-here
./build.sh --publish

```