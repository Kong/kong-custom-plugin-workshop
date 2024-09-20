## Problem Statement

1. Clone kong plugin template `git clone https://github.com/Kong/kong-plugin`
2. Update the template to add a plugin configuration field to remove request headers from the API request before sending it to the upstream
3. The plugin configuration should specify a list of headers to be removed
4. Update the plugin code to use the added configuration field(s) and validate the plugin behavior