module.exports = {
  tokens: process.env.TOKENS.split(",").map((s) => s.trim()) || ["a", "b"],
  customers: process.env.CUSTOMERS.split(",").map((s) => s.trim()) || [
    "a",
    "b",
  ],
};
