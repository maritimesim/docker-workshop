# RabbitMQ with Docker Compose

## The Docker Compose Way (Structured and Scalable)

Docker Compose provides a more structured approach to container management. Here's how to set up RabbitMQ using a `docker-compose.yml` file:

```yaml
services:
  rabbitmq:
    image: rabbitmq:3-management
    container_name: my-rabbit
    hostname: my-rabbit
    environment:
      RABBITMQ_DEFAULT_USER: user
      RABBITMQ_DEFAULT_PASS: password
    ports:
      - "15672:15672"  # Management interface
      - "5672:5672"    # AMQP port
    restart: unless-stopped
```

To use this Docker Compose file:

1. Save the above content as `docker-compose.yml`
2. Run the following command in the same directory:

```bash
docker-compose up -d
```

## Docker Compose File Breakdown

Let's break down each part of this Docker Compose configuration to understand what it does:

### `services:`
- **Purpose**: Defines the top-level section that contains all service definitions
- **Structure**: All your containers/services are defined under this section
- **Benefit**: Allows you to define multiple related services in one file

### `rabbitmq:`
- **Purpose**: The name of our service (you can choose any name)
- **Usage**: This is how you'll reference this service in Docker Compose commands
- **Example**: `docker-compose logs rabbitmq` or `docker-compose restart rabbitmq`

### `image: rabbitmq:3-management`
- **Purpose**: Specifies the Docker image to use for this service
- **Image name**: `rabbitmq` (official RabbitMQ image from Docker Hub)
- **Tag**: `3-management`
  - `3`: Uses RabbitMQ version 3.x (latest stable)
  - `management`: Includes the web management plugin pre-installed
- **Alternative**: You could use `rabbitmq:3` but would need to manually enable the management plugin

### `container_name: my-rabbit`
- **Purpose**: Sets a custom name for the container (optional)
- **Without this**: Docker Compose would generate a name like `folder_rabbitmq_1`
- **Benefit**: Makes it easier to reference the container in Docker commands
- **Best practice**: Use descriptive names that match your project structure

### `hostname: my-rabbit`
- **Purpose**: Sets the hostname inside the container
- **Why important for RabbitMQ**: RabbitMQ uses hostname for clustering and node identification
- **Clustering**: Essential when setting up RabbitMQ clusters
- **Best practice**: Should match the container name for consistency

### `environment:`
- **Purpose**: Defines environment variables that will be set inside the container
- **Format**: Key-value pairs that configure the application
- **Security**: These variables configure RabbitMQ's authentication settings

### `RABBITMQ_DEFAULT_USER: user`
- **Purpose**: Creates a default administrative user
- **Security**: Replaces the default "guest" user (which only works on localhost)
- **Customization**: Change "user" to your preferred admin username
- **Access**: This user will have full administrative privileges

### `RABBITMQ_DEFAULT_PASS: password`
- **Purpose**: Sets the password for the default administrative user
- **Security Warning**: Change "password" to a strong password in production!
- **Access**: Used together with the username to log into the management interface
- **Best practice**: Use environment files (.env) for sensitive data in production

### `ports:`
- **Purpose**: Maps container ports to host machine ports
- **Format**: `"host_port:container_port"`
- **Network**: Allows external access to services running inside the container

### `- "15672:15672"`
- **Purpose**: Maps port 15672 from container to host
- **Service**: RabbitMQ Management Web Interface
- **Access**: Visit `http://localhost:15672` in your browser
- **Protocol**: HTTP/HTTPS web interface
- **Usage**: Administration, monitoring, and queue management

### `- "5672:5672"`
- **Purpose**: Maps port 5672 from container to host
- **Service**: AMQP protocol port (main messaging port)
- **Access**: Applications connect to `localhost:5672` to send/receive messages
- **Protocol**: AMQP (Advanced Message Queuing Protocol)
- **Usage**: Your applications use this port for message queuing operations

### `restart: unless-stopped`
- **Purpose**: Defines the container restart policy
- **Behavior**: Container will automatically restart if it crashes
- **Exception**: Won't restart if manually stopped with `docker stop` or `docker-compose down`
- **Alternatives**: 
  - `no`: Never restart (default)
  - `always`: Always restart, even if manually stopped
  - `on-failure`: Only restart on error exit codes
- **Production benefit**: Ensures high availability of your message broker

## Accessing RabbitMQ

Once the services are running, you can:

### Access the Management Interface
1. Open your browser
2. Navigate to `http://localhost:15672`
3. Login with:
   - **Username**: `user`
   - **Password**: `password`

### Connect Applications
Your applications can connect to RabbitMQ at:
- **Host**: `localhost`
- **Port**: `5672`
- **Username**: `user`
- **Password**: `password`

## Docker Compose Benefits

### Configuration Management
- **Version Control**: Easy to track changes in your repository
- **Reproducible**: Same setup every time across different environments
- **Documentation**: Self-documenting infrastructure
- **Sharing**: Easy to share complete setup with team members

### Multi-Service Architecture
- **Related Services**: Easy to add databases, caches, other message brokers
- **Dependencies**: Define service dependencies and startup order
- **Networks**: Automatic network creation for service communication
- **Volumes**: Persistent data storage configuration

### Environment Flexibility
- **Multiple Environments**: Different configs for dev/staging/production
- **Environment Files**: Use `.env` files for environment-specific values
- **Overrides**: Override configurations without changing the main file
- **Scaling**: Easy to scale services up or down

## Docker Compose Commands

### Start all services:
```bash
docker-compose up -d
```

### Stop all services:
```bash
docker-compose down
```

### View logs for all services:
```bash
docker-compose logs
```

### View logs for specific service:
```bash
docker-compose logs rabbitmq
```

### Follow logs in real-time:
```bash
docker-compose logs -f rabbitmq
```

### Restart services:
```bash
docker-compose restart
```

### Restart specific service:
```bash
docker-compose restart rabbitmq
```

### Check service status:
```bash
docker-compose ps
```

### Execute commands in running service:
```bash
docker-compose exec rabbitmq bash
```

### Pull latest images:
```bash
docker-compose pull
```

### Build and start (if using custom images):
```bash
docker-compose up --build
```

## Advanced Configuration Example

Here's a more advanced Docker Compose configuration with additional features:

```yaml
version: '3.8'

services:
  rabbitmq:
    image: rabbitmq:3-management
    container_name: my-rabbit
    hostname: my-rabbit
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: ${RABBIT_PASSWORD:-defaultpass}
      RABBITMQ_DEFAULT_VHOST: /
    ports:
      - "15672:15672"
      - "5672:5672"
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
      - ./rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf:ro
    networks:
      - rabbitmq_network
    restart: unless-stopped
    healthcheck:
      test: rabbitmq-diagnostics -q ping
      interval: 30s
      timeout: 30s
      retries: 3

volumes:
  rabbitmq_data:

networks:
  rabbitmq_network:
    driver: bridge
```

### Additional Features Explained:

- **`version: '3.8'`**: Specifies Docker Compose file format version
- **`${RABBIT_PASSWORD:-defaultpass}`**: Environment variable with fallback value
- **`volumes:`**: Persistent storage for RabbitMQ data
- **`networks:`**: Custom network for service isolation
- **`healthcheck:`**: Automatic health monitoring
- **`volumes:` (top-level)**: Named volume definitions
- **`networks:` (top-level)**: Network definitions
