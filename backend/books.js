const db = require("../dbConfig");
//get all books
function getAllbooks(req, res) {
  const query = `
   SELECT BookID,
        Title,
        Author,
        ISBN,
        Genre,
        PublicationDate,
        AvailableCopies,
        TotalCopies
    FROM Books;
        `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Retrieve titles and authors of books borrowed with member info
function getBorrowedBooks(req, res) {
  const query = `
        SELECT BOOKS.Title, BOOKS.Author, MEMBERS.Name AS MemberName, LOANS.LoanDate, LOANS.ReturnDate
        FROM LOANS
        JOIN BOOKS ON LOANS.BookID = BOOKS.BookID
        JOIN MEMBERS ON LOANS.MemberID = MEMBERS.MemberID
        ORDER BY BOOKS.Title ASC, LOANS.LoanDate ASC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 4: List all books with their reservation status
function getBooksWithReservationStatus(req, res) {
  const query = `
        SELECT B.Title, R.Status AS ReservationStatus
        FROM BOOKS B
        LEFT JOIN RESERVATIONS R ON B.BookID = R.BookID
        UNION
        SELECT B.Title, R.Status AS ReservationStatus
        FROM BOOKS B
        RIGHT JOIN RESERVATIONS R ON B.BookID = R.BookID
        ORDER BY ReservationStatus ASC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getAllbooks,
  getBorrowedBooks,
  getBooksWithReservationStatus,
};
