## Navigate to the plugin directory


```shell
    cd kong-plugin
```

### Run all tests

```shell
pongo run
KONG_VERSION=2.3.x pongo run
```

### Run a specific test:
```shell
KONG_VERSION=1.3.x pongo run -v -o gtest ./spec/02-access_spec.lua
```
