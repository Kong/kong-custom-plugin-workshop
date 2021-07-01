## Problem Statement

Build a custom plugin that reaches out to an external service for each API call to the plugin
The external service URL is provided as a plugin configuration
- If the external service returns a 200OK, the plugin allows the request to go through to the upstream
- If not, the plugin returns a 403 to the API caller

