### Dependency defaults

Update `.pongo/pongorc` file to disable cassandra

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

## Boostrap the database and start kong

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

## Add MyPlugin to the Service

200 from authentication

    Default authentication url is set to http://httpbin.org/status/200

```shell
http -f :8001/services/example-service/plugins name=myplugin
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 555
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:10:57 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 864
X-Kong-Upstream-Latency: 537

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Hello-World": "this is on a request",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Amzn-Trace-Id": "Root=1-60dc1901-42fd38e0768a65e74aba4eb4",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.174.11",
    "url": "http://localhost/anything"
}

```

403 from authentication

```shell
http :8001/services/example-service/plugins
http DELETE :8001/services/example-service/plugins/<plugin-id>
http -f :8001/services/example-service/plugins name=myplugin config.authentication_url=http://httpbin.org/status/403
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 403 Forbidden
Connection: keep-alive
Content-Length: 21
Date: Wed, 30 Jun 2021 07:12:21 GMT
Server: kong/2.4.1
X-Kong-Response-Latency: 856

Authentication Failed
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
