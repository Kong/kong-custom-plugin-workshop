## Navigate to the plugin directory


```shell
    cd kong-plugin
```

### Start dependencies

```shell
pongo up
```

### Run all tests

```shell
pongo run
KONG_VERSION=2.3.x pongo run
```

### Dependencies

Update `.pongo/pongorc` file inside plugin folder to disable cassandra

```shell
--no-cassandra
```

### Run a specific test:
```shell
KONG_VERSION=1.3.x pongo run -v -o gtest ./spec/myplugin/02-integration_spec.lua
```
