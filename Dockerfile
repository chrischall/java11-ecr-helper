FROM openjdk:11-jdk-slim-buster

RUN set -eux; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    amazon-ecr-credential-helper \
    curl \
    git \
    postgresql-client \
    ssh \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && rm awscliv2.zip \
  && ./aws/install \
  && rm -rf aws/

RUN set -eux; \
  apt-get purge -y \
    curl \
    unzip \
  && apt-get autoremove -y
