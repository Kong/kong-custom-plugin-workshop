## Introduction

Update .env with Kong EE License (If required), Kong version and Postgres version

Start Kong and Database containers using docker-compose, before docker-compose up, we need to run database migrations

```shell
docker-compose run kong kong migrations bootstrap
docker-compose up -d
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
http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept config.remove_request_headers=accept-encoding
```

## Test

```shell
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 448
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:28:16 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 95
X-Kong-Upstream-Latency: 605

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Amzn-Trace-Id": "Root=1-60dc1d10-242220940c8f35971d00d4a3",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.168.24",
    "url": "http://localhost/anything"
}




```

## Cleanup

    docker-compose down
