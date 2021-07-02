## Introduction

Update .env with Kong EE License (If required), Kong version and Postgres version

Start Kong, Database and Auth Service containers using docker-compose, before docker-compose up, we need to run database migrations

```shell
docker-compose -f docker-compose-kong.yml run kong kong migrations bootstrap
docker-compose -f docker-compose-kong.yml -f docker-compose-auth-service.yml up -d --build
```

## Verify whether containers are up or not

```shell
docker ps

CONTAINER ID   IMAGE                              COMMAND                  CREATED              STATUS                        PORTS                                                                                                                                         NAMES
ff9461ad3c04   auth-service                       "docker-entrypoint.s…"   9 seconds ago        Up 8 seconds                  0.0.0.0:3000->3000/tcp, :::3000->3000/tcp                                                                                                     solution_auth-service_1
436a20d1c0f7   kong/kong-gateway:2.3.3.1-alpine   "/docker-entrypoint.…"   9 seconds ago        Up 8 seconds (healthy)        0.0.0.0:8000-8004->8000-8004/tcp, :::8000-8004->8000-8004/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong
c0e510fe82cc   postgres:9.5-alpine                "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   5432/tcp                                                                                                                                      kong-database
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

## In another terminal, open the logs of the auth-service container to view the calls from the Kong plugin

```shell
docker-compose -f docker-compose-kong.yml -f docker-compose-auth-service.yml logs -f auth-service
```

## Test 1 - Specify a valid authorization token and customerId:

```shell
http :8000/echo/anything Authorization:token1 custId==customer1
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 636
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:58:56 GMT
Server: gunicorn/19.9.0
Via: kong/2.3.3.2-enterprise-edition
X-Kong-Proxy-Latency: 1677
X-Kong-Upstream-Latency: 519

{
    "args": {
        "custId": "customer1"
    },
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Authorization": "token1",
        "Hello-World": "this is on a request",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.3.0",
        "X-Amzn-Trace-Id": "Root=1-60dc2440-7993f28606c7ce4b2a2cff3a",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "192.168.64.1, 223.196.172.10",
    "url": "http://localhost/anything?custId=customer1"
}


```

## Test 2 - Specify a valid authorization token and invalid customerId:

```shell
http :8000/echo/anything Authorization:token2 custId==customer5
```

Response:

```shell
HTTP/1.1 403 Forbidden
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 20
Date: Wed, 30 Jun 2021 07:59:35 GMT
Server: kong/2.3.3.2-enterprise-edition
X-Kong-Response-Latency: 4

Authorization Failed


```

## Test 3 - Specify an invalid authorization token and valid customerId:

```shell
http :8000/echo/anything Authorization:token5 custId==customer3
```

Response:

```shell
HTTP/1.1 403 Forbidden
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 21
Date: Wed, 30 Jun 2021 08:00:04 GMT
Server: kong/2.3.3.2-enterprise-edition
X-Kong-Response-Latency: 2

Authentication Failed


```

## Cleanup

```shell
docker-compose -f docker-compose-kong.yml -f docker-compose-auth-service.yml down -v
```
