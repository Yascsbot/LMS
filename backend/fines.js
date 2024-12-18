const db = require("../dbConfig");

function getAllFines(req, res) {
  // Extract the Name parameter from the query
  const { Name } = req.query;

  // Base query
  let query = `
    SELECT 
      F.FineID,
      M.MemberID,
      F.LoanID,
      F.FineAmount,
      DATE_FORMAT(F.PaymentDate, '%m-%d-%Y') AS PaymentDate,
      FS.FineStatus,
      M.Name AS MemberName,
      M.Email,
      CONCAT(
        SUBSTRING(M.PhoneNumber, 1, 3), '-', 
        SUBSTRING(M.PhoneNumber, 4, 3), '-', 
        SUBSTRING(M.PhoneNumber, 7, 4)
      ) AS PhoneNumber
    FROM FINES F
    JOIN FINE_STATUS FS ON F.FineID = FS.FineID
    JOIN MEMBERS M ON F.MemberID = M.MemberID
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `WHERE M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching fines:", err);
      return res.status(500).json({ error: "Error fetching fines" });
    }
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
