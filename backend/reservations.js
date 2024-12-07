const db = require("../dbConfig");
function getAllReservations(req, res) {
  // Extract the BookTitle parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
    SELECT 
    R.ReservationID,
    M.Name AS MemberName,
    BD.Title AS BookTitle,
    DATE_FORMAT(R.ReservationDate, '%m-%d-%Y') AS ReservationDate,
    R.Status
    FROM RESERVATIONS R
    JOIN MEMBERS M ON R.MemberID = M.MemberID
    JOIN BOOK_INVENTORY BI ON R.BookID = BI.BookID
    JOIN BOOKS_DETAILS BD ON BI.ISBN = BD.ISBN
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if BookTitle is provided
  if (Title) {
    query += `WHERE BD.Title LIKE ? `;
    params.push(`%${Title}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching reservations:", err);
      return res.status(500).json({ error: "Error fetching reservations" });
    }
    res.json(results);
  });
}

// Query 5: Find books that are currently reserved but have never been borrowed
function getReservedBooksNeverBorrowed(req, res) {
  // Extract the BookTitle parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
        SELECT BD.Title AS BookTitle
        FROM BOOKS_DETAILS BD
        JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
        JOIN RESERVATIONS R ON BI.BookID = R.BookID
        WHERE R.Status = 'Pending'
        AND BI.BookID IN (
            SELECT BookID
            FROM RESERVATIONS
            EXCEPT
            SELECT BookID
            FROM LOANS
        )
    `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if BookTitle is provided
  if (Title) {
    query += `AND BD.Title LIKE ? `;
    params.push(`%${Title}%`);
  }

  // Add ordering to the query
  query += `ORDER BY BD.Title ASC`;

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching reserved books that have never been borrowed:", err);
      return res.status(500).json({ error: "Error fetching reserved books that have never been borrowed" });
    }
    console.log("Query Results:", results);
    res.json(results);
  });
}

module.exports = {
  getAllReservations,
  getReservedBooksNeverBorrowed,
};
