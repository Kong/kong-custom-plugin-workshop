## Introduction

Prior to this exercise, it is assumed you have setup Pongo

Clone the Kong plugin template: https://github.com/Kong/kong-plugin.git

```shell
    git clone https://github.com/Kong/kong-plugin.git
    cd kong-plugin
```

## bring up pongo dependencies

```shell
pongo up
```

## expose services

```shell
pongo expose
```

## create a Kong container and attach a shell

```shell
pongo shell
```

The following commands should be run from within the Kong shell

## boostrap the database

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

### Test 2

Enable plugin: Remove Accept-Encoding Header

```shell
    http :8001/services/example-service/plugins
    http DELETE :8001/services/example-service/plugins/<plugin-id>
    http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept-encoding
    http :8000/echo/anything

```

### Test 3

Enable plugin: Remove Both Accept and Accept-Encoding Header

```shell
    http :8001/services/example-service/plugins
    http DELETE :8001/services/example-service/plugins/<plugin-id>
    http -f :8001/services/example-service/plugins name=myplugin config.remove_request_headers=accept config.remove_request_headers=accept-encoding
    http :8000/echo/anything

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
