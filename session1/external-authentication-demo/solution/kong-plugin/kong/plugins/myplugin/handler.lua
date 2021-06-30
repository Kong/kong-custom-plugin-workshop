local http = require "resty.http"

local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1",
}

function plugin:access(plugin_conf)

  kong.service.request.set_header(plugin_conf.request_header, "this is on a request")
  local client = http:new() 

  local res, err = client:request_uri(plugin_conf.authentication_url)
  if not res or res.status ~= 200 then
    kong.log.err("Authentication Request failed: ", err)
    return kong.response.exit(403, "Authentication Failed")
  end

end

return plugin
