## Navigate to the plugin directory
If you have a license file `license.json` and you want to use enterprise image, store the licence to environment variable with below command.

```bash
export KONG_LICENSE_DATA=$(cat license.json)
```

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
KONG_VERSION=3.4.x pongo run
```

### Run a specific test:
```shell
KONG_VERSION=3.4.x pongo run -v -o gtest ./spec/myplugin/02-integration_spec.lua
```

### Clean up

```bash
pongo down
```