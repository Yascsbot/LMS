const db = require("../dbConfig");


function getAllMembers(req, res) {
  // Extract the Name parameter from the query
  const { Name } = req.query;
  let query = `SELECT 
        MemberID,
        Name,
        Email,
        CONCAT(
            SUBSTRING(PhoneNumber, 1, 3), '-', 
            SUBSTRING(PhoneNumber, 4, 3), '-', 
            SUBSTRING(PhoneNumber, 7, 4)
        ) AS PhoneNumber, 
        Address,
        MembershipType,
        DATE_FORMAT(JoinDate, '%m-%d-%Y') AS JoinDate
    FROM 
        Members `; // Note the space after "Members"

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `WHERE Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching members:", err);
      return res.status(500).json({ error: "Error fetching members" });
    }

    // Return the results as JSON
    res.json(results);
  });
}

// Query 3: Retrieve names of members with overdue loans and optional filtering by Name
function getOverdueMembers(req, res) {
  // Extract the Name parameter from the query
  const { Name } = req.query;

  // Base query
  let query = `
    SELECT M.Name
    FROM MEMBERS AS M
    WHERE EXISTS (
        SELECT L.LoanID
        FROM LOANS AS L
        WHERE L.MemberID = M.MemberID
        AND L.DueDate < CURDATE()
        AND L.ReturnDate IS NULL
    )
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Name is provided as part of the where clause
  if (Name) {
    query += `AND M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching overdue members:", err);
      return res.status(500).json({ error: "Error fetching overdue members" });
    }

    // Return the results as JSON
    res.json(results);
  });
}

// Query 6: Display the member with the highest fine amount with optional Name filtering
function getMemberWithHighestFine(req, res) {
  // Extract the Name parameter from the query
  const { Name } = req.query;

  // Base query
  let query = `
        SELECT M.Name AS MemberName, SUM(F.FineAmount) AS TotalFineAmount
        FROM MEMBERS M
        JOIN FINES F ON M.MemberId = F.MemberId
  `;

  // Array to hold query parameters
  const params = [];

  // Add filtering condition if Name is provided
  if (Name) {
    query += `WHERE M.Name LIKE ? `;
    params.push(`%${Name}%`);
  }

  // Add grouping and HAVING clause
  query += `
        GROUP BY M.MemberId
        HAVING SUM(F.FineAmount) = (
            SELECT MAX(MemberTotalFine)
            FROM (
                SELECT MemberId, SUM(FineAmount) AS MemberTotalFine
                FROM FINES
                GROUP BY MemberId
            ) AS FineTotals
        )
        ORDER BY TotalFineAmount DESC;
  `;

  // Execute the query
  db.query(query, params, (err, results) => {
    if (err) {
      console.error("Error fetching member with highest fine:", err);
      return res.status(500).json({ error: "Error fetching member with highest fine" });
    }

    // Return the results as JSON
    res.json(results);
  });
}


module.exports = {
  getAllMembers,
  getOverdueMembers,
  getMemberWithHighestFine,
};
