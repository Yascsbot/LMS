-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 19, 2024 at 12:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `archive`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `BOOK_ID` int(30) NOT NULL,
  `TITLE` varchar(256) NOT NULL,
  `AUTHOR` varchar(128) NOT NULL,
  `ISBN` varchar(13) NOT NULL,
  `GENRE` varchar(64) NOT NULL,
  `PUBLICATION_DATE` date NOT NULL DEFAULT current_timestamp(),
  `AVAILABLE_COPIES` int(99) DEFAULT NULL,
  `TOTAL_COPIES` int(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `FINE_ID` int(30) NOT NULL,
  `MEMBER_ID` int(30) NOT NULL,
  `LOAN_ID` int(30) NOT NULL,
  `FINE_AMOUNT` decimal(64,0) NOT NULL DEFAULT 5,
  `FINE_STATUS` varchar(256) NOT NULL,
  `PAYMENT_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `LOAN_ID` int(30) NOT NULL,
  `BOOK_ID` int(30) NOT NULL,
  `MEMBER_ID` int(30) NOT NULL,
  `LOAN_DATE` date NOT NULL DEFAULT current_timestamp(),
  `DUE_DATE` date NOT NULL,
  `RETURN_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `MEMBER_ID` int(30) NOT NULL,
  `NAME` varchar(256) NOT NULL,
  `EMAIL` varchar(128) NOT NULL,
  `PHONE_NUMBER` varchar(12) DEFAULT NULL,
  `ADDRESS` varchar(256) DEFAULT NULL,
  `MEMBERSHIP_TYPE` varchar(128) NOT NULL DEFAULT 'Individual',
  `JOIN_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `RESERVATION_ID` int(30) NOT NULL,
  `MEMBER_ID` int(30) NOT NULL,
  `BOOK_ID` int(30) NOT NULL,
  `RESERVATION_DATE` date NOT NULL DEFAULT current_timestamp(),
  `STATUS` varchar(256) NOT NULL COMMENT 'Two values "PENDING" or "FULFILLED"'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `STAFF_ID` int(30) NOT NULL,
  `NAME` varchar(256) NOT NULL,
  `EMAIL` varchar(128) NOT NULL,
  `ROLE` varchar(64) NOT NULL,
  `USERNAME` varchar(64) NOT NULL,
  `PASSWORD` varchar(64) NOT NULL COMMENT 'Encrypted version is stored.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BOOK_ID`),
  ADD UNIQUE KEY `TITLE ISBN UNIQUE` (`TITLE`,`ISBN`),
  ADD CHECK (BOOK_ID > 0);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`FINE_ID`),
  ADD KEY `fines_member_id_foreign` (`MEMBER_ID`),
  ADD KEY `fines_loan_id_foreign` (`LOAN_ID`),
  ADD CHECK (FINE_ID > 0),
  ADD CHECK (FINE_AMOUNT > 0 AND FINE_AMOUNT < 1000.00);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`LOAN_ID`),
  ADD KEY `loan_book_id_foreign` (`BOOK_ID`),
  ADD KEY `loan_member_id_foreign` (`MEMBER_ID`),
  ADD CHECK (LOAN_ID > 0);
--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`MEMBER_ID`),
  ADD UNIQUE KEY `EMAIL` (`EMAIL`,`PHONE_NUMBER`),
  ADD CHECK (MEMBER_ID > 0);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`RESERVATION_ID`),
  ADD KEY `res_member_id_foreign` (`MEMBER_ID`),
  ADD KEY `res_book_id_foreign` (`BOOK_ID`),
  ADD CHECK (RESERVATION_ID > 0);
--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`STAFF_ID`),
  ADD UNIQUE KEY `PASSWORD` (`PASSWORD`,`USERNAME`),
  ADD UNIQUE KEY `EMAIL` (`EMAIL`),
  ADD CHECK (STAFF_ID > 0);
--
-- Constraints for dumped tables
--

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fines_loan_id_foreign` FOREIGN KEY (`LOAN_ID`) REFERENCES `loans` (`LOAN_ID`),
  ADD CONSTRAINT `fines_member_id_foreign` FOREIGN KEY (`MEMBER_ID`) REFERENCES `members` (`MEMBER_ID`);

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loan_book_id_foreign` FOREIGN KEY (`BOOK_ID`) REFERENCES `books` (`BOOK_ID`),
  ADD CONSTRAINT `loan_member_id_foreign` FOREIGN KEY (`MEMBER_ID`) REFERENCES `members` (`MEMBER_ID`);

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `res_book_id_foreign` FOREIGN KEY (`BOOK_ID`) REFERENCES `books` (`BOOK_ID`),
  ADD CONSTRAINT `res_member_id_foreign` FOREIGN KEY (`MEMBER_ID`) REFERENCES `members` (`MEMBER_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
