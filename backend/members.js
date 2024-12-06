const db = require("../dbConfig");

function getAllMembers(req, res) {
  const query = `SELECT 
        MemberID,
        Name,
        Email,
        PhoneNumber,
        Address,
        MembershipType,
        JoinDate
    FROM 
        Members;`;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 3: Retrieve names of members with overdue loans
function getOverdueMembers(req, res) {
  const query = `
        SELECT M.Name
        FROM MEMBERS AS M
        WHERE EXISTS (
            SELECT L.LoanID
            FROM LOANS AS L
            WHERE L.MemberID = M.MemberID
            AND L.DueDate < CURDATE()
            AND L.ReturnDate IS NULL
        );
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

// Query 6: Display the member with the highest fine amount
function getMemberWithHighestFine(req, res) {
  const query = `
        SELECT M.Name AS MemberName, SUM(F.FineAmount) AS TotalFineAmount
        FROM MEMBERS M
        JOIN FINES F ON M.MemberId = F.MemberId
        GROUP BY M.MemberId
        HAVING SUM(F.FineAmount) = (
            SELECT MAX(MemberTotalFine)
            FROM (
                SELECT MemberId, SUM(FineAmount) AS MemberTotalFine
                FROM FINES
                GROUP BY MemberId
            ) AS FineTotals
        );
    `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
}

module.exports = {
  getAllMembers,
  getOverdueMembers,
  getMemberWithHighestFine,
};
