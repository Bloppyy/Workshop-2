// src/controllers/inspections.controller.js
const inspectionsModel = require("../models/inspections.model");

// POST /api/inspections
async function createInspection(req, res, next) {
  try {
    const { vessel_id, inspector_id, inspection_date, remarks } = req.body;

    // Later: get inspector_id from logged-in user instead of body
    const inspection = await inspectionsModel.createInspection({
      vessel_id,
      inspector_id,
      inspection_date,
      remarks,
    });

    res.status(201).json(inspection);
  } catch (err) {
    next(err);
  }
}

// GET /api/inspections
async function listInspections(req, res, next) {
  try {
    const { status } = req.query;
    const inspections = await inspectionsModel.listInspections({ status });
    res.json(inspections);
  } catch (err) {
    next(err);
  }
}

// GET /api/inspections/:id
async function getInspection(req, res, next) {
  try {
    const { id } = req.params;
    const inspection = await inspectionsModel.getInspectionById(id);
    if (!inspection) {
      return res.status(404).json({ message: "Inspection not found" });
    }
    res.json(inspection);
  } catch (err) {
    next(err);
  }
}

// PATCH /api/inspections/:id
async function updateInspection(req, res, next) {
  try {
    const { id } = req.params;
    const fields = req.body; // e.g. { status: "submitted" }

    const updated = await inspectionsModel.updateInspection(id, fields);
    if (!updated) {
      return res.status(404).json({ message: "Inspection not found" });
    }
    res.json(updated);
  } catch (err) {
    next(err);
  }
}

// DELETE /api/inspections/:id
async function deleteInspection(req, res, next) {
  try {
    const { id } = req.params;
    await inspectionsModel.deleteInspection(id);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createInspection,
  listInspections,
  getInspection,
  updateInspection,
  deleteInspection,
};
