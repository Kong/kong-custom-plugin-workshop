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
http POST :8001/services/example-service/routes name=terminate-route paths:='["/terminate"]'
```

## Add Plugin to the Service

```shell
http -f :8001/routes/terminate-route/plugins name=request-termination config.status_code=403 config.message="So long and thanks for all the fish\!"
```

This will enable request termination plugin
For available configuration values, please check https://docs.konghq.com/hub/kong-inc/request-termination/

## Test

```shell
http :8000/terminate
```

Response:

```shell
HTTP/1.1 403 Forbidden
Connection: keep-alive
Content-Length: 50
Content-Type: application/json; charset=utf-8
Date: Wed, 30 Jun 2021 07:17:58 GMT
Server: kong/2.3.3.2-enterprise-edition
X-Kong-Response-Latency: 51

{
    "message": "So long and thanks for all the fish!"
}

```

## Cleanup

```shell
docker-compose down -v
```
