FROM openjdk:11-jdk-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    amazon-ecr-credential-helper \
  && rm -rf /var/lib/apt/lists/*