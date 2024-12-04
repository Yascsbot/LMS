const db = require("../dbConfig");

// Query 5: Find books that are currently reserved but have never been borrowed
function getReservedBooksNeverBorrowed(req, res) {
  const query = `
        SELECT B.Title AS BookTitle
        FROM BOOKS B
        JOIN RESERVATIONS R ON B.BookID = R.BookID
        WHERE R.Status = 'Pending'
        AND B.BookID IN (
            SELECT BookID
            FROM RESERVATIONS
            EXCEPT
            SELECT BookID
            FROM LOANS
        )
        ORDER BY B.Title ASC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getReservedBooksNeverBorrowed,
};
