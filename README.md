# jdk-ecr-helper
`library/openjdk:17-jdk-slim-bullseye` based image with:
* awscliv2
* git
* postgresql-client
* ssh

## building and pushing
```
podman build . --tag 294686472773.dkr.ecr.us-east-1.amazonaws.com/bitbucket/jdk-build:17
aws ecr get-login-password | podman login --username AWS --password-stdin 294686472773.dkr.ecr.us-east-1.amazonaws.com
podman push 294686472773.dkr.ecr.us-east-1.amazonaws.com/bitbucket/jdk-build:17
```

### troubleshooting
If you get a certificate error during `podman build .`
```
podman pull docker.io/library/openjdk:17-jdk-slim-bullseye --tls-verify=false
```
