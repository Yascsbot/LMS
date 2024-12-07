const db = require("../dbConfig");

function getAllFines(req, res) {
  const query = `SELECT 
    F.FineID,
    M.MemberID,
    F.LoanID,
    F.FineAmount,
    F.PaymentDate,
    FS.FineStatus,
    M.Name AS MemberName,
    M.Email,
    M.PhoneNumber
FROM FINES F
JOIN FINE_STATUS FS ON F.FineID = FS.FineID
JOIN MEMBERS M ON F.MemberID = M.MemberID;`;

  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 8: Find the most popular books borrowed by members with outstanding fees
function getPopularBooksByFee(req, res) {
  const query = `
        SELECT B.Title AS BookTitle, COUNT(L.BookId) AS BorrowCount
        FROM BOOKS_DETAILS B
        JOIN BOOK_INVENTORY BI ON B.ISBN = BI.ISBN
        JOIN LOANS L ON BI.BookId = L.BookId
        WHERE L.MemberId IN (
          SELECT F.MemberId
          FROM FINES F
          JOIN FINE_STATUS FS ON F.FineId = FS.FineID
          WHERE FS.FineStatus = 'Unpaid'
        )
        GROUP BY L.BookId
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
