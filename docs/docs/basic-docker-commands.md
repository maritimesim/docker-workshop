# Basic Docker Commands

This guide covers essential Docker commands that you'll use throughout the course. These commands will help you work with Docker images, containers, and basic Docker operations.

## Getting Started

### Check Docker Installation

```bash
# Check Docker version
docker --version

# Check Docker system information
docker info

# Get help for Docker commands
docker --help
docker run --help    # Help for specific command
```

## Working with Docker Images

### Listing Images

```bash
# List all images on your system
docker images

# List images with more details
docker images --all

# List only image IDs
docker images -q

# List images with specific filters
docker images --filter "dangling=true"    # Show untagged images
docker images nginx                       # Show only nginx images
```

### Pulling Images

```bash
# Pull an image from Docker Hub
docker pull hello-world
docker pull nginx
docker pull ubuntu:22.04

# Pull specific version/tag
docker pull nginx:1.25
docker pull node:18-alpine

# Pull from different registry
docker pull mcr.microsoft.com/dotnet/core/runtime:3.1
```

### Searching Images

```bash
# Search for images on Docker Hub
docker search nginx
docker search --limit 5 python    # Limit results
docker search --filter stars=3 mysql    # Filter by stars
```

### Managing Images

```bash
# Remove an image
docker rmi hello-world
docker rmi nginx:latest

# Remove multiple images
docker rmi nginx ubuntu node

# Remove image by ID
docker rmi 1a2b3c4d5e6f

# Remove all unused images
docker image prune

# Remove all images (be careful!)
docker rmi $(docker images -q)

# Force remove image
docker rmi -f nginx
```

### Building Images

```bash
# Build image from Dockerfile
docker build -t my-app .
docker build -t my-app:v1.0 .

# Build with specific Dockerfile
docker build -f Dockerfile.dev -t my-app:dev .

# Build without cache
docker build --no-cache -t my-app .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t my-app .
```

## Working with Docker Containers

### Running Containers

```bash
# Run a simple container
docker run hello-world

# Run container in background (detached mode)
docker run -d nginx

# Run container with custom name
docker run --name my-nginx nginx

# Run container with port mapping
docker run -p 8080:80 nginx          # Map host port 8080 to container port 80
docker run -p 80:80 -d nginx         # Run in background with port mapping

# Run container interactively
docker run -it ubuntu bash           # Interactive terminal
docker run -it --rm ubuntu bash      # Remove container when it exits

# Run container with environment variables
docker run -e ENV_VAR=value nginx
docker run -e MYSQL_ROOT_PASSWORD=secret mysql

# Run container with volume mounting
docker run -v /host/path:/container/path nginx
docker run -v $(pwd):/app node        # Mount current directory
```

### Listing Containers

```bash
# List running containers
docker ps

# List all containers (running and stopped)
docker ps -a

# List only container IDs
docker ps -q

# List with specific format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# List last N containers
docker ps -n 5
```

### Managing Running Containers

```bash
# Stop a container
docker stop container-name
docker stop 1a2b3c4d5e6f    # Using container ID

# Start a stopped container
docker start container-name

# Restart a container
docker restart container-name

# Pause/unpause a container
docker pause container-name
docker unpause container-name

# Kill a container (force stop)
docker kill container-name
```

### Interacting with Containers

```bash
# Execute commands in running container
docker exec -it container-name bash
docker exec -it container-name sh
docker exec container-name ls /app

# Copy files to/from container
docker cp file.txt container-name:/app/
docker cp container-name:/app/logs.txt ./

# View container logs
docker logs container-name
docker logs -f container-name        # Follow logs
docker logs --tail 50 container-name # Show last 50 lines
docker logs --since "2023-01-01" container-name
```

### Container Information

```bash
# Inspect container details
docker inspect container-name

# View container processes
docker top container-name

# View container resource usage
docker stats container-name
docker stats --no-stream    # One-time stats for all containers

# View container changes
docker diff container-name
```

### Removing Containers

```bash
# Remove a stopped container
docker rm container-name

# Remove multiple containers
docker rm container1 container2 container3

# Remove running container (force)
docker rm -f container-name

# Remove all stopped containers
docker container prune

# Remove container automatically when it exits
docker run --rm hello-world
```

## Docker System Management

### System Information

```bash
# Show Docker system information
docker system info

# Show disk usage
docker system df

# Show detailed disk usage
docker system df -v
```

### Cleaning Up

```bash
# Remove unused containers, networks, images
docker system prune

# Remove everything (including volumes)
docker system prune -a

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune
```

## Working with Docker Volumes

### Basic Volume Operations

```bash
# Create a volume
docker volume create my-volume

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-volume

# Remove volume
docker volume rm my-volume

# Remove all unused volumes
docker volume prune
```

### Using Volumes with Containers

```bash
# Run container with named volume
docker run -v my-volume:/data nginx

# Run container with bind mount
docker run -v /host/path:/container/path nginx
docker run -v $(pwd):/app node:18

# Run with read-only mount
docker run -v $(pwd):/app:ro nginx
```

## Working with Docker Networks

### Basic Network Operations

```bash
# List networks
docker network ls

# Create network
docker network create my-network

# Inspect network
docker network inspect my-network

# Remove network
docker network rm my-network

# Connect container to network
docker network connect my-network container-name

# Disconnect container from network
docker network disconnect my-network container-name
```

### Running Containers with Custom Networks

```bash
# Run container on specific network
docker run --network my-network nginx

# Run container with custom hostname
docker run --network my-network --hostname web-server nginx
```

## Docker Compose Basics

### Basic Compose Commands

```bash
# Start services defined in docker-compose.yml
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs
docker-compose logs service-name

# Build services
docker-compose build

# Pull images for services
docker-compose pull

# List running services
docker-compose ps
```

## Common Patterns and Examples

### Web Server Example

```bash
# Run nginx web server
docker run -d --name web-server -p 8080:80 nginx

# View the website
# Open browser to http://localhost:8080

# Check logs
docker logs web-server

# Stop and remove
docker stop web-server
docker rm web-server
```

### Database Example

```bash
# Run MySQL database
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=myapp \
  -p 3306:3306 \
  mysql:8.0

# Connect to database
docker exec -it mysql-db mysql -u root -p
```

### Development Environment Example

```bash
# Run Node.js development environment
docker run -it \
  --name node-dev \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:18 \
  bash

# Inside the container, you can run:
# npm init -y
# npm install express
# node app.js
```

## Dockerfile Basics

### Common Dockerfile Commands

```dockerfile
# Example Dockerfile
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Define startup command
CMD ["npm", "start"]
```

### Building and Running Custom Images

```bash
# Build image from Dockerfile
docker build -t my-node-app .

# Run your custom image
docker run -p 3000:3000 my-node-app

# Tag image for different versions
docker tag my-node-app my-node-app:v1.0
docker tag my-node-app my-node-app:latest
```

## Useful Tips and Tricks

### Aliases for Common Commands

```bash
# You can create aliases in your shell profile
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
```

### One-liner Commands

```bash
# Stop all running containers
docker stop $(docker ps -q)

# Remove all stopped containers
docker rm $(docker ps -a -q)

# Remove all images
docker rmi $(docker images -q)

# Remove all unused resources
docker system prune -a
```

### Container Debugging

```bash
# Run container with debugging capabilities
docker run --rm -it --name debug ubuntu bash

# Attach to running container
docker attach container-name

# Create a debugging sidecar container
docker run --rm -it --pid container:target-container --net container:target-container --cap-add SYS_PTRACE alpine sh
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `docker pull image` | Download image |
| `docker images` | List images |
| `docker run image` | Run container |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop container` | Stop container |
| `docker rm container` | Remove container |
| `docker rmi image` | Remove image |
| `docker logs container` | View container logs |
| `docker exec -it container bash` | Access container shell |
| `docker build -t name .` | Build image |
| `docker-compose up` | Start compose services |
| `docker system prune` | Clean up unused resources |

## Security Considerations

```bash
# Run container as non-root user
docker run --user 1000:1000 nginx

# Run container with limited capabilities
docker run --cap-drop ALL nginx

# Run container with read-only filesystem
docker run --read-only nginx

# Scan images for vulnerabilities (if Docker Scout is available)
docker scout cves nginx
```

## Next Steps

Once you're comfortable with these basic commands, you can explore:

- **Docker Compose** for multi-container applications
- **Docker Swarm** for container orchestration
- **Kubernetes** for advanced container orchestration
- **Docker Security** best practices
- **Multi-stage builds** for optimized images
- **Container registries** for sharing images

Remember: Practice these commands hands-on to become comfortable with Docker operations!