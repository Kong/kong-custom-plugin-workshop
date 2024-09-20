## Introduction

If you have a license file `license.json` and you want to use enterprise image, store the licence to environment variable with below command.

```bash
export KONG_LICENSE_DATA=$(cat license.json)
```

Prior to this exercise, it is assumed you have setup Pongo

Clone the Kong plugin template if not present: https://github.com/Kong/kong-plugin.git

```shell
git clone https://github.com/Kong/kong-plugin.git
cd kong-plugin
```

Below commands needs to be running inside plugin folder

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

## Add MyPlugin to the Service

```shell
http -f :8001/services/example-service/plugins \
    name=myplugin
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
Content-Length: 622
Content-Type: application/json
Date: Fri, 20 Sep 2024 04:42:18 GMT
Server: gunicorn/19.9.0
Via: kong/3.4.3.12-enterprise-edition
X-Kong-Proxy-Latency: 54
X-Kong-Request-Id: a4a1a535066728190c24de5049cd6e29
X-Kong-Upstream-Latency: 424

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Hello-World": "this is on a request",
    "Host": "httpbin.org",
    "User-Agent": "HTTPie/3.2.3",
    "X-Amzn-Trace-Id": "Root=1-66ecfd2a-72dd15445c2c0eda39f86220",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/echo/anything",
    "X-Forwarded-Prefix": "/echo",
    "X-Kong-Request-Id": "a4a1a535066728190c24de5049cd6e29"
  },
  "json": null,
  "method": "GET",
  "origin": "172.20.0.3",
  "url": "http://localhost/anything"
}
```

# Add a log entry to each phase

In another terminal, update `handler.lua` to add a log line for each phase

```lua
kong.log.debug(" In phase <name of phase>")
```

Tail the kongs logs in a separate window, run

```shell
pongo tail
```

# Go back to the Kong shell and reload Kong to pick up latest plugin changes

```shell
kong reload
```

# Test

```shell
http :8000/echo/anything
```

Validate that you can see log entries for all the logs

# Clean up

Exit from the shell created to the Kong container

```shell
exit
```

Remove Pongo dependencies

```shell
pongo down
```
