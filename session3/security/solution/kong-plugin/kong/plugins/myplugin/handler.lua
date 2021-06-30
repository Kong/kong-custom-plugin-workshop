local http = require "resty.http"

local plugin = {
    PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
    VERSION = "0.1"
}

function plugin:access(plugin_conf)

    local client = http:new()

    local res, err = client:request_uri(plugin_conf.authentication_url, {
        headers = {
            ["Authorization"] = kong.request.get_header('authorization')
        }
    })

    if not res or res.status ~= 200 then
        kong.log.err("request failed: ", err)
        return kong.response.exit(403, "Authentication Failed")
    end

    kong.log.info("query params", kong.request.get_query()['custId'])

    local res, err = client:request_uri(plugin_conf.authorization_url, {
        query = kong.request.get_query(),
        headers = {
            ["Authorization"] = kong.request.get_header('authorization')
        }
    })

    if not res or res.status ~= 200 then
        kong.log.err("request failed: ", err)
        return kong.response.exit(403, "Authorization Failed")
    end

end

return plugin
