local PLUGIN_NAME = "myplugin"

-- helper function to validate data against a schema
local validate
do
    local validate_entity = require("spec.helpers").validate_plugin_config_schema
    local plugin_schema = require("kong.plugins." .. PLUGIN_NAME .. ".schema")

    function validate(data)
        return validate_entity(data, plugin_schema)
    end
end

describe(PLUGIN_NAME .. ": (schema)", function()

    it("accepts authentication and authorization url", function()
        local ok, err = validate({
            authentication_url = "http://httpbin.org/status/200",
            authorization_url = "http://httpbin.org/status/403"
        })
        assert.is_nil(err)
        assert.is_truthy(ok)
    end)

end)
