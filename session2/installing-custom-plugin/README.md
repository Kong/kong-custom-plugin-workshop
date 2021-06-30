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
http -f POST :8001/services/example-service/plugins name=myplugin
```

## Test

```shell
http :8000/echo/anything custId==200 a==100
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 570
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:44:34 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 154
X-Kong-Upstream-Latency: 569

{
    "args": {
        "a": "100",
        "custId": "200"
    },
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.3.0",
        "X-Amzn-Trace-Id": "Root=1-60dc20e2-311c114e7c64891b5fb1e2fc",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "172.31.0.1, 223.196.169.116",
    "url": "http://localhost/anything?custId=200&a=100"
}



```

```shell
http :8000/echo/anything a==200 custId=200 another=abc
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 718
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:45:09 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 43
X-Kong-Upstream-Latency: 605

{
    "args": {
        "a": "200"
    },
    "data": "{\"custId\": \"200\", \"another\": \"abc\"}",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "application/json, */*;q=0.5",
        "Accept-Encoding": "gzip, deflate",
        "Content-Length": "35",
        "Content-Type": "application/json",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.3.0",
        "X-Amzn-Trace-Id": "Root=1-60dc2105-4f65ca6a78331424491a3ff1",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": {
        "another": "abc",
        "custId": "200"
    },
    "method": "POST",
    "origin": "172.31.0.1, 223.196.168.24",
    "url": "http://localhost/anything?a=200"
}

```

## Cleanup

    docker-compose down
