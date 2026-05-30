# My Next.js App

A production-ready Next.js application containerized with Docker and deployed automatically via GitHub Actions.

## Prerequisites

- Node.js 20+
- Docker & Docker Compose
- A GitHub account with access to GitHub Container Registry (GHCR)

## Local Development

```bash
# Install dependencies
npm install

# Run development server
npm run dev

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Docker (Local)

bash
# Build the image
docker build -t my-nextjs-app .

# Run the container
docker run -p 3000:3000 my-nextjs-app

## Environment Variables

Create a `.env.production` file on your server (never commit this):

env
# Example
NEXT_PUBLIC_API_URL=https://api.example.com
DATABASE_URL=postgresql://...

## CI/CD Pipeline

Every push to the `main` branch automatically:

1. Builds a Docker image
2. Pushes it to GitHub Container Registry (`ghcr.io`)
3. SSHs into the production server
4. Pulls the new image and restarts the container

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `SERVER_HOST` | Production server IP or domain |
| `SERVER_USER` | SSH username |
| `SERVER_SSH_KEY` | Private SSH key for server access |

## Server Setup

Run these once on your production server:

bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Create app directory
mkdir -p /opt/my-nextjs-app
cd /opt/my-nextjs-app

# Login to GHCR
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Add your environment variables
touch .env.production

Then place the `docker-compose.yml` in `/opt/my-nextjs-app` and you're ready.

## Project Structure


my-nextjs-app/
├── .github/
│   └── workflows/
│       └── deploy.yml       # CI/CD pipeline
├── Dockerfile               # Multi-stage Docker build
├── .dockerignore
├── docker-compose.yml       # For production server
├── next.config.js           # output: standalone
└── src/
└── ...

## Deployment Architecture


GitHub (main branch)
↓
GitHub Actions
↓
ghcr.io (Docker image)
↓
Production Server (docker compose up -d)


```
