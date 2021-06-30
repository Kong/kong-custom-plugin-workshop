## Requirements

Tools Pongo needs to run:

- `docker-compose` (and hence `docker`)
- `curl`
- `realpath`, for MacOS you need the [`coreutils`](https://www.gnu.org/software/coreutils/coreutils.html)
  to be installed. This is easiest via the [Homebrew package manager](https://brew.sh/) by doing:
  ```
  brew install coreutils
  ```
- depending on your environment you should set some [environment variables](#configuration).

## Clone kong plugin template

```shell
    git clone https://github.com/Kong/kong-plugin
```

## Download and setup pongo from its Git Repo

```shell
    PATH=$PATH:~/.local/bin
    git clone https://github.com/Kong/kong-pongo.git
    mkdir -p ~/.local/bin
    ln -s $(realpath kong-pongo/pongo.sh) ~/.local/bin/pongo
```

## Environment variables:

```shell
KONG_VERSION the specific Kong version to use when building the test image
(note that the patch-version can be 'x' to use latest)

KONG_IMAGE the base Kong Docker image to use when building the test image

KONG_LICENSE_DATA
set this variable with the Kong Enterprise license data

POSTGRES the version of the Postgres dependency to use (default 9.5)
CASSANDRA the version of the Cassandra dependency to use (default 3.9)
REDIS the version of the Redis dependency to use (default 5.0.4)
```

### Example usage:

```shell
pongo run
KONG_VERSION=1.3.x pongo run -v -o gtest ./spec/02-access_spec.lua
POSTGRES=10 KONG_VERSION=2.3.x pongo run
pongo down
```

## Do a test run

```shell
    cd kong-plugin

    # auto pull and build the test images
    pongo run
```

Some more elaborate examples:

```shell
    # Run against a specific version of Kong and pass
    # a number of Busted options
    KONG_VERSION=2.3.2 pongo run -v -o gtest ./spec

    # Run against the latest patch version of a Kong release using '.x'
    KONG_VERSION=2.3.x pongo run -v -o gtest ./spec
```

The above command (pongo run) will automatically build the test image and start the test environment. When done, the test environment can be torn down by:

```shell
    pongo down
```

## Test dependencies

Pongo can use a set of test dependencies that can be used to test against. Each
can be enabled/disabled by respectively specifying `--[dependency_name]` or
`--no-[dependency-name]` as options for the `pongo up`, `pongo restart`, and
`pongo run` commands. The alternate way of specifying the dependencies is
by adding them to the `.pongo/pongorc` file (see below).

The available dependencies are:

- **Postgres** Kong datastore (started by default)

  - Disable it with `--no-postgres`
  - The Postgres version is controlled by the `POSTGRES` environment variable

- **Cassandra** Kong datastore (started by default)

  - Disable it with `--no-cassandra`
  - The Cassandra version is controlled by the `CASSANDRA` environment variable

- **grpcbin** mock grpc backend

  - Enable it with `--grpcbin`
  - The engine is [moul/grpcbin](https://github.com/moul/grpcbin)
  - From within the environment it is available at:
    - `grpcbin:9000` grpc over http
    - `grpcbin:9001` grpc over http+tls

- **Redis** key-value store

  - Enable it with `--redis`
  - The Redis version is controlled by the `REDIS` environment variable
  - From within the environment the Redis instance is available at `redis:6379`,
    but from the test specs it should be accessed by using the `helpers.redis_host`
    field, and port `6379`, to keep it portable to other test environments. Example:
    ```shell
    local helpers = require "spec.helpers"
    local redis_host = helpers.redis_host
    local redis_port = 6379
    ```

- **Squid** (forward-proxy)

  - Enable it with `--squid`
  - The Squid version is controlled by the `SQUID` environment variable
  - From within the environment the Squid instance is available at `squid:3128`.
    Essentially it would be configured as these standard environment variables:

    - `http_proxy=http://squid:3128/`
    - `https_proxy=http://squid:3128/`

    The configuration comes with basic-auth configuration, and a single user:

    - username: `kong`
    - password: `king`

    All access is to be authenticated by the proxy, except for the domain `.mockbin.org`,
    which is white-listed.

    Some test instructions to play with the proxy:

    ```shell
    # clean environment, start with squid and create a shell
    pongo down
    pongo up --squid --no-postgres --no-cassandra
    pongo shell

    # connect to httpbin (http), while authenticating
    http --proxy=http:http://kong:king@squid:3128 --proxy=https:http://kong:king@squid:3128 http://httpbin.org/anything

    # https also works
    http --proxy=http:http://kong:king@squid:3128 --proxy=https:http://kong:king@squid:3128 https://httpbin.org/anything

    # connect unauthenticated to the whitelisted mockbin.org (http)
    http --proxy=http:http://squid:3128 --proxy=https:http://squid:3128 http://mockbin.org/request

    # and here https also works
    http --proxy=http:http://squid:3128 --proxy=https:http://squid:3128 https://mockbin.org/request
    ```

### Dependency defaults

The defaults do not make sense for every type of plugin and some dependencies
(Cassandra for example) can slow down the tests. So to override the defaults on
a per project/plugin basis, a `.pongo/pongorc` file can be added
to the project.

The format of the file is very simple; each line contains 1 commandline option, eg.
a `.pongo/pongorc` file for a plugin that only needs Postgres and Redis:

```shell
--no-cassandra
--redis
```

### Dependency troubleshooting

When dependency containers are causing trouble, the logs can be accessed using
the `pongo logs` command. This command is the same as `docker-compose logs` except
that it operates on the Pongo environment specifically. Any additional options
specified to the command will be passed to the underlying `docker-compose logs`
command.

Some examples:

```shell
# show latest logs
pongo logs

# tail latest logs
pongo logs -f

# tail latest logs for the postgres dependency
pongo logs -f postgres
```

## Accessing logs

When running the tests, the Kong prefix (or working directory) will be set to ./servroot.

To track the error log (where any print or ngx.log statements will go) you can use the tail command

```shell
    pongo tail
```

## Direct access to service ports

To directly access Kong from the host, or the datastores, the pongo expose command can be used to expose the internal ports to the host.

This allows for example to connect to the Postgres on port 5432 to validate the contents of the database. Or when running pongo shell to manually start Kong, you can access all the regular Kong ports from the host, including the GUI's.

This has been implemented as a separate container that opens all those ports and relays them on the docker network to the actual service containers (the reason for this is that regular Pongo runs do not interfere with ports already in use on the host, only if expose is used there is a risk of failure because ports are already in use on the host)

Since it is technically a "dependency" it can be specified as a dependency as well.

so

```shell
    pongo up
    pongo expose
```

is equivalent to

```shell
    pongo up --expose
```

See pongo expose --help for the ports.

For latest information refer pango repo
https://github.com/Kong/kong-pongo/
