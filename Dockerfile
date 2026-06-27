#====================================
#   Stage 1: Build
#====================================
FROM --platform=linux/amd64 maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn package -DskipTests -B

#====================================
#   Stage 2: Runtime
#====================================
FROM --platform=linux/amd64 eclipse-temurin:21-jre-jammy

WORKDIR /app

# Non-root user — OCP REQUIRES this
# OCP rejects containers running as root by default
RUN useradd -r -u 1001 -g root appuser
USER 1001

COPY --from=builder /app/target/*.jar app.jar

#JVM flags tuned for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]