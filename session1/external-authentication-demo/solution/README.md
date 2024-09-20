### Navigate to the plugin directory
```shell
cd kong-plugin
```

## Bring up pongo dependencies

```shell
pongo up
```

To specify different versions of the dependencies or image or license_data

```shell
KONG_VERSION=3.4.x pongo up
POSTGRES=15 KONG_VERSION=3.4.x pongo up
POSTGRES=15 KONG_VERSION=3.4.3.x KONG_LICENSE_DATA=$KONG_LICENSE_DATA pongo up
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
http POST :8001/services name=example-service \
 url=http://httpbin.org
```

## Add a Route to the Service

```shell
http POST :8001/services/example-service/routes \
  name=example-route \
  paths:='["/echo"]'
```

## Add MyPlugin to the Service

### 200 from authentication

> Default authentication url is set to http://httpbin.org/status/200

Enable plugin on the service

```shell
http -f :8001/services/example-service/plugins name=myplugin
```

Verification

```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 516
Content-Type: application/json
Date: Mon, 09 Sep 2024 07:38:02 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.2
X-Kong-Proxy-Latency: 631
X-Kong-Upstream-Latency: 415

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
    "X-Amzn-Trace-Id": "Root=1-66dea5da-3cc6be9b503ddb5a777a99a4",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo"
  },
  "json": null,
  "method": "GET",
  "origin": "172.23.0.4, 202.179.129.25",
  "url": "http://localhost/anything"
}
```

### 403 from authentication

Delete previous plugin

```shell
PLUGIN_ID=$(http :8001/services/example-service/plugins | jq -r .data[0].id)
http DELETE :8001/services/example-service/plugins/${PLUGIN_ID}
```

Enable plugin 

```bash
http -f :8001/services/example-service/plugins name=myplugin config.authentication_url=http://httpbin.org/status/403
```
Verification

```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 403 Forbidden
Connection: keep-alive
Content-Length: 21
Date: Mon, 09 Sep 2024 07:40:19 GMT
Server: kong/3.4.2
X-Kong-Response-Latency: 1031

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
