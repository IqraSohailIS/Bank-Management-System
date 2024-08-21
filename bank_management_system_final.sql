-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 28, 2024 at 09:15 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bank_management_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `Account_No` varchar(100) NOT NULL,
  `Branch_Code` int NOT NULL,
  `Customer_ID` int NOT NULL,
  `Current_Balance` float NOT NULL,
  `Account_Status` varchar(100) NOT NULL,
  `Account_Type` varchar(100) NOT NULL,
  `PIN_Code` int NOT NULL,
  PRIMARY KEY (`Account_No`),
  KEY `Branch_Code` (`Branch_Code`),
  KEY `Customer_ID` (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`Account_No`, `Branch_Code`, `Customer_ID`, `Current_Balance`, `Account_Status`, `Account_Type`, `PIN_Code`) VALUES
('1-IS-2531', 1, 1, 68000, 'Active', 'Savings', 57032),
('1-ZN-3278', 1, 3, 42000, 'Active', 'Credit', 72937),
('2-HH-9267', 2, 2, 30000, 'Active', 'Checking', 23783),
('2-RI-8257', 2, 4, 18000, 'Suspended', 'Checking', 93468);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE IF NOT EXISTS `audit_log` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TABLE_NAME` varchar(255) DEFAULT NULL,
  `Action` varchar(10) DEFAULT NULL,
  `User` int DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`ID`, `TABLE_NAME`, `Action`, `User`, `timestamp`) VALUES
(1, 'loan', 'INSERT', 0, '2024-01-28 08:24:54'),
(2, 'person', 'UPDATE', 0, '2024-01-28 08:32:04'),
(3, 'loan_payment', 'DELETE', 0, '2024-01-28 08:44:41');

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
CREATE TABLE IF NOT EXISTS `branch` (
  `Branch_Code` int NOT NULL,
  `Employee_ID` int NOT NULL,
  `Branch_Name` varchar(100) NOT NULL,
  `City` varchar(100) NOT NULL,
  `Phone_No` varchar(100) NOT NULL,
  PRIMARY KEY (`Branch_Code`),
  KEY `Employee_ID` (`Employee_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`Branch_Code`, `Employee_ID`, `Branch_Name`, `City`, `Phone_No`) VALUES
(1, 1, 'Askari - 1', 'Rawalpindi', '0513736282'),
(2, 2, 'Askari - 2', 'Karachi', '0213764833');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `Customer_ID` int NOT NULL,
  `Person_ID` int NOT NULL,
  `Customer_Type` text NOT NULL,
  PRIMARY KEY (`Customer_ID`),
  KEY `Person_ID` (`Person_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Customer_ID`, `Person_ID`, `Customer_Type`) VALUES
(1, 1, 'Regular'),
(2, 2, 'Premium'),
(3, 3, 'Regular'),
(4, 4, 'Premium');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `Employee_ID` int NOT NULL,
  `Person_ID` int NOT NULL,
  `Position` text NOT NULL,
  PRIMARY KEY (`Employee_ID`),
  KEY `Person_ID` (`Person_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`Employee_ID`, `Person_ID`, `Position`) VALUES
(1, 5, 'Manager'),
(2, 3, 'Manager');

-- --------------------------------------------------------

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
CREATE TABLE IF NOT EXISTS `loan` (
  `Loan_ID` int NOT NULL,
  `Customer_ID` int NOT NULL,
  `Loan_Amount` int NOT NULL,
  `Interest_Rate` float NOT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date NOT NULL,
  `Term` int NOT NULL,
  `Loan_Status` varchar(100) NOT NULL,
  `Loan_Type` varchar(100) NOT NULL,
  `Total_Loan` decimal(10,2) GENERATED ALWAYS AS ((`Loan_Amount` + (`Loan_Amount` * (`Interest_Rate` / 100)))) STORED,
  PRIMARY KEY (`Loan_ID`),
  KEY `Customer_ID` (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `loan`
--

INSERT INTO `loan` (`Loan_ID`, `Customer_ID`, `Loan_Amount`, `Interest_Rate`, `Start_Date`, `End_Date`, `Term`, `Loan_Status`, `Loan_Type`) VALUES
(1, 3, 100000, 10, '2023-08-24', '2024-08-23', 12, 'Active', 'Personal'),
(2, 4, 3000000, 5, '2022-07-08', '2024-01-07', 18, 'Closed', 'Vehicle'),
(3, 2, 150000, 5, '2024-01-28', '2024-07-27', 6, 'Active', 'Personal');

--
-- Triggers `loan`
--
DROP TRIGGER IF EXISTS `after_insert_trigger`;
DELIMITER $$
CREATE TRIGGER `after_insert_trigger` AFTER INSERT ON `loan` FOR EACH ROW BEGIN
    INSERT INTO audit_log (TABLE_NAME, Action, User) VALUES ('loan', 'INSERT', CURRENT_USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loan_payment`
--

DROP TABLE IF EXISTS `loan_payment`;
CREATE TABLE IF NOT EXISTS `loan_payment` (
  `Loan_ID` int NOT NULL,
  `Transaction_ID` int NOT NULL,
  `Payment_ID` int NOT NULL,
  `Total_Installments` int NOT NULL,
  `Current_Installment` int NOT NULL,
  `Remaining_Amount` int NOT NULL,
  KEY `Loan_ID` (`Loan_ID`),
  KEY `Transaction_ID` (`Transaction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `loan_payment`
--

INSERT INTO `loan_payment` (`Loan_ID`, `Transaction_ID`, `Payment_ID`, `Total_Installments`, `Current_Installment`, `Remaining_Amount`) VALUES
(1, 2, 2, 3, 1, 85000),
(2, 3, 3, 2, 2, 0),
(1, 10, 4, 3, 2, 45000);

--
-- Triggers `loan_payment`
--
DROP TRIGGER IF EXISTS `after_delete_trigger`;
DELIMITER $$
CREATE TRIGGER `after_delete_trigger` AFTER DELETE ON `loan_payment` FOR EACH ROW BEGIN
    INSERT INTO audit_log (TABLE_NAME, Action, User) VALUES ('loan_payment', 'DELETE', CURRENT_USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `Person_ID` int NOT NULL,
  `Name` varchar(100) NOT NULL,
  `DOB` date NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone_No` varchar(100) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `CNIC` varchar(100) NOT NULL,
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`Person_ID`, `Name`, `DOB`, `Email`, `Phone_No`, `Address`, `CNIC`) VALUES
(1, 'Iqra', '2005-12-21', 'isohail@gmail.com', '0300367282', 'Rawalpindi', '72924692399'),
(2, 'Haiqa', '2002-12-11', 'hhashmi@gmail.com', '3203728328', 'Karachi', '39238818313'),
(3, 'Zoha', '2003-01-05', 'znaeem@gmail.com', '0213728893', 'Bahria Town', '329387832678'),
(4, 'Rafia', '2002-09-11', 'rikram@gmail.com', '02868801238', 'Gujranwala', '93783268763'),
(5, 'Ali', '2002-01-03', 'anaveed@gmail.com', '0356324862', 'Westridge', '3725829368123');

--
-- Triggers `person`
--
DROP TRIGGER IF EXISTS `after_update_trigger`;
DELIMITER $$
CREATE TRIGGER `after_update_trigger` AFTER UPDATE ON `person` FOR EACH ROW BEGIN
    INSERT INTO audit_log (TABLE_NAME, Action, User) VALUES ('person', 'UPDATE', CURRENT_USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `Transaction_ID` int NOT NULL,
  `Account_No` varchar(100) NOT NULL,
  `Transaction_Type` varchar(100) NOT NULL,
  `Date` date NOT NULL,
  `Amount` int NOT NULL,
  PRIMARY KEY (`Transaction_ID`),
  KEY `Account_No` (`Account_No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`Transaction_ID`, `Account_No`, `Transaction_Type`, `Date`, `Amount`) VALUES
(1, '2-RI-8257', 'Loan Installment', '2023-05-03', 1575000),
(2, '1-ZN-3278', 'Loan Installment', '2024-01-12', 25000),
(3, '2-RI-8257', 'Loan Installment', '2023-12-21', 1575000),
(4, '1-IS-2531', 'Deposit', '2024-01-27', 18000),
(5, '2-RI-8257', 'Debit', '2024-01-27', 5000),
(6, '2-HH-9267', 'Deposit', '2024-01-27', 10000),
(7, '2-HH-9267', 'Debit', '2024-01-27', 5000),
(8, '1-ZN-3278', 'Credit', '2024-01-27', 5000),
(9, '1-ZN-3278', 'Deposit', '2024-01-27', 2000),
(10, '1-ZN-3278', 'Loan Installment', '2024-01-27', 40000);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `customer` (`Customer_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `accounts_ibfk_2` FOREIGN KEY (`Branch_Code`) REFERENCES `branch` (`Branch_Code`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `branch`
--
ALTER TABLE `branch`
  ADD CONSTRAINT `branch_ibfk_1` FOREIGN KEY (`Employee_ID`) REFERENCES `employee` (`Employee_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loan`
--
ALTER TABLE `loan`
  ADD CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `customer` (`Customer_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loan_payment`
--
ALTER TABLE `loan_payment`
  ADD CONSTRAINT `loan_payment_ibfk_1` FOREIGN KEY (`Loan_ID`) REFERENCES `loan` (`Loan_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loan_payment_ibfk_2` FOREIGN KEY (`Transaction_ID`) REFERENCES `transactions` (`Transaction_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`Account_No`) REFERENCES `accounts` (`Account_No`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
