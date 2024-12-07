const db = require("../dbConfig");

function getAllLoans(req, res) {
  const { Name } = req.query; // Extract Name parameter from the query
  let query = `SELECT 
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

  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `WHERE M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching loans:", err);
      return res.status(500).json({ error: "Error fetching loans" });
    }
    res.json(results);
  });
}


function getRecentLoans(req, res) {
  const { Name } = req.query; // Extract Name parameter from the query
  let query = `
        SELECT M.Name AS MemberName, B.Title AS BookTitle
        FROM MEMBERS M
        JOIN LOANS L ON M.MemberId = L.MemberId
        JOIN BOOK_INVENTORY BI ON L.BookID = BI.BookID
        JOIN BOOKS_DETAILS B ON BI.ISBN = B.ISBN
        WHERE L.LoanDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    `;

  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `AND M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching recent loans:", err);
      return res.status(500).json({ error: "Error fetching recent loans" });
    }
    res.json(results);
  });
}

// Query 9: Retrieve details of overdue loans with member and staff information
function getOverdueLoanDetails(req, res) {
  const { Name } = req.query; // Extract Name parameter from the query
  let query = `
        SELECT B.Title AS BookTitle, B.Author AS Author,
               M.Name AS MemberName,
               S.Name AS StaffName, S.Role AS StaffRole
        FROM BOOKS_DETAILS B
        JOIN BOOK_INVENTORY BI ON B.ISBN = BI.ISBN
        JOIN LOANS L ON BI.BookId = L.BookId
        JOIN MEMBERS M ON L.MemberId = M.MemberId
        JOIN STAFF S ON L.StaffId = S.StaffId
        WHERE BI.BookId = L.BookId
          AND L.MemberId = M.MemberId
          AND L.StaffId = S.StaffId
          AND L.DueDate < CURRENT_DATE
          AND L.ReturnDate IS NULL 
    `;

  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `AND M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  query += `
        ORDER BY L.DueDate ASC;
    `;

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching overdue loan details:", err);
      return res.status(500).json({ error: "Error fetching overdue loan details" });
    }
    res.json(results);
  });
}


module.exports = {
  getAllLoans,
  getRecentLoans,
  getOverdueLoanDetails,
};
