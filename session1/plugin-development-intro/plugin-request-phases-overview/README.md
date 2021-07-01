## Introduction

Prior to this exercise, it is assumed you have setup Pongo

Clone the Kong plugin template if not present: https://github.com/Kong/kong-plugin.git

```shell
    git clone https://github.com/Kong/kong-plugin.git
    cd kong-plugin
```

Below commands needs to be running inside plugin folder

### Dependency defaults

Update `.pongo/pongorc` to disable cassandra if not required as a datastore (postgres is enabled by default)

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

## Add MyPlugin to the Service

```shell
http -f :8001/services/example-service/plugins name=myplugin
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
Content-Length: 556
Content-Type: application/json
Date: Wed, 30 Jun 2021 07:32:51 GMT
Server: gunicorn/19.9.0
Via: kong/2.4.1
X-Kong-Proxy-Latency: 140
X-Kong-Upstream-Latency: 568

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
        "X-Amzn-Trace-Id": "Root=1-60dc1e23-332e478c63f3ca0551ffb795",
        "X-Forwarded-Host": "localhost",
        "X-Forwarded-Path": "/echo/anything",
        "X-Forwarded-Prefix": "/echo"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 223.196.173.146",
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
cd kong-plugin
tail -f servroot/logs/error.log
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
