# Docker Compose Reference

This document provides a comprehensive overview of the most commonly used Docker Compose configuration options. Each line includes a comment explaining its purpose.

## Complete Example Docker Compose File

```yaml
# Docker Compose file format version
version: '3.8'

# Define services (containers) that make up your application
services:
  
  # Service name - can be any descriptive name
  web-app:
    # Docker image to use for this service
    image: nginx:latest
    
    # Alternative: build from Dockerfile in current directory
    # build: .
    
    # Alternative: build from Dockerfile in specific directory with context
    # build:
    #   context: ./web
    #   dockerfile: Dockerfile.prod
    
    # Name for the container (optional, Docker will generate one if not specified)
    container_name: my-web-container
    
    # Restart policy for the container
    restart: unless-stopped
    
    # Port mapping: host_port:container_port
    ports:
      - "8080:80"        # Map host port 8080 to container port 80
      - "8443:443"       # Map host port 8443 to container port 443
    
    # Environment variables
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
      - API_KEY=your-api-key
    
    # Alternative environment file
    # env_file:
    #   - .env
    #   - .env.local
    
    # Volume mounts: host_path:container_path
    volumes:
      - ./html:/usr/share/nginx/html:ro    # Mount local html folder as read-only
      - ./config:/etc/nginx/conf.d         # Mount configuration directory
      - web-data:/var/www/data              # Named volume
    
    # Networks this service should connect to
    networks:
      - frontend
      - backend
    
    # Services this container depends on (will start them first)
    depends_on:
      - database
      - redis
    
    # Resource limits
    deploy:
      resources:
        limits:
          cpus: '0.5'      # Limit to 0.5 CPU cores
          memory: 512M     # Limit to 512MB RAM
        reservations:
          cpus: '0.25'     # Reserve 0.25 CPU cores
          memory: 256M     # Reserve 256MB RAM
    
    # Health check configuration
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80"]  # Command to test health
      interval: 30s      # How often to run the health check
      timeout: 10s       # How long to wait for health check to complete
      retries: 3         # How many times to retry before marking unhealthy
      start_period: 40s  # How long to wait before first health check
    
    # Command to override the default container command
    # command: ["nginx", "-g", "daemon off;"]
    
    # Working directory inside the container
    # working_dir: /app
    
    # User to run the container as
    # user: "1000:1000"

  # Database service example
  database:
    image: postgres:13
    container_name: my-database
    restart: always
    
    # Environment variables for database configuration
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: dbuser
      POSTGRES_PASSWORD: dbpass
    
    # Expose port (only accessible to other containers, not host)
    expose:
      - "5432"
    
    # Persistent volume for database data
    volumes:
      - db-data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d:ro
    
    networks:
      - backend
    
    # Security options
    security_opt:
      - no-new-privileges:true
    
    # Logging configuration
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  # Cache service example
  redis:
    image: redis:6-alpine
    container_name: my-cache
    restart: unless-stopped
    
    # Custom command with arguments
    command: redis-server --appendonly yes --requirepass mypassword
    
    volumes:
      - redis-data:/data
    
    networks:
      - backend
    
    # System limits
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    
    # Memory limits (alternative syntax)
    mem_limit: 256m
    memswap_limit: 512m

  # Worker/background service example
  worker:
    build:
      context: .
      dockerfile: Dockerfile.worker
      # Build arguments
      args:
        - BUILD_VERSION=1.0.0
        - ENVIRONMENT=production
    
    container_name: my-worker
    restart: on-failure:3    # Restart on failure, max 3 attempts
    
    # Scale this service to multiple instances
    deploy:
      replicas: 2
    
    environment:
      - WORKER_THREADS=4
      - QUEUE_NAME=background-jobs
    
    depends_on:
      - database
      - redis
    
    networks:
      - backend
    
    # Mount host directory as bind mount
    volumes:
      - type: bind
        source: ./uploads
        target: /app/uploads
      - type: volume
        source: worker-logs
        target: /app/logs

# Define networks
networks:
  # Frontend network for web-facing services
  frontend:
    driver: bridge
    # Custom network configuration
    ipam:
      config:
        - subnet: 172.20.0.0/16
  
  # Backend network for internal services
  backend:
    driver: bridge
    internal: true    # No external connectivity
  
  # External network (already exists)
  # external-network:
  #   external: true
  #   name: existing-network

# Define named volumes
volumes:
  # Database data volume
  db-data:
    driver: local
    # Custom driver options
    driver_opts:
      type: none
      o: bind
      device: /opt/docker/db-data
  
  # Web application data
  web-data:
    driver: local
  
  # Redis data volume
  redis-data:
    driver: local
  
  # Worker logs volume
  worker-logs:
    driver: local
  
  # External volume (already exists)
  # existing-volume:
  #   external: true
  #   name: my-existing-volume

# Define secrets (Docker Swarm mode)
# secrets:
#   db-password:
#     file: ./secrets/db_password.txt
#   api-key:
#     external: true
#     name: production-api-key

# Define configs (Docker Swarm mode)
# configs:
#   nginx-config:
#     file: ./config/nginx.conf
#   app-config:
#     external: true
#     name: app-production-config
```

## Common Docker Compose Commands

```bash
# Start services in detached mode
docker-compose up -d

# Start specific services
docker-compose up -d web-app database

# View logs
docker-compose logs -f web-app

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Build images before starting
docker-compose up --build

# Scale a service
docker-compose up -d --scale worker=3

# View running services
docker-compose ps

# Execute command in running container
docker-compose exec web-app bash
```

## Key Concepts Explained

### Service Dependencies
- `depends_on` ensures services start in order
- Does not wait for service to be "ready", only started
- Use health checks for readiness verification

### Volume Types
- **Named volumes**: Managed by Docker, persistent across container recreation
- **Bind mounts**: Direct mount of host directory/file
- **Anonymous volumes**: Temporary, removed when container is removed

### Network Types
- **Bridge**: Default network type, allows container-to-container communication
- **Host**: Use host's network directly
- **None**: Disable networking
- **Overlay**: For Docker Swarm multi-host networking

### Restart Policies
- `no`: Never restart (default)
- `always`: Always restart
- `on-failure`: Restart on non-zero exit
- `unless-stopped`: Restart unless manually stopped

### Environment Variables
- Direct definition in `environment` section
- From `.env` files using `env_file`
- Can reference other environment variables: `${HOST_PORT}`
