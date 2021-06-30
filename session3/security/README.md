## Problem Statement

Custom Authentication Security Lab

- Build a sample auth service and make it available on GitHub to download
- Auth service will expose 2 endpoints

  - first endpoint /auth/validate/token Authorization:'Bearer XXXXX') will validate the JWT token passed on the header as Authorization. The auth service should allow specifying what is allowed and what is not via configuration when starting it up
  - second endpoint will validate custId query parameter (/auth/validate/customer Authorization:'Bearer XXXXX' custId="<name>")- The auth service should allow specifying what is allowed and what is not via configuration when starting it up

- The API caller will send a request to Kong, passing a token and specifying a customerID as a query string param.

The custom plugin will intercept these, issue calls to the external auth service (2 endpoints) and both authenticate and authorize the caller - first call to authenticate, second call to authorize
