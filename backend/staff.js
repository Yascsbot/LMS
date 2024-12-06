const db = require("../dbConfig");
function getAllStaff(req, res) {
  const query = `
       SELECT 
        StaffID,
        Name,
        Email,
        Role,
        Username
    FROM 
        Staff;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getAllStaff,
};
