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

CONTAINER ID   IMAGE                               COMMAND                  CREATED          STATUS                    PORTS                                                                                                                                                                                              NAMES
b4f4c0b24f0b   kong/kong-gateway:3.4.3.12-ubuntu   "/entrypoint.sh kong…"   28 seconds ago   Up 17 seconds (healthy)   0.0.0.0:8000-8002->8000-8002/tcp, :::8000-8002->8000-8002/tcp, 0.0.0.0:8004->8004/tcp, :::8004->8004/tcp, 8003/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong
fbfeb6ecea5a   postgres:15-alpine                  "docker-entrypoint.s…"   28 seconds ago   Up 26 seconds (healthy)   5432/tcp                                                                                                                                                                                           kong-database
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
    paths:='["/transform"]'
```

## Add Plugin to the Service

```shell
http -f POST :8001/services/example-service/plugins \
    name=request-transformer \
    config.remove.headers=accept \
    config.remove.querystring=custId \
    config.remove.body=custId
```

This will enable request transformer plugin which will remove `accept` header, `custId` in query string and `custId` in body
For available configuration values, please check https://docs.konghq.com/hub/kong-inc/request-transformer/

## Test

```shell
http :8000/transform/anything \
    custId==200 \
    a==100
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 592
Content-Type: application/json
Date: Fri, 20 Sep 2024 03:26:08 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 44
X-Kong-Request-Id: 836d9339af5cf60f9ff51c14ac504907
X-Kong-Upstream-Latency: 879

{
  "args": {
    "a": "100"
  },
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept-Encoding": "gzip, deflate, br",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66eceb50-38c92fac0cb0ad112dc83d90",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/transform/anything",
    "X-Forwarded-Prefix": "/transform",
    "X-Kong-Request-Id": "836d9339af5cf60f9ff51c14ac504907"
  },
  "json": null,
  "method": "GET",
  "origin": "192.168.65.1",
  "url": "http://localhost/anything?a=100"
}
```

Send another request:

```shell
http :8000/transform/anything \
    a==200 \
    custId=200 \
    another=abc
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 706
Content-Type: application/json
Date: Fri, 20 Sep 2024 03:26:44 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 1
X-Kong-Request-Id: 05a0be382e29e563016aba208f570950
X-Kong-Upstream-Latency: 422

{
  "args": {
    "a": "200"
  },
  "data": "{\"another\":\"abc\"}",
  "files": {},
  "form": {},
  "headers": {
    "Accept-Encoding": "gzip, deflate, br",
    "Content-Length": "17",
    "Content-Type": "application/json",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66eceb74-2c84c5496addec486dea6963",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/transform/anything",
    "X-Forwarded-Prefix": "/transform",
    "X-Kong-Request-Id": "05a0be382e29e563016aba208f570950"
  },
  "json": {
    "another": "abc"
  },
  "method": "POST",
  "origin": "192.168.65.1",
  "url": "http://localhost/anything?a=200"
}
```

## Cleanup

```shell
docker compose down -v
```
