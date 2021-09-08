const plugin = require('./js-censor');

const {
  PluginTest,
  Request
} = require("kong-pdk/plugin_test")


test('Set headers in response', async () => {
  let r = new Request()

  r
    .useURL("http://example.com")
    .useMethod("GET")

  let t = new PluginTest(r)

  await t.Run(plugin, {}, "Sex Education")

  expect(t.response.status)
    .toBe(200)

  expect(t.response.body)
    .toBe(
      `Response body from upstream:
*** Education
Body size: 13
`)

})
