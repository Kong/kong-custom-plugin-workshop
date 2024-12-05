## Introduction

This demo is an example of using custom plugin in Kong EE dbless deployment.

The plugin will be installed using the same method for the Kong EE DB mode deployment. The lua files for the plugin will be mounted in the Kong EE container, and the files will be included in `KONG_LUA_PACKAGE_PATH`.

### Kong Declarative Config

Kong declarative configuration file,  will contain the settings for all desired entities in a single file, and once that file is loaded into Kong, it replaces the entire configuration. Even for custom plugin configuration, it needs to be declared in the decalarative configuration file.

2 declarative configuration files are provided in `dbless_config` directory.

1. `kong.yaml` = service,route

```yaml
_format_version: "3.0"
_transform: true

services:
- name: example-service
  url: http://httpbin.org
  routes:
  - name: example.route
    paths:
    - /echo
```


2. `kong_with_myplugin.yaml` = service,route,custom plugin config

```yaml
_format_version: "3.0"
_transform: true

services:
- name: example-service
  url: http://httpbin.org
  plugins:
  - name: myplugin
    config:
     remove_request_headers:
       - accept
       - accept-encoding
  routes:
  - name: example.route
    paths:
    - /echo
```

## Starting up lab environment

1. If you have a license file `license.json`, store the licence to environment variable with below command.
    ```bash
    export KONG_LICENSE_DATA=$(cat license.json)
    ```
2. Update .env with Kong version

3. Set up `KONG_DECLARATIVE_CONFIG` in `docker-compose.yml` to `kong.yaml`.

    ```yaml
    KONG_DECLARATIVE_CONFIG: /opt/conf/dbless_config/kong.yaml #config without `myplugin`
    # KONG_DECLARATIVE_CONFIG: /opt/conf/dbless_config/kong_with_myplugin.yaml #config with `myplugin`
    ```

Start Kong with  `docker compose up -d`

## Verify whether containers are up or not

```shell
$ docker ps

CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS                   PORTS                                                                                                                                                        NAMES
2e22be0bfccb   kong/kong-gateway:3.4.3.12-ubuntu   "/entrypoint.sh kong…"   3 seconds ago   Up 2 seconds (healthy)   0.0.0.0:8000-8002->8000-8002/tcp, :::8000-8002->8000-8002/tcp, 8003-8004/tcp, 0.0.0.0:8443-8445->8443-8445/tcp, :::8443-8445->8443-8445/tcp, 8446-8447/tcp   kong


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
Content-Length: 578
Content-Type: application/json
Date: Thu, 19 Sep 2024 05:06:33 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 43
X-Kong-Request-Id: 37a38847e561ed04e8348910e432ed2d
X-Kong-Upstream-Latency: 424

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ebb159-47436d6a2750f4a11bd7bff2",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "37a38847e561ed04e8348910e432ed2d"
  },
  "json": null,
  "method": "GET",
  "origin": "172.17.0.1, 202.179.128.36",
  "url": "http://localhost/anything"
}
```

## Enable declarative config with `myplugin`

1. Set up `KONG_DECLARATIVE_CONFIG` in `docker-compose.yml` to `kong_with_myplugin.yaml`. 
```yaml
# KONG_DECLARATIVE_CONFIG: /opt/conf/dbless_config/kong.yaml #config without `myplugin`
KONG_DECLARATIVE_CONFIG: /opt/conf/dbless_config/kong_with_myplugin.yaml #config with `myplugin`
```

Recreate Kong container with  `docker-compose up -d`

```shell
docker compose up -d
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
Content-Length: 555
Content-Type: application/json
Date: Thu, 19 Sep 2024 05:08:08 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 21
X-Kong-Request-Id: 7854d423f5943d776e4b820660258d34
X-Kong-Upstream-Latency: 423

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Hello-World": "this is on a request",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ebb1b8-2b5c556737aef3b617f31fd9",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "7854d423f5943d776e4b820660258d34"
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

