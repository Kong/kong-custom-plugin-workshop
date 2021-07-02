## Problem Statement

Custom Authentication Security Lab

Build a  custom plugin that reaches out to an external service for each call to the plugin. The URL for the external service should be provided as a plugin configuration

The external service for authentication will be provided as a docker container

The API caller will specify two parameters with the call
- A bearer token
- A customer ID
When starting the authentication service, you can specify a list of valid bearer tokens and customer IDs

The custom plugin will
- Call the /auth/validate/token endpoint to validate the bearer token supplied by the API caller (Authentication)
- Call the /auth/validate/customer endpoint to validate the customer ID supplied by the API caller (Authorization)

If both succeed, the request is considered authenticated and the plugin sends it to the upstream endpoint
If either fails, the plugin will terminate the request with an appropriate error

