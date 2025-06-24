# Ocean compose overview

This document describes the relationships and roles of the services defined in the provided `docker-compose.yml` and `docker-compose.override.yml` files for the **Ocean** system, with a focus on what gets overridden.

## About Ocean

**Ocean** is the overarching name for the entire service ecosystem composed by these Docker Compose files. It brings together multiple microservices, databases, monitoring, and supporting infrastructure into a unified platform.

### docker-compose.yml
```yaml
services:
    mongodb:
        restart: unless-stopped
        image: mongo:latest
        command: ['/bin/sh', '-c', 'chmod +x /entrypoint.sh && /entrypoint.sh']
        logging:
            driver: 'json-file'
            options:
                max-size: '10m'
                max-file: '5'
        ports:
            - 27017:27017
        healthcheck:
            test: ['CMD', 'mongosh', '--eval', "db.runCommand('ping').ok"]
            interval: 10s
            timeout: 5s
            retries: 60
        volumes:
            - mongodb_data_volume:/data/db
            - logs_volume:/var/log/mongodb:rwz
            - ./entrypoint.sh:/entrypoint.sh:rwz
    mgob:
        restart: unless-stopped
        image: maxisam/mgob:latest
        ports:
            - 8090:8090
        volumes:
            - mongodb_backup_volume:/data
            - mongodb_backup_volume:/storage
            - mongodb_backup_volume:/tmp
            - ./mongo.yaml:/config/mongo.yaml
        depends_on:
            mongodb:
                condition: service_healthy
    ingress:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/ingress:1.0.322
        depends_on:
            auth:
              condition: service_started
        environment:
            - Cratis__MongoDB__Server=mongodb://mongodb:27017
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
            - Authentication__Schemes__OpenIdConnect__Authority=http://auth:8080/
            - Authentication__Schemes__Bearer__Authority=http://auth:8080/
            - Microservices__Portal__Backend__BaseUrl=http://portal:8080/
            - Microservices__Portal__Frontend__BaseUrl=http://portal:8080/
            - Microservices__Accounts__Backend__BaseUrl=http://accounts:8080/
            - Microservices__Accounts__Frontend__BaseUrl=http://accounts:8080/
            - Microservices__Exercises__Backend__BaseUrl=http://exercises:8080/
            - Microservices__Exercises__Frontend__BaseUrl=http://exercises:8080/
            - Microservices__Management__Backend__BaseUrl=http://management:8080/
            - Microservices__Management__Frontend__BaseUrl=http://management:8080/
            - ASPNETCORE_Kestrel__Certificates__Default__Path=/https/ocean.pfx
            - ASPNETCORE_Kestrel__Certificates__Default__Password=${CERTIFICATE_PASSWORD}
            - ASPNETCORE_URLS=https://+:5443
        ports:
            - 5443:5443
        volumes:
            - ${OCEAN_DIR}/certificates:/https:ro
    auth:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/auth:1.0.322
        depends_on:
            mongodb:
                condition: service_healthy
        environment:
            - Cratis__MongoDB__Server=mongodb://mongodb:27017
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
            - Clients__Ingress__RedirectUri=https://${OCEAN_HOST}:5443/signin-oidc
            - AccountsBaseUrl=http://accounts:8080/
            - Issuer=https://${OCEAN_HOST}:5443
    portal:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/portal:1.0.322
        depends_on:
            mongodb:
                condition: service_healthy
        environment:
            - Cratis__MongoDB__Server=mongodb://mongodb:27017
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
    accounts:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/accounts:1.0.322
        depends_on:
            mongodb:
                condition: service_healthy
        environment:
            - Cratis__MongoDB__Server=mongodb://mongodb:27017
            - Cratis__Chronicle__Workbench__Port=8081
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
            - services__Exercises__http__0=http://exercises:8080
            - services__Ingress__http__0=https://ingress:5443
        ports:
            - 5602:8081
    exercises:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/exercises:1.0.322
        depends_on:
            mongodb:
                condition: service_healthy
        environment:
            - Cratis__MongoDB__Server=mongodb://mongodb:27017
            - Cratis__Chronicle__Workbench__Port=8081
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
            - ExerciseServerConfiguration__MonitorEnabled=${EXERCISE_SERVER_MONITOR_ENABLED}
            - ExerciseServerConfiguration__BaseUri=${EXERCISE_SERVER_BASE_URI}
        ports:
            - 5603:8081
        volumes:
            - exercises_volume:/app/ExercisesCatalog
    management:
        restart: unless-stopped
        image: croceandev.azurecr.io/ocean/management:1.0.322
        depends_on:
            mongodb:
                condition: service_healthy
        environment:
            - MongoDB__DatabaseName=Management
            - MongoDB__ConnectionString=mongodb://mongodb:27017/?serverSelectionTimeoutMS=5000&replicaSet=rs0&directConnection=true
            - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317/
            - ASPNETCORE_LOGGING__LogLevel__Default=Warning
    aspire-dashboard:
        restart: unless-stopped
        image: mcr.microsoft.com/dotnet/aspire-dashboard:latest
        environment:
            - DOTNET_DASHBOARD_UNSECURED_ALLOW_ANONYMOUS=true
        ports:
            - 18888:18888
            - 18889:18889
    otel-collector:
        restart: unless-stopped
        image: otel/opentelemetry-collector-contrib
        volumes:
            - logs_volume:/logs:rwz
            - logs_volume:/var/log/mongodb:rwz
            - ./otel-collector-config.yaml:/etc/otelcol-contrib/config.yaml
        ports:
            - 1888:1888 # pprof extension
            - 8888:8888 # Prometheus metrics exposed by the Collector
            - 8889:8889 # Prometheus exporter metrics
            - 13133:13133 # health_check extension
            - 4317:4317 # OTLP gRPC receiver
            - 4318:4318 # OTLP http receiver
            - 55679:55679 # zpages extension
        environment:
            - OTEL_EXPORTER_OTLP_LOGS_INSECURE=true

volumes:
    mongodb_data_volume:
        driver: local
        driver_opts:
            type: 'none'
            device: '${OCEAN_DIR_MOUNT}/db'
            o: 'bind'

    mongodb_backup_volume:
        driver: local
        driver_opts:
            type: 'none'
            device: '${OCEAN_DIR_MOUNT}/backups'
            o: 'bind'

    logs_volume:
        driver: local
        driver_opts:
            type: 'none'
            device: '${OCEAN_DIR_MOUNT}/logs'
            o: 'bind'

    exercises_volume:
```

### docker-compose.override.yml
```yaml
services:
    exercises:
        environment:
          - ExerciseServerConfiguration__BaseUri=http://172.16.200.1:5050
          - ExerciseServerConfiguration__MonitorEnabled=true

volumes:
    exercises_volume:
        driver: local
        driver_opts:
            type: 'cifs'
            device: '//172.16.200.161/Exercise'
            o: 'username=Sim,password=sim,vers=3.0'
```

## What Gets Overridden

- **exercises service environment variables**:
  - In `docker-compose.yml`, `ExerciseServerConfiguration__BaseUri` and `ExerciseServerConfiguration__MonitorEnabled` are set using environment variables `${EXERCISE_SERVER_BASE_URI}` and `${EXERCISE_SERVER_MONITOR_ENABLED}`.
  - In `docker-compose.override.yml`, these are overridden with explicit values:
    - `ExerciseServerConfiguration__BaseUri=http://172.16.200.1:5050`
    - `ExerciseServerConfiguration__MonitorEnabled=true`

- **exercises_volume**:
  - In `docker-compose.yml`, `exercises_volume` is defined but not given a specific driver or options.
  - In `docker-compose.override.yml`, `exercises_volume` is redefined to use the `cifs` driver, mounting a network share (`//172.16.200.161/Exercise`) with provided credentials and options, making it suitable for Windows environments.

## Summary

The override file customizes the `exercises` service for local development by:
- Setting specific environment variables for the exercises server.
- Mounting the exercises data from a network share using CIFS, instead of the default volume definition.

When running `docker-compose up`, these overrides take precedence over the base definitions, allowing for environment-specific configuration without modifying the main compose file.

---

**Ocean** as a system is designed to be modular, scalable, and adaptable to different environments through the use of these compose files and overrides.
