local PLUGIN_NAME = "myplugin"


-- helper function to validate data against a schema
local validate do
  local validate_entity = require("spec.helpers").validate_plugin_config_schema
  local plugin_schema = require("kong.plugins."..PLUGIN_NAME..".schema")

  function validate(data)
    return validate_entity(data, plugin_schema)
  end
end


describe(PLUGIN_NAME .. ": (schema)", function()


  it("accepts distinct request_header and response_header", function()
    local ok, err = validate({
        request_header = "My-Request-Header",
        response_header = "Your-Response",
      })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)


  it("does not accept identical request_header and response_header", function()
    local ok, err = validate({
        request_header = "they-are-the-same",
        response_header = "they-are-the-same",
      })

    assert.is_same({
      ["config"] = {
        ["@entity"] = {
          [1] = "values of these fields must be distinct: 'request_header', 'response_header'"
        }
      }
    }, err)
    assert.is_falsy(ok)
  end)

  it("valid value for remove_request_headers", function()
    local ok, err = validate({
        remove_request_headers = {"valid-header"},
      })

    assert.is_nil(err)
    assert.is_truthy(ok)
  end)


  it("does not accept invalid value for remove_request_headers", function()
    local ok, err = validate({
        remove_request_headers = {"they-@-#"},
      })

    assert.is_same({
      ["config"] = {
        ["remove_request_headers"] = {
          [1] = "bad header name 'they-@-#', allowed characters are A-Z, a-z, 0-9, '_', and '-'"
        }
      }
    }, err)
    assert.is_falsy(ok)
  end)


end)
