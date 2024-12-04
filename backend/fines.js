const db = require("../dbConfig");

// Query 8: Find the most popular books borrowed by members with outstanding fees
function getPopularBooksByFee(req, res) {
  const query = `
        SELECT B.Title AS BookTitle, COUNT(L.BookId) AS BorrowCount
        FROM BOOKS B, LOANS L
        WHERE B.BookId = L.BookId
          AND L.MemberId IN (
              SELECT F.MemberId
              FROM FINES F
              WHERE F.FineStatus = 'Unpaid'
          )
        GROUP BY B.BookId
        ORDER BY BorrowCount DESC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getPopularBooksByFee,
};
