// src/models/inspections.model.js
const { query } = require("../db");

// Create a new inspection
async function createInspection({ vessel_id, inspector_id, inspection_date, remarks }) {
  const result = await query(
    `
    INSERT INTO inspections (vessel_id, inspector_id, status, inspection_date, remarks)
    VALUES ($1, $2, 'draft', $3, $4)
    RETURNING *;
    `,
    [vessel_id, inspector_id, inspection_date, remarks]
  );
  return result.rows[0];
}

// List inspections (optionally filter by status)
async function listInspections({ status }) {
  let sql = "SELECT * FROM inspections";
  const params = [];

  if (status) {
    sql += " WHERE status = $1";
    params.push(status);
  }

  sql += " ORDER BY created_at DESC";

  const result = await query(sql, params);
  return result.rows;
}

// Get single inspection by id (with vessel info)
async function getInspectionById(id) {
  const result = await query(
    `
    SELECT i.*,
           v.tag_no AS vessel_tag_no,
           v.description AS vessel_description
    FROM inspections i
    LEFT JOIN vessels v ON i.vessel_id = v.vessel_id
    WHERE i.inspection_id = $1;
    `,
    [id]
  );
  return result.rows[0];
}

// Update inspection (status, remarks, reviewer_id, etc.)
async function updateInspection(id, fields) {
  const columns = [];
  const values = [];
  let idx = 1;

  for (const [key, value] of Object.entries(fields)) {
    columns.push(`${key} = $${idx}`);
    values.push(value);
    idx++;
  }

  if (columns.length === 0) return getInspectionById(id);

  const sql = `
    UPDATE inspections
    SET ${columns.join(", ")}
    WHERE inspection_id = $${idx}
    RETURNING *;
  `;

  values.push(id);

  const result = await query(sql, values);
  return result.rows[0];
}

// Delete inspection
async function deleteInspection(id) {
  await query("DELETE FROM inspections WHERE inspection_id = $1", [id]);
  return true;
}

module.exports = {
  createInspection,
  listInspections,
  getInspectionById,
  updateInspection,
  deleteInspection,
};