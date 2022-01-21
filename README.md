# jdk-ecr-helper
`openjdk:17-jdk-slim-bullseye` based image with:
* amazon-ecr-credential-helper
* git
* postgresql-client
* ssh

## building and pushing
```
docker build .
docker tag <image_hash> chrischall/jdk-ecr-helper:17
docker push chrischall/jdk-ecr-helper:17
```
