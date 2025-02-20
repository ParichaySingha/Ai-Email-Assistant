#FROM maven:3.8.4-openjdk-17 AS build
#WORKDIR /APP
#
#COPY pom.xml .
#RUN mvn dependency:go-offline
#
#COPY src ./src
#RUN mvn clean package -DskipTests
#
#FROM openjdk:17-jdk-slim
#
#WORKDIR /app
#
#COPY --from=build /app/target/email-writer-sb-0.0.1-SNAPSHOT.jar .
#
#EXPOSE 8080
#
#ENTRYPOINT ["java", "-jar", "/app/email-writer-sb-0.0.1-SNAPSHOT.jar"]
#
# Stage 1: Build the application
FROM maven:3.8.6-jdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Package the application into a lightweight image
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/email-writer-sb-0.0.1-SNAPSHOT.jar /app/email-writer-sb.jar
ENTRYPOINT ["java", "-jar", "/app/email-writer-sb.jar"]
