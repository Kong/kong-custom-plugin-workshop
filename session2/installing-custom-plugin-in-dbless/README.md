## Introduction

1. Update .env with Kong EE License (If required), Kong version 

2. Set up `KONG_DECLARATIVE_CONFIG` in `docker-compose.yml` to `kong.yaml`. Comment the line :
>KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong_with_myplugin.yaml
```

 - KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong.yaml #config without `myplugin`
 #- KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong_with_myplugin.yaml #config with `myplugin`
```

Start Kong with  `docker-compose up -d`

```shell
docker-compose up -d
```

## Verify whether containers are up or not

```shell
$ docker container ls

CONTAINER ID   IMAGE                              COMMAND                  CREATED              STATUS                        PORTS                                                                                                                                         NAMES
5cbe5b2003c8   kong/kong-gateway:2.3.3.2-alpine   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8000-8004->8000-8004/tcp, :::8000-8004->8000-8004/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong


```
## Test

```shell
http :8000/echo/anything
```

Response:

```shell
$ http :8000/echo/anything

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 512
Content-Type: application/json
Date: Mon, 23 Aug 2021 02:00:04 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 28
X-Kong-Upstream-Latency: 495

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.4.0",
        "X-Amzn-Trace-Id": "Root=1-61230124-06f4222a7c9dc68f43be9248",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "172.23.0.1, 202.186.86.152",
    "url": "http://localhost/anything"
}

```

## Enable declarative config with `myplugin`

1. Set up `KONG_DECLARATIVE_CONFIG` in `docker-compose.yml` to `kong_with_myplugin.yaml`. Comment the line :
>KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong.yaml
```

 #- KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong.yaml #config without `myplugin`
 - KONG_DECLARATIVE_CONFIG=/opt/conf/dbless_config/kong_with_myplugin.yaml #config with `myplugin`
```

Recreate Kong container with  `docker-compose up -d`

```shell
docker-compose up -d
```

## Test

```shell
http :8000/echo/anything
```

Response:

```shell
$ http :8000/echo/anything

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 493
Content-Type: application/json
Date: Mon, 23 Aug 2021 02:04:04 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 21
X-Kong-Upstream-Latency: 514

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Hello-World": "this is on a request", # `Accept` is removed and new header is added
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.4.0",
        "X-Amzn-Trace-Id": "Root=1-61230214-45a7b57923e516703442b934",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "172.23.0.1, 202.186.86.152",
    "url": "http://localhost/anything"
}

```

## Cleanup

    docker-compose down

