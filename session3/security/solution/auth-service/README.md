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
CONTAINER ID   IMAGE                   COMMAND                  CREATED             STATUS                       PORTS                     NAMES
2ccab5f92697   liyangau/auth-service   "docker-entrypoint.s…"   12 seconds ago      Up 11 seconds                0.0.0.0:55002->3000/tcp   inspiring_lamarr
```
## Test
```bash
curl -i http://<ip>:55002/auth/validate/customer?custId=a
```
```bash
curl -i -H'Authorization: Bearer c' localhost:55002/auth/validate/token
```

You should see 200 or 403 depending on the custId or token
