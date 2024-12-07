-- Database: ARCHIVE
-- DBMS: MYSQL 
-- DBMS: MYSQL 
-- Drop tables if they exist
DROP DATABASE IF EXISTS ARCHIVE;
CREATE DATABASE ARCHIVE;
USE ARCHIVE;
DROP TABLE IF EXISTS BOOKS_DETAILS;
DROP TABLE IF EXISTS BOOK_INVENTORY;
DROP TABLE IF EXISTS MEMBERS;
DROP TABLE IF EXISTS LOANS;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS FINES;
DROP TABLE IF EXISTS FINE_STATUS;
DROP TABLE IF EXISTS RESERVATIONS;

-- --------------------------------------------------------
-- ***************************
-- Part A
-- ***************************
-- Table structure for table BOOKS

CREATE TABLE BOOKS_DETAILS (
    ISBN VARCHAR(13) NOT NULL,
    Title VARCHAR(256) NOT NULL,
    Author VARCHAR(128) NOT NULL,
    Genre VARCHAR(64) NOT NULL,
    PublicationDate DATETIME NOT NULL,
    AvailableCopies INT DEFAULT NULL CHECK (AvailableCopies > 0),
    TotalCopies INT DEFAULT NULL CHECK (TotalCopies > 0 AND AvailableCopies <= TotalCopies),
    PRIMARY KEY (ISBN)
);

-- Table structure for table BOOK_INVENTORY

CREATE TABLE BOOK_INVENTORY (
    BookId INT NOT NULL AUTO_INCREMENT,
    ISBN VARCHAR(13) NOT NULL,
    PRIMARY KEY (BookId),
    UNIQUE(ISBN),
    FOREIGN KEY (ISBN) REFERENCES BOOKS_DETAILS(ISBN)
);

-- --------------------------------------------------------

-- Table structure for table MEMBERS

CREATE TABLE MEMBERS (
    MemberId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(256) NOT NULL,
    Email VARCHAR(128) NOT NULL,
    PhoneNumber VARCHAR(12) DEFAULT NULL,
    Address VARCHAR(256) DEFAULT NULL,
    MembershipType ENUM('Individual', 'Standard', 'Premium') NOT NULL DEFAULT 'Individual',
    JoinDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MemberId),
    UNIQUE (Email),
    UNIQUE (PhoneNumber)
);

-- --------------------------------------------------------
-- change ReturnDate to view
-- Table structure for table LOANS

CREATE TABLE LOANS (
    LoanId INT NOT NULL AUTO_INCREMENT,
    BookId INT,
    MemberId INT,
    StaffID INT,
    LoanDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DueDate TIMESTAMP NOT NULL,
    ReturnDate DATETIME DEFAULT NULL,
    PRIMARY KEY (LoanId),
    FOREIGN KEY (BookId) REFERENCES BOOK_INVENTORY(BookId) ON DELETE CASCADE,
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE CASCADE,
    FOREIGN KEY (StaffID) REFERENCES STAFF(StaffId) ON DELETE CASCADE
);

-- --------------------------------------------------------

-- Table structure for table STAFF

CREATE TABLE STAFF (
    StaffId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(256) NOT NULL,
    Email VARCHAR(128) NOT NULL,
    Role VARCHAR(64) NOT NULL,
    Username VARCHAR(64) NOT NULL,
    Password VARCHAR(64) NOT NULL,
    PRIMARY KEY (StaffId),
    UNIQUE (Password, Username),
    UNIQUE (Email)
);

-- --------------------------------------------------------

-- Table structure for table FINES

CREATE TABLE FINES (
    FineId INT NOT NULL AUTO_INCREMENT,
    MemberId INT,
    LoanId INT,
    FineAmount DECIMAL(10, 2) NOT NULL DEFAULT 5.00 CHECK (FineAmount >= 0),
    PaymentDate TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (FineId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE CASCADE,
    FOREIGN KEY (LoanId) REFERENCES LOANS(LoanId) ON DELETE CASCADE
);

-- --------------------------------------------------------

-- Table structure for table FINE_STATUS
CREATE TABLE FINE_STATUS ( 
    MemberID INT NOT NULL,
    FineID INT NOT NULL, 
    FineStatus ENUM('Paid', 'Unpaid') NOT NULL,
    PRIMARY KEY (FineID, MemberID),
    FOREIGN KEY (FineID) REFERENCES FINES(FineID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES MEMBERS(MemberId) ON DELETE CASCADE
);

-- --------------------------------------------------------

-- Table structure for table RESERVATIONS

CREATE TABLE RESERVATIONS (
    ReservationId INT NOT NULL AUTO_INCREMENT,
    MemberId INT NOT NULL,
    BookId INT NOT NULL,
    ReservationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Fulfilled') NOT NULL,
    PRIMARY KEY (ReservationId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (BookId) REFERENCES BOOK_INVENTORY(BookId) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ***************************
-- Part B
-- ***************************
-- Insert------------------------------------------------------
INSERT INTO BOOKS_DETAILS (ISBN, Title, Author, Genre, PublicationDate, AvailableCopies, TotalCopies) VALUES
('9780743273565', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', '1925-04-10', 5, 10),
('9780451524935', '1984', 'George Orwell', 'Dystopian', '1949-06-08', 3, 10),
('9780061120084', 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', '1960-07-11', 4, 10),
('9781503280786', 'Moby Dick', 'Herman Melville', 'Adventure', '1851-11-14', 2, 10),
('9781420951080', 'War and Peace', 'Leo Tolstoy', 'Historical', '1869-01-01', 6, 10),
('9781503290563', 'Pride and Prejudice', 'Jane Austen', 'Romance', '1813-01-28', 8, 10),
('9780316769488', 'The Catcher in the Rye', 'J.D. Salinger', 'Fiction', '1951-07-16', 3, 10),
('9780140268867', 'The Odyssey', 'Homer', 'Epic', '1952-08-30', 7, 10),
('9780060850524', 'Brave New World', 'Aldous Huxley', 'Dystopian', '1932-01-01', 2, 10),
('9781613743447', 'Roadside Picnic', 'Arkady and Boris Strugatsky', 'Sci. Fiction', '1972-01-01', 10, 10),
('9780140275360', 'The Iliad', 'Homer', 'Epic', '1963-01-15', 5, 10);

-- BOOK_INVENTORY
INSERT INTO BOOK_INVENTORY (ISBN) VALUES
('9780743273565'),
('9780451524935'),
('9780061120084'),
('9781503280786'),
('9781420951080'),
('9781503290563'),
('9780316769488'),
('9780140268867'),
('9780060850524'),
('9781613743447'),
('9780140275360');


-- MEMBERS
INSERT INTO MEMBERS (Name, Email, PhoneNumber, Address, MembershipType, JoinDate) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', '123 Maple St.', 'Standard', '2023-01-15'),
('Bob Smith', 'bob.smith@example.com', '0987654321', '456 Oak Ave.', 'Premium', '2023-02-20'),
('Carol White', 'carol.white@example.com', '9876543210', '789 Birch Blvd.', 'Standard', '2023-03-12'),
('David Black', 'david@example.com', '5647382910', '101 Pine St.', 'Standard', '2023-03-22'),
('Emily Green', 'emily.green@example.com', '3421567890', '202 Willow Way', 'Premium', '2023-04-02'),
('Frank Wright', 'frank.w@example.com', '6789054321', '303 Cedar Ct.', 'Standard', '2023-04-10'),
('Grace Lee', 'grace.lee@example.com', '3456781234', '404 Spruce Rd.', 'Premium', '2023-04-15'),
('Hank Brown', 'hank.b@example.com', '4567890123', '505 Redwood Blvd.', 'Standard', '2023-04-20'),
('Irene James', 'irene.j@example.com', '5678901234', '606 Poplar St.', 'Premium', '2023-04-25'),
('John King', 'john.king@example.com', '6789012345', '707 Ash Ln.', 'Standard', '2023-05-01');

-- LOANS
INSERT INTO LOANS (BookID, MemberID, StaffID, LoanDate, DueDate, ReturnDate) VALUES
(1, 2, 1, '2023-04-01', '2023-04-15', '2023-04-14'),
(3, 1, 2, '2023-04-03', '2023-04-17', NULL),
(2, 3, 3, '2023-04-05', '2023-04-19', '2023-04-18'),
(5, 4, 4, '2023-04-10', '2023-04-24', NULL),
(6, 5, 5, '2023-04-12', '2023-04-26', '2023-04-25'),
(4, 6, 6, '2023-04-13', '2023-04-27', '2023-04-26'),
(7, 7, 7, '2023-04-14', '2023-04-28', NULL),
(8, 8, 8, '2023-04-15', '2023-04-29', NULL),
(9, 9, 9, '2023-04-16', '2023-04-30', '2023-04-30'),
(2, 2, 3, '2023-04-20', '2023-04-27', NULL),
(11, 10, 10, '2024-10-17', '2024-11-01', NULL);

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
INSERT INTO FINES (FineId, MemberId, LoanId, FineAmount, PaymentDate) VALUES
(1, 2, 1, 5.00, '2023-04-16'),
(2, 1, 2, 10.00, NULL),
(3, 3, 3, 3.00, '2023-04-19'),
(4, 4, 4, 2.00, NULL),
(5, 5, 5, 1.00, '2023-04-25'),
(6, 6, 6, 4.50, NULL),
(7, 7, 7, 6.00, '2023-04-28'),
(8, 8, 8, 7.50, '2023-04-29'),
(9, 9, 9, 5.00, '2023-04-30'),
(10, 2, 10, 7.00, NULL),
(11, 10, 11, 8.00, NULL);

-- FINE_STATUS
INSERT INTO FINE_STATUS (FineId, MemberId, FineStatus) VALUES
(1, 2, 'Paid'),
(2, 1, 'Unpaid'),
(3, 3, 'Paid'),
(4, 4, 'Unpaid'),
(5, 5, 'Paid'),
(6, 6, 'Unpaid'),
(7, 7, 'Paid'),
(8, 8, 'Paid'),
(9, 9, 'Paid'),
(10, 2, 'Unpaid'),
(11, 10, 'Unpaid');

-- RESERVATIONS
INSERT INTO RESERVATIONS (MemberID, BookID, ReservationDate, Status) VALUES
(1, 3, '2023-05-10', 'Pending'),
(2, 1, '2023-05-11', 'Fulfilled'),
(3, 2, '2023-05-12', 'Pending'),
(4, 5, '2023-05-13', 'Fulfilled'),
(5, 6, '2023-05-14', 'Pending'),
(6, 4, '2023-05-15', 'Fulfilled'),
(7, 7, '2023-05-16', 'Pending'),
(8, 8, '2023-05-17', 'Fulfilled'),
(9, 9, '2023-05-18', 'Pending'),
(10, 11, '2023-05-19', 'Fulfilled'),
(10, 10, '2023-05-20', 'Pending'),
(2, 2,'2023-04-19', 'Pending');

-- ***************************
-- Part C
-- ***************************
/* ********************************
 Query 1: Join of Three Tables with JOIN ON
 Purpose: Retrieve the titles and authors of books that have been borrowed by members,
 along with the member’s name, loan date and the return date if the book was returned.
 Expected Result: The title of the book that has been borrowed, the author, a list of member's names,
the date that it has been loaned out, and the return date if the book was returned otherise the return date 
is null.
   ********************************
*/
SELECT  
    BOOKS_DETAILS.Title, 
    BOOKS_DETAILS.Author, 
    MEMBERS.Name AS Membername,
    LOANS.LoanDate, 
    LOANS.ReturnDate
FROM 
    LOANS
JOIN 
    BOOK_INVENTORY ON LOANS.BookId = BOOK_INVENTORY.BookId
JOIN 
    BOOKS_DETAILS ON BOOK_INVENTORY.ISBN = BOOKS_DETAILS.ISBN
JOIN 
    MEMBERS ON LOANS.MemberId = MEMBERS.MemberId
ORDER BY 
    BOOKS_DETAILS.Title ASC, LOANS.LoanDate ASC;





/* ********************************
 Query 2:Nested Query with IN, ANY, or ALL and GROUP BY
 Purpose: Find the books that have been  currently reserved by members more than the average amount of loans that have unpaid fines.
 Expected Result: Book titles and the number of times that it has been loaned out. 
   ********************************
   */
SELECT BD.Title, COUNT(L.LoanID) AS "Number of Loans"
FROM BOOKS_DETAILS BD
JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
JOIN LOANS L ON BI.BookID = L.BookID
WHERE EXISTS (
    SELECT 1
    FROM RESERVATIONS R
    JOIN MEMBERS M ON R.MemberID = M.MemberID
    WHERE M.MemberID IN (
        SELECT F.MemberID
        FROM FINES F
        JOIN FINE_STATUS FS ON F.FineID = FS.FineID
        WHERE FS.FineStatus = 'Unpaid'
    )
    AND R.BookID = BI.BookID
    AND R.Status = 'Pending'
)
GROUP BY BD.Title
HAVING COUNT(L.LoanID) > (
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
SELECT BD.Title, R.Status AS ReservationStatus
FROM BOOKS_DETAILS BD
LEFT JOIN RESERVATIONS R ON BD.ISBN = (SELECT BI.ISBN FROM BOOK_INVENTORY BI WHERE BI.BookId = R.BookId LIMIT 1)
UNION
SELECT BD.Title, R.Status AS ReservationStatus
FROM BOOKS_DETAILS BD
RIGHT JOIN RESERVATIONS R ON BD.ISBN = (SELECT BI.ISBN FROM BOOK_INVENTORY BI WHERE BI.BookId = R.BookId LIMIT 1)
ORDER BY ReservationStatus ASC;





/* ********************************
 Query 5: Nested Query with Set Operations UNION, EXCEPT, or INTERSECT.
 Purpose: Find books that are currently reserved but have never been borrowed.
 Expected Result: A list of book titles that have active reservations but no loan records.
******************************** */

-- Books with active (pending) reservations
SELECT DISTINCT BD.Title AS BookTitle
FROM BOOKS_DETAILS BD
JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
JOIN RESERVATIONS R ON BI.BookID = R.BookID
WHERE R.Status = 'Pending'

EXCEPT

-- Books that have been borrowed
SELECT DISTINCT BD.Title AS BookTitle
FROM BOOKS_DETAILS BD
JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
JOIN LOANS L ON BI.BookID = L.BookID
ORDER BY BookTitle ASC;






/* Faith: Last five queries from Part C, */

/* ********************************
 Query 6: Non-Trivial Query Using Two Tables
 Purpose: Display the member with the highest fine amount.
 Expected Result: Retrieves member with highest total fine amount.
   ********************************
*/
SELECT m.Name AS MemberName, SUM(f.FineAmount) AS TotalFineAmount
FROM MEMBERS m
JOIN FINES f ON m.MemberId = f.MemberId
GROUP BY m.MemberId
HAVING SUM(f.FineAmount) = (
    SELECT MAX(MemberTotalFine)
    FROM (
        SELECT MemberId, SUM(FineAmount) AS MemberTotalFine
        FROM FINES
        GROUP BY MemberId
    ) AS FineTotals
);


/* ********************************
 Query 7: Non-Trivial Query Using Two Tables
 Purpose: Finds the titles of books borrowed by members within the last 30 days.
 Expected Result: Retrieves the names of members who have borrowed books within timeframe.
   ********************************
*/
SELECT M.Name AS MemberName, BD.Title AS BookTitle
FROM MEMBERS M
JOIN LOANS L ON M.MemberId = L.MemberId
JOIN BOOK_INVENTORY BI ON L.BookId = BI.BookId
JOIN BOOKS_DETAILS BD ON BI.ISBN = BD.ISBN
WHERE L.LoanDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY M.Name, BD.Title;


/* ********************************
 Query 8: Non-Trivial Query Using Two Tables
 Purpose: Finds the most popular books borrowed by members with outstanding fees.
 Expected Result: Lists the titles of books borrowed by members with outstanding fees
 and the count of times each has been borrowed by such members.
******************************** */

SELECT BD.Title AS BookTitle, COUNT(L.BookId) AS BorrowCount
FROM BOOKS_DETAILS BD
JOIN BOOK_INVENTORY BI ON BD.ISBN = BI.ISBN
JOIN LOANS L ON BI.BookId = L.BookId
WHERE L.MemberId IN (
    SELECT F.MemberId
    FROM FINES F
    JOIN FINE_STATUS FS ON F.FineId = FS.FineId
    WHERE FS.FineStatus = 'Unpaid'
)
GROUP BY BD.Title
ORDER BY BorrowCount DESC;




/* ********************************
 Query 9: Non-Trivial Query Using Three Tables
 Purpose: Finds details of overdue books with member and staff information.
 Expected Result: Retrieves the list of titles, authors of overdue books, the names
 of the members who borrowed them, and the staff members who processed the loans.
******************************** */

SELECT bd.Title AS BookTitle, bd.Author AS Author,
       m.Name AS MemberName,
       s.Name AS StaffName, s.Role AS StaffRole
FROM BOOKS_DETAILS bd
JOIN BOOK_INVENTORY bi ON bd.ISBN = bi.ISBN
JOIN LOANS l ON bi.BookId = l.BookId
JOIN MEMBERS m ON l.MemberId = m.MemberId
JOIN STAFF s ON l.StaffID = s.StaffId
WHERE l.DueDate < CURRENT_DATE
  AND l.ReturnDate IS NULL  -- Ensures the book is still overdue and not yet returned
ORDER BY l.DueDate ASC;


/* ********************************
 Query 10: Non-Trivial Query Using Three Tables with Aliasing
 Purpose: Member loan details with member and staff information.
 Expected Result: Retrieves the name of the borrowed, the title and author of
 the books borrowed, and the name of the staff member facilitating the loan.
   ********************************
*/
SELECT bd.Title AS BookTitle,
bd.Author AS BookAuthor,
m.Name AS MemberName,
s.Name AS StaffName
FROM BOOKS_DETAILS AS bd
JOIN BOOK_INVENTORY AS bi ON bd.ISBN = bi.ISBN
JOIN LOANS AS l ON bi.BookId = l.BookId
JOIN MEMBERS AS m ON l.MemberId = m.MemberId
JOIN STAFF AS s ON l.StaffId = s.StaffId
WHERE l.ReturnDate IS NULL;