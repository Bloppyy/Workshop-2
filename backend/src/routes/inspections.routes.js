// src/routes/inspections.routes.js
const express = require("express");
const router = express.Router();
const inspectionsController = require("../controllers/inspections.controller");

// Later: protect with auth middleware
router.post("/", inspectionsController.createInspection);
router.get("/", inspectionsController.listInspections);
router.get("/:id", inspectionsController.getInspection);
router.patch("/:id", inspectionsController.updateInspection);
router.delete("/:id", inspectionsController.deleteInspection);

module.exports = router;
