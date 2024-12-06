const db = require("../dbConfig");

// Get all books or filter by Title
function getAllbooks(req, res) {
  // Extract the Title parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
    SELECT 
        BookID,
        Title,
        Author,
        ISBN,
        Genre,
        DATE_FORMAT(PublicationDate, '%m-%d-%Y') AS PublicationDate,
        AvailableCopies,
        TotalCopies
    FROM Books
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Title is provided
  if (Title) {
    query += `WHERE Title LIKE ? `;
    params.push(`%${Title}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching books:", err);
      return res.status(500).json({ error: "Error fetching books" });
    }

    // Return the results as JSON
    res.json(results);
  });
}

// Retrieve titles and authors of books borrowed with member info
function getBorrowedBooks(req, res) {
  // Extract the Title parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
        SELECT 
            BOOKS.Title, 
            BOOKS.Author, 
            MEMBERS.Name AS MemberName,  
            DATE_FORMAT(LOANS.LoanDate, '%m-%d-%Y') AS LoanDate,  
            DATE_FORMAT(LOANS.ReturnDate, '%m-%d-%Y') AS ReturnDate
        FROM LOANS
        JOIN BOOKS ON LOANS.BookID = BOOKS.BookID
        JOIN MEMBERS ON LOANS.MemberID = MEMBERS.MemberID
    `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Title is provided
  if (Title) {
    query += `WHERE BOOKS.Title LIKE ? `;
    params.push(`%${Title}%`);
  }

  // Add ordering logic
  query += `ORDER BY BOOKS.Title ASC, LOANS.LoanDate ASC;`;

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching borrowed books:", err);
      return res.status(500).json({ error: "Error fetching borrowed books" });
    }

    // Return the results as JSON
    res.json(results);
  });
}

// Query 4: List all books with their reservation status
function getBooksWithReservationStatus(req, res) {
  // Extract the Title parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
    SELECT B.Title, R.Status AS ReservationStatus
    FROM BOOKS B
    LEFT JOIN RESERVATIONS R ON B.BookID = R.BookID
    UNION
    SELECT B.Title, R.Status AS ReservationStatus
    FROM BOOKS B
    RIGHT JOIN RESERVATIONS R ON B.BookID = R.BookID
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Title is provided
  if (Title) {
    query = `
      SELECT B.Title, R.Status AS ReservationStatus
      FROM BOOKS B
      LEFT JOIN RESERVATIONS R ON B.BookID = R.BookID
      WHERE B.Title LIKE ? 
      UNION
      SELECT B.Title, R.Status AS ReservationStatus
      FROM BOOKS B
      RIGHT JOIN RESERVATIONS R ON B.BookID = R.BookID
      WHERE B.Title LIKE ?
    `;
    params.push(`%${Title}%`, `%${Title}%`);
  }

  // Add ordering logic
  query += `ORDER BY ReservationStatus ASC;`;

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching books with reservation status:", err);
      return res.status(500).json({ error: "Error fetching books with reservation status" });
    }

    // Return the results as JSON
    res.json(results);
  });
}


module.exports = {
  getAllbooks,
  getBorrowedBooks,
  getBooksWithReservationStatus,
};
