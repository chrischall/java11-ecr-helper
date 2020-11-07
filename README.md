# java11-ecr-helper
`openjdk:11-jdk-slim-buster` based image with:
* amazon-ecr-credential-helper
* git
* postgresql-client
* ssh

## building and pushing
```
docker build .
docker tag <image_hash> chrischall/jdk-ecr-helper:11
docker push chrischall/jdk-ecr-helper:11
```
