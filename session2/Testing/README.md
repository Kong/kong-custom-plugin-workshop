## Introduction

Start Kong and Database containers using docker-compose, before docker-compose up, we need to run database migrations

```shell
    set -a; source .env; set +a
    cd kong-plugin && pongo run -v -o gtest ./spec/myplugin/01-unit_spec.lua
```
