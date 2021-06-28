local clear_header = kong.service.request.clear_header
local get_headers = kong.request.get_headers


local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1",
}

-- runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)

  -- Remove header(s)
  local headers = get_headers()

  for _, name in pairs(plugin_conf.remove_request_headers) do
    name = name:lower()
    if headers[name] then
      headers[name] = nil
      clear_header(name)
    end
  end

end


-- return our plugin object
return plugin
