'use strict';

let proc = require("process")
let tc = require("text-censor")

// This is an example plugin that appends a string in response body

class KongPlugin {
  constructor(config) {
    this.config = config
  }

  async access(kong) {

  }

  async response(kong) {
    if (await kong.response.getSource() == "service") {
      function asyncFilter(requestBody, time) {
        return new Promise(resolve => {
            setTimeout(() => resolve(tc.filter(requestBody)), time);
        });
      }
      let body = await kong.service.response.getRawBody()
      body = await asyncFilter(JSON.stringify(body), 500);
      body = JSON.parse(body);
      console.log(body);
      body = "Response body from upstream:\n" + body + "\nBody size: " + body.length + "\n"

      await kong.response.exit(await kong.response.getStatus(), body)
    }
  }
}

module.exports = {
  Plugin: KongPlugin,
  Schema: [{
    message: {
      type: "string"
    }
  }, ],
  Version: '0.1.0',
  Priority: 0,
}
