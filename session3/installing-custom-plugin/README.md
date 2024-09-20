## Introduction

If you have a license file `license.json` and you want to use enterprise image, store the licence to environment variable with below command.

```bash
export KONG_LICENSE_DATA=$(cat license.json)
```

Update .env with Kong version and Postgres version

Start Kong and Database containers using docker-compose, before docker-compose up, we need to run database migrations

```shell
docker compose up -d
```

## Verify whether containers are up or not

```shell
CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS                   PORTS                                                                                                                                                                                              NAMES
680b20c55ea8   kong/kong-gateway:3.4.3.12-ubuntu   "/entrypoint.sh kong…"   5 minutes ago   Up 5 minutes (healthy)   0.0.0.0:8000-8002->8000-8002/tcp, :::8000-8002->8000-8002/tcp, 0.0.0.0:8004->8004/tcp, :::8004->8004/tcp, 8003/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong
f2ff01297cc0   postgres:15-alpine                  "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes (healthy)   5432/tcp                                                                                                                                                                                           kong-database
```

## Add a service

```shell
http POST :8001/services \
  name=example-service \
  url=http://httpbin.org
```

## Add a Route to the Service

```shell
http POST :8001/services/example-service/routes \
  name=example-route \
  paths:='["/echo"]'
```

## Add Plugin to the Service

```shell
http -f :8001/services/example-service/plugins \
  name=myplugin \
  config.remove_request_headers=accept \
  config.remove_request_headers=accept-encoding
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
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 555
Content-Type: application/json
Date: Thu, 19 Sep 2024 04:36:33 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 25
X-Kong-Request-Id: 161e771d46e5335c42d881146ba65248
X-Kong-Upstream-Latency: 422

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Hello-World": "this is on a request",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ebaa51-177d3c4d4b6c14897ef9869d",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "161e771d46e5335c42d881146ba65248"
  },
  "json": null,
  "method": "GET",
  "origin": "172.17.0.1, 202.179.128.36",
  "url": "http://localhost/anything"
}
```

## Cleanup

```bash
docker compose down
```