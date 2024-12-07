const db = require("../dbConfig");
function getAllReservations(req, res) {
  const query = `
    SELECT 
    R.ReservationID,
    M.Name AS MemberName,
    B.Title AS BookTitle,
    DATE_FORMAT(R.ReservationDate, '%m-%d-%Y') AS ReservationDate,
    R.Status
FROM Reservations R
JOIN Members M ON R.MemberID = M.MemberID
JOIN Books B ON R.BookID = B.BookID;
`;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 5: Find books that are currently reserved but have never been borrowed
function getReservedBooksNeverBorrowed(req, res) {
  const query = `
        SELECT B.Title AS BookTitle
        FROM BOOKS B
        JOIN RESERVATIONS R ON B.BookID = R.BookID
        WHERE R.Status = 'Pending'
        AND B.BookID IN (
            SELECT BookID
            FROM RESERVATIONS
            EXCEPT
            SELECT BookID
            FROM LOANS
        )
        ORDER BY B.Title ASC;
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
