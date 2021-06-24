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
