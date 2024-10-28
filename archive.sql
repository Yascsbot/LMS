-- Database: archive

-- --------------------------------------------------------

-- Table structure for table BOOKS

CREATE TABLE BOOKS (
    BookId INT NOT NULL CHECK(BookId > 0),
    Title VARCHAR(256) NOT NULL,
    Author VARCHAR(128) NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Genre VARCHAR(64) NOT NULL,
    PublicationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    AvailableCopies INT DEFAULT NULL,
    TotalCopies INT DEFAULT NULL,
    PRIMARY KEY (BookId),
    UNIQUE (Title),
    UNIQUE (ISBN)
);

-- --------------------------------------------------------

-- Table structure for table MEMBERS

CREATE TABLE MEMBERS (
    MemberId INT NOT NULL CHECK(MemberId > 0),
    Name VARCHAR(256) NOT NULL,
    Email VARCHAR(128) NOT NULL,
    PhoneNumber VARCHAR(12) DEFAULT NULL,
    Address VARCHAR(256) DEFAULT NULL,
    MembershipType VARCHAR(128) NOT NULL DEFAULT 'Individual',
    JoinDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MemberId),
    UNIQUE (Email),
    UNIQUE (PhoneNumber)
);

-- --------------------------------------------------------

-- Table structure for table LOANS

CREATE TABLE LOANS (
    LoanId INT NOT NULL CHECK(LoanId > 0),
    BookId INT NOT NULL,
    MemberId INT NOT NULL,
    LoanDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DueDate TIMESTAMP NOT NULL,
    ReturnDate TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (LoanId),
    FOREIGN KEY (BookId) REFERENCES BOOKS(BookId)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId)
        ON DELETE SET NULL ON UPDATE CASCADE
);

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
);

-- --------------------------------------------------------

-- Table structure for table FINES

CREATE TABLE FINES (
    FineId INT NOT NULL CHECK(FineId > 0),
    MemberId INT NOT NULL,
    LoanId INT NOT NULL,
    FineAmount DECIMAL(64, 0) NOT NULL DEFAULT 5,
    FineStatus VARCHAR(256) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (FineId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (LoanId) REFERENCES LOANS(LoanId)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- --------------------------------------------------------

-- Table structure for table RESERVATIONS

CREATE TABLE RESERVATIONS (
    ReservationId INT NOT NULL CHECK(ReservationId > 0),
    MemberId INT NOT NULL,
    BookId INT NOT NULL,
    ReservationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(256) NOT NULL COMMENT 'Two values "PENDING" or "FULFILLED"',
    PRIMARY KEY (ReservationId),
    FOREIGN KEY (MemberId) REFERENCES MEMBERS(MemberId)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (BookId) REFERENCES BOOKS(BookId)
        ON DELETE SET NULL ON UPDATE CASCADE
);