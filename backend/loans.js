const db = require("../dbConfig");

function getAllLoans(req, res) {
  const query = `SELECT 
        L.LoanID,
        L.BookID,
        B.Title AS BookTitle,
        L.MemberID,
        M.Name AS MemberName,
        DATE_FORMAT(L.LoanDate, '%m-%d-%Y') AS LoanDate,
        DATE_FORMAT(L.DueDate, '%m-%d-%Y') AS DueDate,
        DATE_FORMAT(L.ReturnDate, '%m-%d-%Y') AS ReturnDate
    FROM 
        LOANS L
    JOIN 
        BOOK_INVENTORY BI ON L.BookID = BI.BookID
    JOIN
        BOOKS_DETAILS B ON BI.ISBN = B.ISBN
    JOIN 
        Members M ON L.MemberID = M.MemberID
        `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 7: Find titles of books borrowed by members within the last 30 days
function getRecentLoans(req, res) {
  const query = `
        SELECT M.Name AS MemberName, B.Title AS BookTitle
        FROM MEMBERS M
        JOIN LOANS L ON M.MemberId = L.MemberId
        JOIN BOOK_INVENTORY BI ON L.BookID = BI.BookID
        JOIN BOOKS_DETAILS B ON BI.ISBN = B.ISBN
        WHERE L.LoanDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 9: Retrieve details of overdue loans with member and staff information
function getOverdueLoanDetails(req, res) {
  const query = `
        SELECT B.Title AS BookTitle, B.Author AS Author,
               M.Name AS MemberName,
               S.Name AS StaffName, S.Role AS StaffRole
        FROM BOOKS_DETAILS B
        JOIN BOOK_INVENTORY BI ON B.ISBN = BI.ISBN
        JOIN LOANS L ON BI.BookId = L.BookId
        JOIN MEMBERS M ON L.MemberId = M.MemberId
        JOIN STAFF S ON L.StaffId = S.StaffId
        WHERE B.BookId = L.BookId
          AND L.MemberId = M.MemberId
          AND L.StaffId = S.StaffId
          AND L.DueDate < CURRENT_DATE
        ORDER BY L.DueDate ASC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getAllLoans,
  getRecentLoans,
  getOverdueLoanDetails,
};
