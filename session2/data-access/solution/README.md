## Bring up pongo dependencies

```shell
cd kong-plugin
pongo up
```

To specify different versions of the dependencies or image or license_data

```shell
KONG_VERSION=3.4.x pongo up
POSTGRES=15 KONG_VERSION=3.4.x pongo up
POSTGRES=15 KONG_VERSION=3.4.3.x KONG_LICENSE_DATA=$KONG_LICENSE_DATA pongo up
```
Use these variables for each of the following commands to run pongo against specific versions of Kong or any dependencies

## Expose services

```shell
pongo expose
```

## Create a Kong container and attach a shell

```shell
pongo shell
```

The following commands should be run from within the Kong shell

## Boostrap the database

```shell
kong migrations bootstrap --force
kong start
```

## Add a service

```shell
http POST :8001/services name=example-service \
    url=http://httpbin.org
```

## Add a Route to the Service

```shell
http POST :8001/services/example-service/routes \
    name=example-route \
    paths:='["/echo"]'
```

### Test

Enable plugin

```shell
http -f :8001/services/example-service/plugins \
    name=myplugin
```
```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 799
Content-Type: application/json; charset=utf-8
Date: Fri, 20 Sep 2024 11:50:46 GMT
Server: kong/3.8.0
X-Kong-Request-Id: 51feb71de15bae26e5950f2aafe4c16b
X-Kong-Response-Latency: 4

{
    "routes": {
        "example-route": {
            "created_at": 1726832780,
            "https_redirect_status_code": 426,
            "id": "9741f03d-7aae-453a-8180-d63c8849f3a2",
            "name": "example-route",
            "path_handling": "v0",
            "paths": [
                "/echo"
            ],
            "preserve_host": false,
            "protocols": [
                "http",
                "https"
            ],
            "regex_priority": 0,
            "request_buffering": true,
            "response_buffering": true,
            "service": {
                "id": "bdd5b30d-6ac9-4013-9b51-27a11cbccb25"
            },
            "strip_path": true,
            "updated_at": 1726832780,
            "ws_id": "ff034d62-5334-4b36-bd7c-46e74b40710a"
        }
    },
    "services": {
        "example-service": {
            "connect_timeout": 60000,
            "created_at": 1726832774,
            "enabled": true,
            "host": "httpbin.org",
            "id": "bdd5b30d-6ac9-4013-9b51-27a11cbccb25",
            "name": "example-service",
            "port": 80,
            "protocol": "http",
            "read_timeout": 60000,
            "retries": 5,
            "updated_at": 1726832774,
            "write_timeout": 60000,
            "ws_id": "ff034d62-5334-4b36-bd7c-46e74b40710a"
        }
    }
}
```

# Clean up

Exit from the shell created to the Kong container

```shell
exit
```

Remove Pongo dependencies

```shell
pongo down
```
