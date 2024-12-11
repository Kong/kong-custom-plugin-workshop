## Introduction

Docker configuration for a node.js related stack with express. This will allow you to create a node.js image to spin up a bare bones node.js stack using express and hogan.js as the templating engine.

## Build Docker Image

```bash
docker build -t <yourname>/auth-service .
```
This will build a local Docker image that uses the base node image and configures npm and your working directory in the container.

## Run New Node Container

```bash
docker run -d -P <yourname>/auth-service
```

This will initialize a new container and run your node application as a background daemon.

## Container Port

```bash
docker ps
```
Docker will create and assign a random port to route calls from your host machine to your new node.js instance. You should see your new container here with a port mapping like below.

```text
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS         PORTS                                                     NAMES
96757e68654b   shrikanthraj/auth-service          "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:32769->3000/tcp, [::]:32769->3000/tcp             gracious_fermat
```
## Test

By default, the auth-service accepts the values `a` and `b` as valid customerIds and Auth Tokens.

Calling the service with a valid customer ID:

```bash
curl -i "http://localhost:32769/auth/validate/customer?custId=b"

HTTP/1.1 200 OK
X-Powered-By: Express
Date: Tue, 10 Dec 2024 13:21:36 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Content-Length: 0
```

Calling the service with an invalid token:

```bash
curl -i -H'Authorization: Bearer c' localhost:32769/auth/validate/token

HTTP/1.1 403 Forbidden
X-Powered-By: Express
Date: Tue, 10 Dec 2024 13:23:26 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Content-Length: 0
```

You should see 200 or 403 depending on the custId or token
