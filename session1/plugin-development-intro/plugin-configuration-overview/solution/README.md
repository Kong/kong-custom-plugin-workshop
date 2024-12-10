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

### Test 1

Enable plugin: Remove Accept Header

```shell
http -f :8001/services/example-service/plugins \
  name=myplugin \
  config.remove_request_headers=accept
```

Verify

```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 600
Content-Type: application/json
Date: Fri, 20 Sep 2024 05:15:45 GMT
Server: gunicorn/19.9.0
Via: 1.1 kong/3.8.0
X-Kong-Proxy-Latency: 8
X-Kong-Request-Id: b1e147611ece3a51f6b28a16e6a72606
X-Kong-Upstream-Latency: 422

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept-Encoding": "gzip, deflate, br",
    "Hello-World": "this is on a request",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ed0501-62395f876f01e3734a26d70d",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "b1e147611ece3a51f6b28a16e6a72606"
  },
  "json": null,
  "method": "GET",
  "origin": "172.20.0.3",
  "url": "http://localhost/anything"
}
```

### Test 2

Delete Existing plugin

```bash
PLUGIN_ID=$(http :8001/services/example-service/plugins | jq -r .data[0].id)
```
```bash
http DELETE :8001/services/example-service/plugins/${PLUGIN_ID}
```

Enable plugin: Remove Accept-Encoding Header

```shell
http -f :8001/services/example-service/plugins \
  name=myplugin \
  config.remove_request_headers=accept-encoding
```

Verify

```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Bye-World: this is on the response
Connection: keep-alive
Content-Length: 577
Content-Type: application/json
Date: Fri, 20 Sep 2024 05:17:13 GMT
Server: gunicorn/19.9.0
Via: 1.1 kong/3.8.0
X-Kong-Proxy-Latency: 34
X-Kong-Request-Id: 922aba2c331a1669c639826a9530e025
X-Kong-Upstream-Latency: 427

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Hello-World": "this is on a request",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ed0559-515dab977353780b25f0b499",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "922aba2c331a1669c639826a9530e025"
  },
  "json": null,
  "method": "GET",
  "origin": "172.20.0.3",
  "url": "http://localhost/anything"
}
```

### Test 3

Delete Existing plugin

```bash
PLUGIN_ID=$(http :8001/services/example-service/plugins | jq -r .data[0].id)
```
```bash
http DELETE :8001/services/example-service/plugins/${PLUGIN_ID}
```

Enable plugin: Remove Both Accept and Accept-Encoding Header

```bash
http -f :8001/services/example-service/plugins \
  name=myplugin \
  config.remove_request_headers=accept \
  config.remove_request_headers=accept-encoding
```

Verify

```bash
http :8000/echo/anything
```

Response:

```shell
HTTP/1.1 200 OK                                                                                         Access-Control-Allow-Credentials: true                                                                  Access-Control-Allow-Origin: *                                                                          Bye-World: this is on the response                                                                      Connection: keep-alive                                                                                  Content-Length: 552                                                                                     Content-Type: application/json                                                                          Date: Fri, 20 Sep 2024 05:18:23 GMT                                                                     Server: gunicorn/19.9.0                                                                                 Via: 1.1 kong/3.8.0                                                                                     X-Kong-Proxy-Latency: 10                                                                                X-Kong-Request-Id: 889d756137826f00e2c0ec7f1a38742f                                                     X-Kong-Upstream-Latency: 442                                                                                                     {                                                                                                           "args": {},
"data": "",                                                                                             "files": {},                                                                                            "form": {},
    "headers": {
        "Hello-World": "this is on a request",
        "Host": "httpbin.org",
        "User-Agent": "xh/0.22.2",
        "X-Amzn-Trace-Id": "Root=1-66ed059f-5a12e787353a907d2065eb23",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo",
        "X-Kong-Request-Id": "889d756137826f00e2c0ec7f1a38742f"
    },
    "json": null,
    "method": "GET",
    "origin": "172.20.0.3",
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
