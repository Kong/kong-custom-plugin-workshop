## Introduction

Docker configuration for a node.js related stack with express. This will allow you to create a node.js image to spin up a bare bones node.js stack using express and hogan.js as the templating engine.

## Build Docker Image

    docker build -t <yourname>/auth-service .

This will build a local Docker image that uses the base node image and configures npm and your working directory in the container.

## Run New Node Container

    docker run -d -P <yourname>/auth-service

This will initialize a new container and run your node application as a background daemon.

## Container Port

    docker ps

Docker will create and assign a random port to route calls from your host machine to your new node.js instance. You should see your new container here with a port mapping like below.

    CONTAINER ID        IMAGE                                    COMMAND             CREATED             STATUS              PORTS                     NAMES
    f2e505d0f3d9        <yourname>/auth-service:latest            bin/www             11 hours ago        Up 51 minutes       0.0.0.0:49153->3000/tcp   high_blackwell

## Test

    curl -i http://<ip>:49153/auth/validate/customer?custId=a
    curl -i -H'Authorization: Bearer c' localhost:49160/auth/validate/token

You should see 200 or 403 depending on the custId or token
