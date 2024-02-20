-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 20, 2024 at 07:29 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mn_project_flutter`
--

-- --------------------------------------------------------

--
-- Table structure for table `bus_route`
--

CREATE TABLE `bus_route` (
  `route_no` varchar(4) NOT NULL,
  `codeLo` varchar(5) NOT NULL,
  `route_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `bus_route`
--

INSERT INTO `bus_route` (`route_no`, `codeLo`, `route_time`) VALUES
('1', '1011', '08:00:00'),
('2', '1102', '08:30:00'),
('3', '1103', '15:27:00');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `codeLo` varchar(5) NOT NULL,
  `nameLo` varchar(100) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`codeLo`, `nameLo`, `latitude`, `longitude`) VALUES
('1011', 'คณะเทคโนโลยีดิจิทัล', 19.9855695, 99.8435655),
('1102', 'สวนสมเด็จย่า', 19.9777653, 99.8468126),
('1103', 'ตลาดสดบ้านดู่', 19.9671219, 99.8556967),
('1104', 'เจ้าหมูชาบู', 19.9716967, 99.8601342);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `codeProduct` varchar(4) NOT NULL,
  `codeStore` varchar(3) NOT NULL,
  `nameProduct` varchar(100) NOT NULL,
  `count_unit` varchar(50) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`codeProduct`, `codeStore`, `nameProduct`, `count_unit`, `price`) VALUES
('5001', '101', 'เสื้อผ้า', 'ตัว', 500),
('5002', '102', 'รองเท้า', 'คู่', 800),
('5003', '103', 'กระเป๋า', 'ใบ', 1200);

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `codeStore` varchar(3) NOT NULL,
  `nameStore` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`codeStore`, `nameStore`) VALUES
('101', 'ร้านเสื้อผ้าชาย'),
('102', 'ร้านรองเท้า'),
('103', 'ร้านกระเป๋า');

-- --------------------------------------------------------

--
-- Table structure for table `tram_data`
--

CREATE TABLE `tram_data` (
  `tram_code` varchar(5) NOT NULL,
  `car_num` varchar(17) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tram_data`
--

INSERT INTO `tram_data` (`tram_code`, `car_num`) VALUES
('99001', 'TS-12346'),
('99002', 'TN-54321'),
('99003', 'TK-98765');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(5) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `firstname`, `lastname`, `email`, `password`, `phone`) VALUES
('00001', 'สมชาย', 'ใจดี', 'somchai@example.com', 'pass123', '0812345678'),
('00002', 'สมหญิง', 'ใจเย็น', 'somying@example.com', 'pass456', '0876543210'),
('00003', 'ประหยัด', 'เงิน', 'prayan@example.com', 'pass789', '0898765432'),
('00004', 'ณรงค์ฤทธิ์', 'สวยสม', 'save', 'save123', '0621653986'),
('00005', 'สุรศักดิ์', 'พันวนากร', 'surasak@gmail.com', 'lala123', '0632040255'),
('00006', 'กีรติ', 'สิงห์สุข', 'keera@gmail.com', 'keera123', '0654281395'),
('00007', 'ณรงค์ฤทธิ์', 'สวยสม', 'save@gmail.com', 'save123', '0621653986'),
('00008', 'test', 'test', 'test@gmaiil.com', 'test123', '0688888888');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bus_route`
--
ALTER TABLE `bus_route`
  ADD PRIMARY KEY (`route_no`,`codeLo`),
  ADD KEY `codeLo` (`codeLo`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`codeLo`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`codeProduct`,`codeStore`),
  ADD KEY `fk_codestore` (`codeStore`);

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`codeStore`);

--
-- Indexes for table `tram_data`
--
ALTER TABLE `tram_data`
  ADD PRIMARY KEY (`tram_code`,`car_num`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bus_route`
--
ALTER TABLE `bus_route`
  ADD CONSTRAINT `bus_route_ibfk_1` FOREIGN KEY (`codeLo`) REFERENCES `locations` (`codeLo`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_codestore` FOREIGN KEY (`codeStore`) REFERENCES `stores` (`codeStore`),
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`codeStore`) REFERENCES `stores` (`codeStore`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
