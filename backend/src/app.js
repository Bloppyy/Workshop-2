// src/app.js
const express = require("express");
const cors = require("cors");
require("dotenv").config();
const { query } = require("./db");
const inspectionsRoutes = require("./routes/inspections.routes");

const app = express();

// Middleware: runs for every request
app.use(cors());
app.use(express.json());

// Simple health check route
app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});
app.get("/db-test", async (req, res) => {
  try {
    const result = await query("SELECT NOW()");
    res.json({ dbTime: result.rows[0].now });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Database connection failed" });
  }
});
app.use("/api/inspections", inspectionsRoutes);

module.exports = app;
