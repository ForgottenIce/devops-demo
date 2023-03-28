FROM maven:3.8.5-eclipse-temurin-17-alpine AS build
RUN mkdir -p /app
WORKDIR /app
COPY pom.xml /app
COPY src /app/src
RUN mvn -B package --file pom.xml -DskipTests
# Fetch the Java sdk image
FROM eclipse-temurin:17-jdk-alpine
# Expose port 8080
EXPOSE 8080
COPY --from=build /app/target/*jar devops-demo-1.0.jar
ENTRYPOINT ["java","-jar","devops-demo-1.0.jar"]
