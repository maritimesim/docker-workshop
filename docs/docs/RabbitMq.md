# RabbitMQ with Docker

This document provides an overview of running RabbitMQ with Docker. For detailed guides, see the specific documentation:

## Documentation Options

### 🐳 [RabbitMQ with Docker Run](rabbitmq-docker-run.md)
Complete guide for running RabbitMQ using the `docker run` command with detailed parameter explanations.

### 🐙 [RabbitMQ with Docker Compose](rabbitmq-docker-compose.md)
Comprehensive guide for running RabbitMQ using Docker Compose with line-by-line configuration breakdown.

## Quick Start

### Docker Run (Simple)
```bash
docker run -d --name my-rabbit --hostname my-rabbit \
  -e RABBITMQ_DEFAULT_USER=user \
  -e RABBITMQ_DEFAULT_PASS=password \
  -p 15672:15672 -p 5672:5672 \
  rabbitmq:3-management
```

### Docker Compose (Recommended)
Create a `docker-compose.yml` file:
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
      - "15672:15672"
      - "5672:5672"
    restart: unless-stopped
```

Then run:
```bash
docker-compose up -d
```

## Access Information

Once running, access RabbitMQ at:
- **Management Interface**: http://localhost:15672
- **AMQP Port**: localhost:5672
- **Username**: user
- **Password**: password

## Choose Your Path

- **New to Docker?** Start with [Docker Run guide](rabbitmq-docker-run.md)
- **Production setup?** Use [Docker Compose guide](rabbitmq-docker-compose.md)
- **Need clustering?** See [Docker Compose guide](rabbitmq-docker-compose.md) for advanced configurations
