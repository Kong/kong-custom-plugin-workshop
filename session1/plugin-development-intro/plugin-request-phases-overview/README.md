## Introduction

Prior to this exercise, it is assumed you have setup Pongo

Clone the Kong plugin template: https://github.com/Kong/kong-plugin.git

```shell
    git clone https://github.com/Kong/kong-plugin.git
    cd kong-plugin
```

## Bring up pongo dependencies

```shell
pongo up
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

You should see the sample headers added by the plugins to the HTTP request and response

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
