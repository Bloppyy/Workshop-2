// src/db.js
const { Pool } = require("pg");
require("dotenv").config();

// Create a connection pool using DATABASE_URL from .env
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Helper function for running queries
const query = (text, params) => {
  return pool.query(text, params);
};

module.exports = {
  pool,
  query,
};

