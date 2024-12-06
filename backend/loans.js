const db = require("../dbConfig");

function getAllLoans(req, res) {
  const query = `SELECT 
        L.LoanID,
        L.BookID,
        B.Title AS BookTitle,
        L.MemberID,
        M.Name AS MemberName,
        DATE_FORMAT( L.LoanDate, '%m-%d-%Y') AS LoanDate,
        DATE_FORMAT( L.DueDate, '%m-%d-%Y') AS DueDate,
        DATE_FORMAT( L.ReturnDate, '%m-%d-%Y') AS ReturnDate
    FROM 
        Loans L
    JOIN 
        Books B ON L.BookID = B.BookID
    JOIN 
        Members M ON L.MemberID = M.MemberID;
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
        FROM MEMBERS M, LOANS L, BOOKS B
        WHERE M.MemberId = L.MemberId
          AND L.BookId = B.BookId
          AND L.LoanDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
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
        FROM BOOKS B, LOANS L, MEMBERS M, STAFF S
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
