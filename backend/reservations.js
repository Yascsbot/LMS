const db = require("../dbConfig");
function getAllReservations(req, res) {
  const query = `
    SELECT 
    R.ReservationID,
    M.Name AS MemberName,
    BD.Title AS BookTitle,
    DATE_FORMAT(R.ReservationDate, '%m-%d-%Y') AS ReservationDate,
    R.Status
FROM RESERVATIONS R
JOIN MEMBERS M ON R.MemberID = M.MemberID
JOIN BOOK_INVENTORY BI ON R.BookID = BI.BookID
JOIN BOOKS_DETAILS BD ON BI.ISBN = BD.ISBN;
`;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 5: Find books that are currently reserved but have never been borrowed
function getReservedBooksNeverBorrowed(req, res) {
  const query = `
        SELECT BD.Title AS BookTitle
        FROM BOOKS_DETAILS BD
        JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
        JOIN RESERVATIONS R ON BI.BookID = R.BookID
        WHERE R.Status = 'Pending'
        AND B.BookID IN (
            SELECT BookID
            FROM RESERVATIONS
            EXCEPT
            SELECT BookID
            FROM LOANS
        )
        ORDER BY BD.Title ASC;
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getAllReservations,
  getReservedBooksNeverBorrowed,
};
