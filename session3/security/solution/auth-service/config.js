const defaultTokens = ["a", "b"];
const defaultCustomers = ["a", "b"];

module.exports = {
  tokens: process.env.TOKENS ? process.env.TOKENS.split(",").map((s) => s.trim()) : defaultTokens,
  customers: process.env.CUSTOMERS ? process.env.CUSTOMERS.split(",").map((s) => s.trim()) : defaultCustomers,
};