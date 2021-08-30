## Introduction

Update .env with Kong EE License (If required), Kong version and Postgres version

Modify KONG_PORTAL_GUI_URL and KONG_ADMIN_GUI_URL to your host IP if using cloud VM instead of localhost

```
sed -i 's/localhost/<Your Host IP>/g' docker-compose.yml
```

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
http POST :8001/services/example-service/routes name=example-route paths:='["/transform"]'
```

## Add Plugin to the Service

```shell
http -f POST :8001/services/example-service/plugins name=request-transformer config.remove.headers=accept config.remove.querystring=custId config.remove.body=custId
```

This will enable request transformer plugin which will remove `accept` header, `custId` in query string and `custId` in body
For available configuration values, please check https://docs.konghq.com/hub/kong-inc/request-transformer/

## Test

```shell
http :8000/transform/anything custId==200 a==100 #query string
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 525
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:22:58 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 1525
X-Kong-Upstream-Latency: 587

{
    "args": {
        "a": "100"
    },
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept-Encoding": "gzip, deflate",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.3.0",
        "X-Amzn-Trace-Id": "Root=1-60dc1bd2-2f702728664edef83272ae9f",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/transform/anything",
        "X-Forwarded-Prefix": "/transform"
    },
    "json": null,
    "method": "GET",
    "origin": "172.25.0.1, 223.196.173.146",
    "url": "http://localhost/anything?a=100"
}



```

```shell
http :8000/transform/anything a==200 custId=200 another=abc #body
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 639
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:23:52 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 257
X-Kong-Upstream-Latency: 725

{
    "args": {
        "a": "200"
    },
    "data": "{\"another\":\"abc\"}",
    "files": {},
    "form": {},
    "headers": {
        "Accept-Encoding": "gzip, deflate",
        "Content-Length": "17",
        "Content-Type": "application/json",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.3.0",
        "X-Amzn-Trace-Id": "Root=1-60dc1c08-4c2c16d535aee26a00cc80ef",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/transform/anything",
        "X-Forwarded-Prefix": "/transform"
    },
    "json": {
        "another": "abc"
    },
    "method": "POST",
    "origin": "172.25.0.1, 223.196.173.146",
    "url": "http://localhost/anything?a=200"
}



```

## Cleanup

```shell
docker-compose down --volumes
```
