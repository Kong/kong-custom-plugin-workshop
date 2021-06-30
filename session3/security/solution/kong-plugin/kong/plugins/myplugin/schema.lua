local typedefs = require "kong.db.schema.typedefs"

-- Grab pluginname from module name
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
    name = plugin_name,
    fields = { -- the 'fields' array is the top-level entry with fields defined by Kong
    {
        consumer = typedefs.no_consumer
    }, -- this plugin cannot be configured on a consumer (typical for auth plugins)
    {
        protocols = typedefs.protocols_http
    }, {
        config = {
            -- The 'config' record is the custom part of the plugin schema
            type = "record",
            fields = {{
                authentication_url = { -- adding new field
                    type = "string",
                    required = true,
                    default = "http://auth-service:3000/auth/validate/token"
                }
            }, {
                authorization_url = { -- adding new field
                    type = "string",
                    required = true,
                    default = "http://auth-service:3000/auth/validate/customer"
                }
            }}
        }
    }}
}

return schema
