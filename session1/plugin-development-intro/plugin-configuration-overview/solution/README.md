### Dependency defaults

Update `.pongo/pongorc` file inside plugin folder to disable cassandra

```shell
--no-cassandra
```

## Bring up pongo dependencies

```shell
pongo up
```

To specify different versions of the dependencies or image or license_data

```shell
KONG_VERSION=2.3.x pongo up
POSTGRES=10 KONG_VERSION=2.3.3.x pongo up
POSTGRES=10 KONG_LICENSE_DATA=<your_license_data> pongo up
```

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
http POST :8001/services name=example-service url=http://httpbin.org
```

## Add a Route to the Service

```shell
http POST :8001/services/example-service/routes name=example-route paths:='["/echo"]'
```

### Test 1

Enable plugin: Remove Accept Header

```shell
http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 489
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:26:42 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 114
X-Kong-Upstream-Latency: 529

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept-Encoding": "gzip, deflate",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Amzn-Trace-Id": "Root=1-60dc1cb2-7bc397f206e5182f512d0c34",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.172.10",
    "url": "http://localhost/anything"
}


```

### Test 2

Enable plugin: Remove Accept-Encoding Header

```shell
http :8001/services/example-service/plugins
http DELETE :8001/services/example-service/plugins/<plugin-id>
http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept-encoding
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 470
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:27:29 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 301
X-Kong-Upstream-Latency: 618

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Amzn-Trace-Id": "Root=1-60dc1ce1-1052e2d12dc38c6436de7968",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.168.24",
    "url": "http://localhost/anything"
}


```

### Test 3

Enable plugin: Remove Both Accept and Accept-Encoding Header

```shell
http :8001/services/example-service/plugins
http DELETE :8001/services/example-service/plugins/<plugin-id>
http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept config.remove_request_headers=accept-encoding
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 448
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:28:16 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 95
X-Kong-Upstream-Latency: 605

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Amzn-Trace-Id": "Root=1-60dc1d10-242220940c8f35971d00d4a3",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.168.24",
    "url": "http://localhost/anything"
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
