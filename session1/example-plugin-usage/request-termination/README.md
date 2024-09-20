## Introduction

If you have a license file `license.json` and you want to use enterprise image, store the licence to environment variable with below command.

```bash
export KONG_LICENSE_DATA=$(cat license.json)
```

Modify KONG_ADMIN_GUI_URL to your host IP if using cloud VM instead of `localhost`.

```
sed -i 's/localhost/<Your Host IP>/g' docker-compose.yml
```

Start Kong, Kong migrations and Database containers using docker-compose

```shell
docker compose up -d
```

## Verify whether containers are up or not

```shell
docker ps

CONTAINER ID        IMAGE                                    COMMAND             CREATED             STATUS              PORTS                     NAMES
be4733068e81   kong/kong-gateway:2.3.3.2-alpine   "/docker-entrypoint.…"   4 seconds ago    Up 2 seconds (healthy)    0.0.0.0:8000-8004->8000-8004/tcp, :::8000-8004->8000-8004/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong
525c3dc73b92   postgres:15-alpine                 "docker-entrypoint.s…"   12 seconds ago   Up 11 seconds (healthy)   5432 tcp                                                                                                                                      kong-database
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
  name=terminate-route \
  paths:='["/terminate"]'
```

## Add Plugin to the Service

```shell
http -f :8001/routes/terminate-route/plugins \
  name=request-termination \
  config.status_code=403 \
  config.message="So long and thanks for all the fish\!"
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
Date: Fri, 20 Sep 2024 03:18:47 GMT
Server: kong/3.4.3.12-enterprise-edition
X-Kong-Request-Id: 53d2ca230458a348bb2f633c82d16e0e
X-Kong-Response-Latency: 7

{
  "message": "So long and thanks for all the fish!"
}
```

## Cleanup

```shell
docker compose down -v
```
