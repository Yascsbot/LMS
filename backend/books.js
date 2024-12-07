const db = require("../dbConfig");

// Get all books or filter by Title
function getAllbooks(req, res) {
  // Extract the Title parameter from the query
  const { Title } = req.query;

  // Base query
  let query = `
    SELECT 
        ISBN,
        Title,
        Author,
        Genre,
        DATE_FORMAT(PublicationDate, '%m-%d-%Y') AS PublicationDate,
        AvailableCopies,
        TotalCopies
    FROM BOOK_DETAILS
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
            BD.Title, 
            BD.Author, 
            M.Name AS MemberName,  
            DATE_FORMAT(L.LoanDate, '%m-%d-%Y') AS LoanDate,  
            DATE_FORMAT(L.ReturnDate, '%m-%d-%Y') AS ReturnDate
        FROM LOANS L
        JOIN BOOK_INVENTORY BI ON L.BookID = BI.BookID
        JOIN BOOKS_DETAILS BD ON BI.ISBN = BD.ISBN
        JOIN MEMBERS M ON L.MemberID = M.MemberID
    `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Title is provided
  if (Title) {
    query += `WHERE BD.Title LIKE ? `;
    params.push(`%${Title}%`);
  }

  // Add ordering logic
  query += `ORDER BY BD.Title ASC, L.LoanDate ASC;`;

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
  const { Title } = req.query;

  const query = `
    SELECT 
        B.Title, 
        IFNULL(R.Status, 'No Reservation') AS ReservationStatus
    FROM BOOKS_DETAILS BD
    LEFT JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
    LEFT JOIN RESERVATIONS R ON BI.BookID = R.BookID
    WHERE (? IS NULL OR B.Title LIKE CONCAT('%', ?, '%'))
    ORDER BY ReservationStatus ASC
  `;

  const params = [Title || null, Title || null];

  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching books with reservation status:", err);
      return res.status(500).json({ error: "Error fetching books with reservation status" });
    }

    res.json(results);
  });
}



module.exports = {
  getAllbooks,
  getBorrowedBooks,
  getBooksWithReservationStatus,
};
