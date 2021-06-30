local helpers = require "spec.helpers"

local PLUGIN_NAME = "myplugin"

local strategy = "postgres"

describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client
    local admin_client

    lazy_setup(function()

        local bp = helpers.get_db_utils(strategy == "off" and "postgres" or strategy, nil, {PLUGIN_NAME})

        -- Inject a test route. No need to create a service, there is a default
        -- service which will echo the request.
        local route1 = bp.routes:insert({
            hosts = {"test1.com"},
            paths = {"/success"}
        })

        local route2 = bp.routes:insert({
            hosts = {"test1.com"},
            paths = {"/authentication-failed"}
        })

        local route3 = bp.routes:insert({
            hosts = {"test1.com"},
            paths = {"/authorization-failed"}
        })

        bp.plugins:insert{
            name = PLUGIN_NAME,
            route = {
                id = route1.id
            },
            config = {
                authentication_url = "http://httpbin.org/status/200",
                authorization_url = "http://httpbin.org/status/200"
            }
        }

        bp.plugins:insert{
            name = PLUGIN_NAME,
            route = {
                id = route2.id
            },
            config = {
                authentication_url = "http://httpbin.org/status/403",
                authorization_url = "http://httpbin.org/status/200"
            }
        }

        bp.plugins:insert{
            name = PLUGIN_NAME,
            route = {
                id = route3.id
            },
            config = {
                authentication_url = "http://httpbin.org/status/200",
                authorization_url = "http://httpbin.org/status/403"
            }
        }

        -- start kong
        assert(helpers.start_kong({
            -- set the strategy
            database = strategy,
            -- use the custom test template to create a local mock server
            nginx_conf = "spec/fixtures/custom_nginx.template",
            -- make sure our plugin gets loaded
            plugins = "bundled," .. PLUGIN_NAME,
            -- write & load declarative config, only if 'strategy=off'
            declarative_config = strategy == "off" and helpers.make_yaml_file() or nil
        }))

        admin_client = helpers.admin_client()
    end)

    lazy_teardown(function()
        if admin_client then
            admin_client:close()
        end
        helpers.stop_kong(nil, true)
    end)

    before_each(function()
        client = helpers.proxy_client()
    end)

    after_each(function()
        if client then
            client:close()
        end
    end)

    describe("Happy Path", function()
        it("authentication and authorization", function()
            -- add the plugin to test to the route we created
            local r = client:get("/success", {
                headers = {
                    host = "test1.com"
                }
            })
            -- validate that the request succeeded, response status 200
            assert.response(r).has.status(200)
        end)
    end)

    describe("Failure Scenarios", function()
        it("Authentication failed", function()

            local r = client:get("/authentication-failed", {
                headers = {
                    host = "test1.com"
                }
            })
            assert.response(r).has.status(403)
            local body, err = r:read_body()
            assert.equal("Authentication Failed", body)
        end)

        it("Authorization failed", function()

            local r = client:get("/authorization-failed", {
                headers = {
                    host = "test1.com"
                }
            })
            assert.response(r).has.status(403)
            local body, err = r:read_body()
            assert.equal("Authorization Failed", body)
        end)
    end)

end)
