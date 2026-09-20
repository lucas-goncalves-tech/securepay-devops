# Docker Basics — Reference

## What is a container?

A container is a lightweight, isolated process that packages an application with all its dependencies. Unlike VMs, containers share the host OS kernel — they start in seconds and use minimal resources.

## Dockerfile instructions

| Instruction | Purpose |
|-------------|---------|
| `FROM` | Base image (e.g., `eclipse-temurin:21-jdk-alpine`) |
| `WORKDIR` | Sets the working directory inside the container |
| `COPY` | Copies files from host into the image |
| `RUN` | Executes a command during build (baked into the layer) |
| `CMD` | Default command when the container starts |
| `EXPOSE` | Documents which port the app listens on |
| `USER` | Runs the container as a non-root user |
| `ENTRYPOINT` | Like CMD but harder to override |

## Layer caching — why COPY order matters

Docker builds images in layers. Each instruction creates a layer that is cached until that instruction or its inputs change.

```dockerfile
# BAD: invalidates Maven cache on every code change
COPY . .
RUN ./mvnw clean package -DskipTests

# GOOD: dependencies layer is cached until pom.xml changes
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline -B
COPY src src
RUN ./mvnw clean package -DskipTests
```

When you only change source code (`src/`), the dependency download step is skipped on rebuild.

## Multi-stage builds

Use multi-stage builds to keep the final image small:

```dockerfile
# Stage 1: build
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /build
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline -B
COPY src src
RUN ./mvnw clean package -DskipTests

# Stage 2: runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /build/target/*.jar /app/application.jar
ENTRYPOINT ["java", "-jar", "/app/application.jar"]
```

The final image only contains the JRE and the JAR — no Maven, no source code, no build tools.

## Build and run

```bash
# Build an image
docker build -t myapp:1.0 .

# Run a container
docker run -d -p 8080:8080 --name myapp myapp:1.0

# Check running containers
docker ps

# View logs
docker logs myapp

# Stop and remove
docker stop myapp && docker rm myapp
```

## Key takeaways

1. Containers are isolated processes, not VMs
2. Layer caching makes rebuilds fast — order your Dockerfile to maximize cache hits
3. Multi-stage builds keep production images lean
4. Always use a non-root user in production
5. `COPY` before `RUN` when the `RUN` depends on the copied files
