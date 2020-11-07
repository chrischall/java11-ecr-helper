FROM openjdk:11-jdk-slim-buster

RUN set -eux; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    amazon-ecr-credential-helper \
    git \
    postgresql-client \
    ssh \
  && rm -rf /var/lib/apt/lists/*
