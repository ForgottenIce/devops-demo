# Java version: 19
FROM eclipse-temurin:19-jammy

LABEL org.opencontainers.image.source=https://github.com/DaFessor/devops-demo

# Install Maven
RUN apt-get update && apt-get install maven git -y && mkdir /workspace

# Port used by Spring app (only used locally, not on GitHub)
EXPOSE 8080
CMD ["bash"]