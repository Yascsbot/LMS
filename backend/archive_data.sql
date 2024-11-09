-- Database: archive
-- DBMS: MYSQL 
-- Drop tables if they exist
DROP TABLE IF EXISTS BOOKS;
DROP TABLE IF EXISTS MEMBERS;
DROP TABLE IF EXISTS LOANS;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS FINES;
DROP TABLE IF EXISTS RESERVATIONS;

-- --------------------------------------------------------
-- ***************************
-- Part A
-- ***************************
-- Table structure for table BOOKS

CREATE TABLE BOOKS (
    BookId INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(256) NOT NULL,
    Author VARCHAR(128) NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Genre VARCHAR(64) NOT NULL,
    PublicationDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    AvailableCopies INT DEFAULT NULL,
    TotalCopies INT DEFAULT NULL,
    PRIMARY KEY (BookId),
    UNIQUE (Title),
    UNIQUE (ISBN)
)ENGINE=InnoDB;

-- --------------------------------------------------------

-- Table structure for table MEMBERS

CREATE TABLE MEMBERS (
    MemberId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(256) NOT NULL,
    Email VARCHAR(128) NOT NULL,
    PhoneNumber VARCHAR(12) DEFAULT NULL,
    Address VARCHAR(256) DEFAULT NULL,
    MembershipType VARCHAR(128) NOT NULL DEFAULT 'Individual',
    JoinDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MemberId),
    UNIQUE (Email),
    UNIQUE (PhoneNumber)
)ENGINE=InnoDB;

-- --------------------------------------------------------
-- change ReturnDate to view
-- Table structure for table LOANS

CREATE TABLE LOANS (
    LoanId INT NOT NULL AUTO_INCREMENT,
    BookId INT,
    MemberId INT,
    LoanDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DueDate TIMESTAMP NOT NULL,
    ReturnDate DATETIME DEFAULT NULL,
    PRIMARY KEY (LoanId),
    FOREIGN KEY (BookId) REFERENCES BOOKS(BookId) ON DELETE SET NULL,
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE SET NULL
)ENGINE=InnoDB;

-- --------------------------------------------------------

-- Table structure for table STAFF

CREATE TABLE STAFF (
    StaffId INT NOT NULL CHECK(StaffId > 0),
    Name VARCHAR(256) NOT NULL,
    Email VARCHAR(128) NOT NULL,
    Role VARCHAR(64) NOT NULL,
    Username VARCHAR(64) NOT NULL,
    Password VARCHAR(64) NOT NULL,
    PRIMARY KEY (StaffId),
    UNIQUE (Password, Username),
    UNIQUE (Email)
)ENGINE=InnoDB;

-- --------------------------------------------------------

-- Table structure for table FINES

CREATE TABLE FINES (
    FineId INT NOT NULL CHECK(FineId > 0),
    MemberId INT,
    LoanId INT,
    FineAmount DECIMAL(64, 0) NOT NULL DEFAULT 5,
    FineStatus VARCHAR(256) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (FineId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (LoanId) REFERENCES LOANS(LoanId) ON DELETE SET NULL ON UPDATE CASCADE
)ENGINE=InnoDB;

-- --------------------------------------------------------

-- Table structure for table RESERVATIONS

CREATE TABLE RESERVATIONS (
    ReservationId INT NOT NULL CHECK(ReservationId > 0),
    MemberId INT,
    BookId INT,
    ReservationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(256) NOT NULL COMMENT 'Two values "PENDING" or "FULFILLED"',
    PRIMARY KEY (ReservationId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (BookId) REFERENCES BOOKS(BookId) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ***************************
-- Part B
-- ***************************
-- Insert------------------------------------------------------
INSERT INTO BOOKS (BookID, Title, Author, ISBN, Genre, PublicationDate, AvailableCopies, TotalCopies) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', '1925-04-10', 5, 10),
(2, '1984', 'George Orwell', '9780451524935', 'Dystopian', '1949-06-08', 3, 10),
(3, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Fiction', '1960-07-11', 4, 10),
(4, 'Moby Dick', 'Herman Melville', '9781503280786', 'Adventure', '1851-11-14', 2, 10),
(5, 'War and Peace', 'Leo Tolstoy', '9781420951080', 'Historical', '1869-01-01', 6, 10),
(6, 'Pride and Prejudice', 'Jane Austen', '9781503290563', 'Romance', '1813-01-28', 8, 10),
(7, 'The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', '1951-07-16', 3, 10),
(8, 'The Odyssey', 'Homer', '9780140268867', 'Epic', '1952-08-30', 7, 10),
(9, 'Brave New World', 'Aldous Huxley', '9780060850524', 'Dystopian', '1932-01-01', 2, 10),
(10, 'The Iliad', 'Homer', '9780140275360', 'Epic', '1963-01-15', 5, 10);

-- MEMBERS
INSERT INTO MEMBERS (MemberID, Name, Email, PhoneNumber, Address, MembershipType, JoinDate) VALUES
(1, 'Alice Johnson', 'alice@example.com', '1234567890', '123 Maple St.', 'Standard', '2023-01-15'),
(2, 'Bob Smith', 'bob.smith@example.com', '0987654321', '456 Oak Ave.', 'Premium', '2023-02-20'),
(3, 'Carol White', 'carol.white@example.com', '9876543210', '789 Birch Blvd.', 'Standard', '2023-03-12'),
(4, 'David Black', 'david@example.com', '5647382910', '101 Pine St.', 'Standard', '2023-03-22'),
(5, 'Emily Green', 'emily.green@example.com', '3421567890', '202 Willow Way', 'Premium', '2023-04-02'),
(6, 'Frank Wright', 'frank.w@example.com', '6789054321', '303 Cedar Ct.', 'Standard', '2023-04-10'),
(7, 'Grace Lee', 'grace.lee@example.com', '3456781234', '404 Spruce Rd.', 'Premium', '2023-04-15'),
(8, 'Hank Brown', 'hank.b@example.com', '4567890123', '505 Redwood Blvd.', 'Standard', '2023-04-20'),
(9, 'Irene James', 'irene.j@example.com', '5678901234', '606 Poplar St.', 'Premium', '2023-04-25'),
(10, 'John King', 'john.king@example.com', '6789012345', '707 Ash Ln.', 'Standard', '2023-05-01');

-- LOANS
INSERT INTO LOANS (LoanID, BookID, MemberID, LoanDate, DueDate, ReturnDate) VALUES
(1, 1, 2, '2023-04-01', '2023-04-15', '2023-04-14'),
(2, 3, 1, '2023-04-03', '2023-04-17', NULL),
(3, 2, 3, '2023-04-05', '2023-04-19', '2023-04-18'),
(4, 5, 4, '2023-04-10', '2023-04-24', NULL),
(5, 6, 5, '2023-04-12', '2023-04-26', '2023-04-25'),
(6, 4, 6, '2023-04-13', '2023-04-27', '2023-04-26'),
(7, 7, 7, '2023-04-14', '2023-04-28', NULL),
(8, 8, 8, '2023-04-15', '2023-04-29', NULL),
(9, 9, 9, '2023-04-16', '2023-04-30', '2023-04-30'),
(10, 10, 10, '2023-04-17', '2023-05-01', NULL);

-- STAFF
INSERT INTO STAFF (StaffID, Name, Email, Role, Username, Password) VALUES
(1, 'David Brown', 'david@example.com', 'Librarian', 'dbrown', 'hashed_password1'),
(2, 'Emily Green', 'emily@example.com', 'Assistant', 'egreen', 'hashed_password2'),
(3, 'Frank Hill', 'frank@example.com', 'Administrator', 'fhill', 'hashed_password3'),
(4, 'Gina Ray', 'gina@example.com', 'Librarian', 'gray', 'hashed_password4'),
(5, 'Helen Snow', 'helen@example.com', 'Assistant', 'hsnow', 'hashed_password5'),
(6, 'Ian Black', 'ian@example.com', 'Technician', 'iblack', 'hashed_password6'),
(7, 'Jane Green', 'jane@example.com', 'Librarian', 'jgreen', 'hashed_password7'),
(8, 'Kyle White', 'kyle@example.com', 'Technician', 'kwhite', 'hashed_password8'),
(9, 'Lisa Blue', 'lisa@example.com', 'Administrator', 'lblue', 'hashed_password9'),
(10, 'Mark Red', 'mark@example.com', 'Librarian', 'mred', 'hashed_password10');

-- FINES
INSERT INTO FINES (FineID, MemberID, LoanID, FineAmount, FineStatus, PaymentDate) VALUES
(1, 2, 1, 5.00, 'Paid', '2023-04-16'),
(2, 1, 2, 10.00, 'Unpaid', NULL),
(3, 3, 3, 3.00, 'Paid', '2023-04-19'),
(4, 4, 4, 2.00, 'Unpaid', NULL),
(5, 5, 5, 1.00, 'Paid', '2023-04-25'),
(6, 6, 6, 4.50, 'Unpaid', NULL),
(7, 7, 7, 6.00, 'Paid', '2023-04-28'),
(8, 8, 8, 7.50, 'Paid', '2023-04-29'),
(9, 9, 9, 5.00, 'Paid', '2023-04-30'),
(10, 10, 10, 8.00, 'Unpaid', NULL);

-- RESERVATIONS
INSERT INTO RESERVATIONS (ReservationID, MemberID, BookID, ReservationDate, Status) VALUES
(1, 1, 3, '2023-05-10', 'Pending'),
(2, 2, 1, '2023-05-11', 'Fulfilled'),
(3, 3, 2, '2023-05-12', 'Pending'),
(4, 4, 5, '2023-05-13', 'Fulfilled'),
(5, 5, 6, '2023-05-14', 'Pending'),
(6, 6, 4, '2023-05-15', 'Fulfilled'),
(7, 7, 7, '2023-05-16', 'Pending'),
(8, 8, 8, '2023-05-17', 'Fulfilled'),
(9, 9, 9, '2023-05-18', 'Pending'),
(10, 10, 10, '2023-05-19', 'Fulfilled');

-- ***************************
-- Part C
-- ***************************
/* ********************************
 Query 1: Join of Three Tables with JOIN ON
 Purpose: Retrieve the titles and authors of books that have been borrowed by members,
 along with the member’s name and loan date. 
 Expected Result: A list of member's names, the title of the book that has been borrowed, the author,
 and the date that it has been loaned out.
   ********************************
*/
SELECT MEMBERS.Name AS Membername, BOOKS.Title, BOOKS.Author, LOANS.LoanDate
FROM LOANS
JOIN BOOKS ON LOANS.BookID = BOOKS.BookID
JOIN MEMBERS ON LOANS.MemberID = MEMBERS.MemberID
ORDER BY MEMBERS.Name ASC, BOOKS.Title ASC, LOANS.LoanDate ASC;




/* ********************************
 Query 2:Nested Query with IN, ANY, or ALL and GROUP BY
 Purpose: Find the books that have been reserved by members more than the average amount of loans that have unpaid fines.
 Expected Result: Book titles and the number of times that it has been loaned out. 
   ********************************
   */
SELECT BOOKS.Title, COUNT(LOANS.LoanID) AS "Number of Loans"
FROM BOOKS
JOIN LOANS ON BOOKS.BookID = LOANS.BookID
JOIN MEMBERS ON LOANS.MemberID = MEMBERS.MemberID
WHERE MEMBERS.MemberID IN (
    SELECT F.MemberID
    FROM FINES F
    JOIN RESERVATIONS R ON F.MemberID = R.MemberID
    WHERE F.FineStatus = 'Unpaid' AND R.Status = 'Pending'
)
GROUP BY BOOKS.Title
HAVING COUNT(LOANS.LoanID) > (
    SELECT AVG(LoanCount)
    FROM (
        SELECT COUNT(LoanID) AS LoanCount
        FROM LOANS
        GROUP BY BookID
    ) AS AvgLoanCounts
)
ORDER BY "Number of Loans" DESC;





 /* ********************************
 Query 3: Correlated Nested Query with Aliasing
 Purpose: Retrieve the names of members who have an overdue loan (Loan Due Date < Current Date).
 Expected Result: A list of member names with overdue loans.
   ********************************
*/
SELECT M.Name
FROM MEMBERS AS M
WHERE EXISTS (
    SELECT L.LoanID
    FROM LOANS AS L
    WHERE L.MemberID = M.MemberID
    AND L.DueDate < CURDATE()
    AND L.ReturnDate IS NULL
);

/* ********************************
 Query 4: FULL OUTER JOIN
 Purpose: List all books with their reservation status, showing whether they are reserved or not.
 Use a FULL OUTER JOIN to include books that are not currently reserved. 
 Since MYSQL doesn't support a FULL OUTTER JOIN, the LEFT and RIGHT JOIN  were used in addition
 with union.
 Expected Result: A list of book titles and reservation status (NULL if no reservation exists).
   ********************************
*/
SELECT B.Title, R.Status AS ReservationStatus
FROM BOOKS B
LEFT JOIN RESERVATIONS R ON B.BookID = R.BookID

UNION

SELECT B.Title, R.Status AS ReservationStatus
FROM BOOKS B
RIGHT JOIN RESERVATIONS R ON B.BookID = R.BookID
ORDER BY  ReservationStatus ASC;




/* ********************************
 Query 5: Nested Query with Set Operations UNION, EXCEPT, or INTERSECT.
 Purpose: Find books that are currently reserved but have never been borrowed.
 Expected Result: A list of book titles that have active reservations but no loan records.
******************************** */

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



/* ********************************
 Query 6: Non-Trivial Query Using Two Tables
 Purpose: Find the top 3 most frequently borrowed books by title. 
 Expected Result: Titles of the top 3 most borrowed books, ranked by number of loans.
   ********************************
*/
SELECT B.Title, COUNT(L.LoanID) AS BorrowCount
FROM BOOKS B
JOIN LOANS L ON B.BookID = L.BookID
GROUP BY B.Title
ORDER BY BorrowCount DESC
LIMIT 3;

/* ********************************
 Query 7: Non-Trivial Query Using Two Tables
 Purpose: Retrieve names of members and the total amount of fines they owe (unpaid fines). 
 Expected Result: A list of member names with the total unpaid fines amount for each.
   ********************************
*/
SELECT M.Name, SUM(F.FineAmount) AS TotalUnpaidFines
FROM MEMBERS M
JOIN FINES F ON M.MemberID = F.MemberID
WHERE F.FineStatus = 'Unpaid'
GROUP BY M.Name;

/* ********************************
 Query 8: Non-Trivial Query Using Two Tables
 Purpose: List all members who have never borrowed a book. 
 Expected Result: A list of member names who have no records in the Loans table.
   ********************************
*/
SELECT M.Name
FROM MEMBERS M
LEFT JOIN LOANS L ON M.MemberID = L.MemberID
WHERE L.LoanID IS NULL;

/* ********************************
 Query 9:Non-Trivial Query Using Three Tables
 Purpose: Show the staff member’s name and role for each loan transaction, along with the name of
 the member who borrowed the book. 
 Expected Result: List of loans with the names of the borrower and the staff member overseeing the loan.
   ********************************
*/
SELECT L.LoanID, M.Name AS MemberName, S.Name AS StaffName, S.Role
FROM LOANS L
JOIN MEMBERS M ON L.MemberID = M.MemberID
LEFT JOIN STAFF S ON L.LoanID = S.StaffID;

/* ********************************
 Query 10: Non-Trivial Query Using Three Tables with Aliasing
 Purpose: Find members who have reserved a book but have not yet borrowed it. 
 Expected Result: Names of members who currently have pending reservations but no loans.
   ********************************
*/
SELECT M.Name AS ReservedMember, B.Title AS ReservedBook
FROM RESERVATIONS R
JOIN BOOKS B ON R.BookID = B.BookID
JOIN MEMBERS M ON R.MemberID = M.MemberId
LEFT JOIN LOANS L ON R.BookID = L.BookID AND R.MemberID = L.MemberID
WHERE R.Status = 'Pending' AND L.LoanID IS NULL
LIMIT 0, 25;
