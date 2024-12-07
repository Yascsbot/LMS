const db = require("../dbConfig");

function getAllFines(req, res) {
  const query = `SELECT 
    F.FineID,
    F.LoanID,
    F.FineAmount,
    F.FineStatus,
    DATE_FORMAT(F.PaymentDate, '%m-%d-%Y') AS PaymentDate,
    M.MemberID,
    M.Name AS MemberName,
    M.Email,
     CONCAT(
            SUBSTRING(M.PhoneNumber, 1, 3), '-', 
            SUBSTRING(M.PhoneNumber, 4, 3), '-', 
            SUBSTRING(M.PhoneNumber, 7, 4)
        ) AS PhoneNumber
FROM Fines F
JOIN Members M ON F.MemberID = M.MemberID;`;

  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
}
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
  getAllFines,
  getPopularBooksByFee,
};
