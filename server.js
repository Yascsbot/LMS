// Step 1: Import Required Libraries
const express = require("express");
const app = express();

// Import backend
const booksBackend = require("./backend/books");
const membersBackend = require("./backend/members");
const loansBackend = require("./backend/loans");
const finesBackend = require("./backend/fines");
const reservationsBackend = require("./backend/reservations");
const staffBackend = require("./backend/staff");

// Middleware Setup
app.use(express.json());
app.use(express.static("frontend"));
// as the images are in a different folder.
app.use("/images", express.static("images"));


//Define Routes
//Books
app.get("/books", booksBackend.getAllbooks);
app.get("/books/borrowed", booksBackend.getBorrowedBooks);
app.get("/books/reservationStats", booksBackend.getBooksWithReservationStatus);

// members routes
app.get("/members", membersBackend.getAllMembers);
app.get("/members/overdue", membersBackend.getOverdueMembers);
app.get("/members/highestFine", membersBackend.getMemberWithHighestFine);

// // Loans routes
app.get("/loans", loansBackend.getAllLoans);
app.get("/loans/recent", loansBackend.getRecentLoans);
app.get("/loans/overdue", loansBackend.getOverdueLoanDetails);

// // Fines routes
app.get("/fines", finesBackend.getAllFines);
app.get("/fines/popularBooksByFee", finesBackend.getPopularBooksByFee);

// // Staff routes
app.get("/staff", staffBackend.getAllStaff);

// // Reservations routes
app.get("/reservations", reservationsBackend.getAllReservations);
app.get("/reservations/reservedNeverBorrowed",
  reservationsBackend.getReservedBooksNeverBorrowed
);

// Start the Server
// Define the port the server will listen on, defaulting to 5000 if not specified in environment variables.
const PORT = process.env.PORT || 5000;
// Start the server and log a message indicating the URL.
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
