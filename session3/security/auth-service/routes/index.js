const express = require("express");
const router = express.Router();

const config = require("../config");

/* token validation. */
router.get("/token", function(req, res, next) {
  const token = req.headers.authorization.replace(/^ *bearer */i, "").trim();

  if (config.tokens.includes(token)) {
    res.status(200).send();
  } else {
    res.status(403).send();
  }
});

/* customer validation. */
router.get("/customer", function(req, res, next) {
  const customerId = req.query.custId;

  if (config.customers.includes(customerId)) {
    res.status(200).send();
  } else {
    res.status(403).send();
  }
});

module.exports = router;
