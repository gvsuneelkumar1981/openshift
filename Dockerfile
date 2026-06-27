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

# CRITICAL FOR OPENSHIFT:
# Support running as an arbitrary user by granting group permissions to group 0
RUN chgrp -R 0 /app && \
    chmod -R g=u /app \

COPY --from=builder /app/target/*.jar app.jar

# Fix permissions on jar file too
RUN chgrp 0 app.jar && \
    chmod g=u app.jar \

#JVM flags tuned for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]