# my-package

A Python package with a fully automated build, test, and publish pipeline using Bash, Docker, and GitHub Actions.

---

## Features

- Multi-version testing across Python 3.9, 3.10, 3.11, 3.12 via Docker
- Automated version bumping with bump2version
- Build distribution packages (wheel + sdist)
- Publish to PyPI, TestPyPI, or any private registry (Nexus, Artifactory, GitLab)
- GitHub Actions CI/CD integration

---

## Project Structure

```text
my-package/
├── build.sh                        # Main automation script
├── setup.cfg                       # Package metadata and config
├── setup.py                        # Minimal setuptools entry
├── .bumpversion.cfg                # Version bump configuration
├── Dockerfile                      # Optional custom builder image
├── .github/
│   └── workflows/
│       └── publish.yml             # GitHub Actions workflow
├── src/
│   └── my_package/
│       └── __init__.py             # Package source
└── tests/
└── test_basic.py               # pytest tests
```

---

## Requirements

### Local

- Docker (required for multi-version testing)
- Python 3.9+ (for running tests locally without Docker)

### CI/CD

- GitHub repository
- GitHub Actions secrets (see [Deployment](#deployment))

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-username/my-package.git
cd my-package

### 2. Make the build script executable

```bash
chmod +x build.sh

### 3. Set environment variables

```bash
export TWINE_USERNAME=**token**
export TWINE_PASSWORD=pypi-your-token-here
export REGISTRY_URL=https://upload.pypi.org/legacy/ # or your private registry

---

## Local Testing

### Run tests only (no Docker)

```bash
pip install -e ".[dev]"
pytest tests/ -v

### Run tests with Docker (single version)

```bash
docker run --rm \
 -v "$(pwd)":/app \
 -w /app \
 python:3.11-slim \
 ```bash -c "pip install -e '.[dev]' -q && pytest tests/ -v"

### Run full pipeline (test + build + upload)

``````bash
./build.sh
```
 
### Upload to TestPyPI (recommended before production)

``````bash
REGISTRY_URL=https://test.pypi.org/legacy/ \
TWINE_USERNAME=**token** \
TWINE_PASSWORD=pypi-your-test-token \
./build.sh
```
---

## Docker Builder Image (Optional)

If you prefer a cached, single-version build environment:

### Build the image

```bash
docker build -t my-package-builder .
```
### Run tests

```bash
docker run --rm my-package-builder pytest tests/ -q
```
### Build distribution

```bash
docker run --rm \
 -v "$(pwd)/dist":/app/dist \
 my-package-builder \
 python -m build
```
---

## Deployment

### A. Manual deploy to PyPI

```bash
TWINE_USERNAME=**token** \
TWINE_PASSWORD=pypi-your-real-token \
REGISTRY_URL=https://upload.pypi.org/legacy/ \
./build.sh
```
### B. Deploy via GitHub Actions

Add these secrets to your GitHub repository:
(**Settings → Secrets and variables → Actions**)

| Secret           | Description                                             |
| ---------------- | ------------------------------------------------------- |
| `GH_PAT`         | GitHub Personal Access Token (for version bump commits) |
| `TWINE_USERNAME` | PyPI username or `__token__`                            |
| `TWINE_PASSWORD` | PyPI token or password                                  |
| `REGISTRY_URL`   | Upload URL (optional, defaults to PyPI)                 |

Then either:

- Push to `main` → pipeline runs automatically
- Go to **Actions → Build & Publish → Run workflow** → choose bump type

### C. Deploy to a private registry

```bash
REGISTRY_URL=https://nexus.company.com/repository/pypi/ \
TWINE_USERNAME=your-nexus-user \
TWINE_PASSWORD=your-nexus-password \
./build.sh
```
Supported registries:

- [Nexus Repository Manager](https://www.sonatype.com/products/nexus-repository)
- [JFrog Artifactory](https://jfrog.com/artifactory/)
- [GitLab Package Registry](https://docs.gitlab.com/ee/user/packages/pypi_repository/)
- Any registry compatible with the PyPI upload API

---

## Version Bumping

This project uses [bump2version](https://github.com/c4urself/bump2version).

Version format: `MAJOR.MINOR.PATCH`

| Command      | Before  | After   |
| ------------ | ------- | ------- |
| `BUMP=patch` | `0.1.0` | `0.1.1` |
| `BUMP=minor` | `0.1.0` | `0.2.0` |
| `BUMP=major` | `0.1.0` | `1.0.0` |

Version is updated automatically in:

- `setup.cfg`
- `src/my_package/__init__.py`

A git commit and tag are created automatically when bumping.

---

## Environment Variables

| Variable         | Default                           | Description                                     |
| ---------------- | --------------------------------- | ----------------------------------------------- |
| `BUMP`           | _(none)_                          | Version bump type: `patch`, `minor`, or `major` |
| `REGISTRY_URL`   | `https://upload.pypi.org/legacy/` | Package registry upload URL                     |
| `TWINE_USERNAME` | _(required)_                      | Registry username or `__token__`                |
| `TWINE_PASSWORD` | _(required)_                      | Registry password or API token                  |

---

## Tested Python Versions

| Version     | Status |
| ----------- | ------ |
| Python 3.9  | ✅     |
| Python 3.10 | ✅     |
| Python 3.11 | ✅     |
| Python 3.12 | ✅     |

---

## Sanity Check

After building, verify the package works:

```bash
pip install dist/my_package-0.1.0-py3-none-any.whl
python -c "from my_package import hello; print(hello('world'))"
```
# Output: Hello, world!

---
