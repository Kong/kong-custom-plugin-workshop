## Introduction

Start Kong, Database and Auth Service containers using docker-compose, before docker-compose up, we need to run database migrations

```shell
    docker-compose -f docker-compose-kong.yml run kong kong migrations bootstrap
    docker-compose -f docker-compose-kong.yml -f docker-compose-auth-service.yml up -d --build
```

## Verify whether containers are up or not

```shell
    docker ps

    CONTAINER ID        IMAGE                                    COMMAND             CREATED             STATUS              PORTS                     NAMES
    be4733068e81   kong/kong-gateway:2.3.3.2-alpine   "/docker-entrypoint.…"   4 seconds ago    Up 2 seconds (healthy)    0.0.0.0:8000-8004->8000-8004/tcp, :::8000-8004->8000-8004/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong
    525c3dc73b92   postgres:13-alpine                 "docker-entrypoint.s…"   12 seconds ago   Up 11 seconds (healthy)   5432 tcp                                                                                                                                      kong-database
```

## Add a service

```shell
    http POST :8001/services name=example-service url=http://httpbin.org
```

## Add a Route to the Service

```shell
    http POST :8001/services/example-service/routes name=example-route paths:='["/echo"]'
```

## Add Plugin to the Service

```shell
    http -f POST :8001/services/example-service/plugins name=myplugin
```

This will enable myplugin

## Test

```shell
    http :8000/echo/anything Authorization:token1 custId==customer1
    http :8000/echo/anything Authorization:token2 custId==customer2
    http :8000/echo/anything Authorization:token3 custId==customer3
```

## Cleanup

```shell
    docker-compose -f docker-compose-kong.yml -f docker-compose-auth-service.yml down -v
```
