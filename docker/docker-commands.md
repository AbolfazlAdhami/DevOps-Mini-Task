# 🐳 Docker Commands Cheatsheet

Essential Docker commands for daily development and debugging.

---

## 🔧 Setup and Info

```bash
docker --version
docker info
docker system df       # Show disk usage
docker system prune    # Clean up unused data
```

---

## 📦 Images

```bash
docker pull ubuntu:latest           # Download image
docker images                       # List images
docker rmi <image-id>               # Remove image
docker build -t myapp:1.0 .         # Build image from Dockerfile
```

---

## 🚀 Containers

```bash
docker ps                           # List running containers
docker ps -a                        # List all containers
docker run -it ubuntu bash          # Run interactively
docker start <id>                   # Start container
docker stop <id>                    # Stop container
docker rm <id>                      # Remove container
```

---

## 🧭 Networking

```bash
docker network ls                   # List networks
docker network inspect bridge        # View default bridge network
docker network create mynet          # Create custom network
docker run -d --network=mynet nginx  # Run container on network
```

---

## 📂 Volumes

```bash
docker volume ls
docker volume create myvolume
docker run -v myvolume:/data ubuntu
```

---

## 🔍 Logs & Exec

```bash
docker logs <container-id>
docker exec -it <container-id> bash
```

---

## 🧱 Compose (docker-compose)

```bash
docker-compose up -d
docker-compose down
docker-compose logs
```

---

💡 **Tip:** Use `.dockerignore` to skip unnecessary files when building images.
