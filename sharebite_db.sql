-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2025 at 01:42 PM
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
-- Database: `sharebite_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `food_listings`
--

CREATE TABLE `food_listings` (
  `id` int(11) NOT NULL,
  `donorId` int(11) NOT NULL,
  `foodName` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `quantityUnit` varchar(20) DEFAULT NULL,
  `foodType` varchar(50) DEFAULT NULL,
  `expiryDate` date DEFAULT NULL,
  `pickupAddress` text DEFAULT NULL,
  `pickupCity` varchar(100) DEFAULT NULL,
  `pickupState` varchar(100) DEFAULT NULL,
  `pickupZipCode` varchar(20) DEFAULT NULL,
  `pickupInstructions` text DEFAULT NULL,
  `status` enum('available','requested','delivered','expired') DEFAULT 'available',
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isActive` tinyint(1) DEFAULT 1,
  `imageUrl` varchar(255) DEFAULT NULL,
  `storageCondition` varchar(255) DEFAULT NULL,
  `allergenInfo` varchar(255) DEFAULT NULL,
  `specialNotes` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT 0.00000000,
  `longitude` decimal(11,8) DEFAULT 0.00000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `food_listings`
--

INSERT INTO `food_listings` (`id`, `donorId`, `foodName`, `description`, `quantity`, `quantityUnit`, `foodType`, `expiryDate`, `pickupAddress`, `pickupCity`, `pickupState`, `pickupZipCode`, `pickupInstructions`, `status`, `createdAt`, `updatedAt`, `isActive`, `imageUrl`, `storageCondition`, `allergenInfo`, `specialNotes`, `latitude`, `longitude`) VALUES
(1, 9, 'Halwa', 'asgdsg', 56, 'lbs', 'canned', '2025-09-30', 'sfdgshcjvb', 'xszdxfcgvhb', 'sfdsgfh', '123654', '', 'expired', '2025-09-29 11:26:31', '2025-10-26 20:22:31', 1, '', '', '', '', 0.00000000, 0.00000000),
(2, 9, 'jhvdf', 'gr', 898, 'pieces', 'canned', '2025-09-30', 'Sfdsz', 'zdfgvd', 'dsgd', '164566', 'hghj', 'expired', '2025-09-29 11:30:16', '2025-10-26 20:22:31', 1, '', '', '', '', 0.00000000, 0.00000000),
(3, 9, 'eyr', 'ngdfj', 68, 'bags', 'canned', '2025-10-05', 'muyg', 'bvjgf', 'bvfjg', '484665', 'fvhiufi', 'expired', '2025-09-29 11:31:18', '2025-10-26 20:22:31', 1, '', 'frozen', 'vhrb', 'vetey', 0.00000000, 0.00000000),
(4, 9, 'new', '', 546, 'cans', 'fresh', '2025-10-03', 'etg', 'cfc', 'faef', '32534', '', 'expired', '2025-10-02 14:41:44', '2025-10-26 20:22:31', 1, '', '', '', '', 0.00000000, 0.00000000),
(5, 24, 'Shahi Paneer', '', 3, 'kg', 'fresh', '2025-11-01', 'ABES', 'Ghaziabad', 'Uttar Pradesh', '201002', '', 'available', '2025-10-31 10:34:25', '2025-10-31 10:34:25', 1, '', '', '', '', 28.63253500, 77.44221800),
(6, 24, 'Apple', 'Sweet and big in Size.\r\nEk sev roj khao , doctor ko dur bhagao....', 12, 'kg', 'fresh', '2025-11-01', 'ABESIT Group of Institution', 'Ghaziabad', 'Uttar Pradesh', '201002', 'Carefully Handle it', 'available', '2025-10-31 10:36:55', '2025-10-31 10:36:55', 1, '', '', '', '', 28.63253500, 77.44221800);

-- --------------------------------------------------------

--
-- Table structure for table `food_requests`
--

CREATE TABLE `food_requests` (
  `id` int(11) NOT NULL,
  `ngoId` int(11) NOT NULL,
  `foodListingId` int(11) NOT NULL,
  `requestMessage` text DEFAULT NULL,
  `pickupDate` date NOT NULL,
  `pickupTime` time DEFAULT NULL,
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `donorResponse` text DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isActive` tinyint(1) DEFAULT 1,
  `requestedQuantity` double DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `food_requests`
--

INSERT INTO `food_requests` (`id`, `ngoId`, `foodListingId`, `requestMessage`, `pickupDate`, `pickupTime`, `status`, `donorResponse`, `createdAt`, `updatedAt`, `isActive`, `requestedQuantity`) VALUES
(1, 9, 1, 'Sample request for testing purposes', '2025-11-01', '14:00:00', 'pending', NULL, '2025-10-31 04:38:57', '2025-10-31 04:38:57', 1, 1),
(2, 10, 6, 'ThankYou', '2025-11-01', '21:21:00', 'approved', NULL, '2025-10-31 05:28:21', '2025-10-31 05:29:42', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `ngo_details`
--

CREATE TABLE `ngo_details` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `registration_number` varchar(100) DEFAULT NULL,
  `organization_type` varchar(100) DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_title` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `service_area` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ngo_details`
--

INSERT INTO `ngo_details` (`id`, `user_id`, `registration_number`, `organization_type`, `mission`, `contact_person`, `contact_title`, `website`, `service_area`) VALUES
(1, 11, '021548976345', NULL, 'dcedbhegcuj', 'sjghjfwxw', 'xwsc j ghjwg', 'https://www.asdf.org', 'f jf yjdd'),
(2, 12, '', NULL, '', 'asdfg', 'asdfg', '', 'beh'),
(6, 16, '', NULL, '', 'fhndf d ku', 'hfysjyd', '', ''),
(7, 17, '', NULL, '', 'qwert', '', '', ''),
(8, 18, '', NULL, '', 'dasfsdgbf', '', '', ''),
(9, 19, '', NULL, '', 'hnnyniu', '', '', ''),
(10, 20, '0419817471654', NULL, 'exjhzgahjc ', 'abc', 'abc', 'https://abc.org', 'cbchgc'),
(11, 21, '21167677', NULL, 'sdngjhs', 'xyz', 'xyz', '', 'nbjhmchgjfg'),
(12, 23, '', NULL, '', 'dffg', '', '', ''),
(13, 25, '420', NULL, 'Instant Karma', 'Akshat Sharma', 'Manager', 'https://ngo.in', '');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `ngo_id` int(11) NOT NULL,
  `donor_id` int(11) DEFAULT NULL,
  `food_listing_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `type` varchar(50) DEFAULT 'general',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `ngo_id`, `donor_id`, `food_listing_id`, `message`, `type`, `is_read`, `created_at`) VALUES
(1, 10, 24, 6, 'Your food request has been APPROVED! You can proceed with pickup.', 'request_update', 0, '2025-10-31 05:29:42');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('donor','ngo','admin') NOT NULL,
  `organizationName` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isActive` tinyint(1) DEFAULT 1,
  `organizationType` varchar(100) DEFAULT NULL,
  `donationFrequency` varchar(100) DEFAULT NULL,
  `fulladdress` varchar(255) DEFAULT NULL,
  `verificationStatus` varchar(20) DEFAULT 'pending',
  `latitude` decimal(10,8) DEFAULT 0.00000000,
  `longitude` decimal(11,8) DEFAULT 0.00000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `organizationName`, `phone`, `createdAt`, `updatedAt`, `isActive`, `organizationType`, `donationFrequency`, `fulladdress`, `verificationStatus`, `latitude`, `longitude`) VALUES
(9, 'Sagar Varshney', 'sagar@gmail.com', 'Sagar@123', 'donor', 'Sagar', '1234567890', '2025-09-01 11:12:48', '2025-09-01 11:12:48', 1, 'restaurant', 'daily', 'Uninav Heights, Ghaziabad, UP - 201017', 'pending', 0.00000000, 0.00000000),
(10, 'Ram', 'ram@gmail.com', 'Ram@123', 'ngo', 'ShareBite', '12265686', '2025-09-01 11:42:28', '2025-09-03 10:26:46', 1, NULL, NULL, 'Abesit, Ghaziabad, U.P - 201365', 'verified', 0.00000000, 0.00000000),
(11, 'sjghjfwxw', 'asdf@123', 'Asdf@123', 'ngo', 'h kjgwdd', '1235656785', '2025-09-02 22:56:47', '2025-09-03 22:33:55', 1, NULL, NULL, 'vhg dytdf u djyr, cccccccccccc, sssssssssss - 123456', 'verified', 0.00000000, 0.00000000),
(12, 'asdfg', 'asdf@1', 'Asdf@123', 'ngo', 'fgrtgtg', '120151456', '2025-09-02 23:05:51', '2025-09-03 10:27:11', 1, NULL, NULL, 'sffgrsh, sdgrshg, sgshs - 16848917', 'rejected', 0.00000000, 0.00000000),
(16, 'fhndf d ku', 'asdf@as', 'Asdf@123', 'ngo', 'resy', '21458756230', '2025-09-03 16:36:00', '2025-09-03 16:41:59', 1, NULL, NULL, 'bchvjhv, ccccccccccc, sssssssss - 215696', 'rejected', 0.00000000, 0.00000000),
(17, 'qwert', 'qwerty@123', 'Qwerty@123', 'ngo', 'qwerty', '12345676543', '2025-09-03 22:35:37', '2025-09-28 19:01:51', 1, NULL, NULL, 'wdfh, cccccccccc, ssssssssssss - 2345343', 'verified', 0.00000000, 0.00000000),
(18, 'dasfsdgbf', 'dfgdbf@df', 'Asdf@123', 'ngo', 'dafsdfg', '342353465', '2025-09-03 22:45:12', '2025-09-03 22:45:12', 1, NULL, NULL, 'ewfrtetyg, efgrth, freg4th - 4627867', 'verified', 0.00000000, 0.00000000),
(19, 'hnnyniu', 'sachin@123', 'Sachin@123', 'ngo', 'asdfg', '58745214565', '2025-09-08 10:52:34', '2025-09-08 10:55:18', 1, NULL, NULL, 'gfhjkh, noida, up - 245596', 'rejected', 0.00000000, 0.00000000),
(20, 'abc', 'abc@1', 'Abc@123', 'ngo', 'abc', '1234567895', '2025-09-29 11:38:31', '2025-10-03 17:25:27', 1, NULL, NULL, 'sfdngkc, xjhsgxhj, sdmnbk - 268965', 'verified', 0.00000000, 0.00000000),
(21, 'xyz', 'xyz@1', 'Xyz@123', 'ngo', 'xyz', '895666545', '2025-09-29 11:39:37', '2025-10-03 17:25:27', 1, NULL, NULL, 'vjhgukg, gfjhg, bvjg j - 596478', 'verified', 0.00000000, 0.00000000),
(22, 'Anjali Varshney', 'anjali@gmail.com', 'aaaa1111!!', 'donor', 'Restaurant', '9837885185', '2025-09-30 18:29:51', '2025-09-30 18:29:51', 1, 'restaurant', 'daily', 'Ghaziabad, Ghaziabad, Uttar Pradesh - 982379', 'verified', 0.00000000, 0.00000000),
(23, 'dffg', 'asd@asd', 'asd@123', 'ngo', 'asd', '21545445', '2025-10-28 23:58:20', '2025-10-28 23:58:20', 1, NULL, NULL, 'ejbfhr, dfgd, rg - 6584', 'pending', 0.00000000, 0.00000000),
(24, 'Anjali Chauhan', 'chauhan@gmail.com', 'chauhan1!', 'donor', '', '0976563987', '2025-10-31 10:17:07', '2025-10-31 10:17:07', 1, 'catering', 'daily', 'SH271, H Block, Ghaziabad, Uttar Pradesh - 201002', 'verified', 0.00000000, 0.00000000),
(25, 'Akshat Sharma', 'akshat@gmail.com', 'akshat1!', 'ngo', 'Kar Bhala Ho Bhala', '9769885988', '2025-10-31 10:41:16', '2025-10-31 10:41:16', 1, NULL, NULL, 'B5 Om Vihar, Ghaziaba, Uttar Pradesh - 201016', 'pending', 28.63090800, 77.44269100);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `food_listings`
--
ALTER TABLE `food_listings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donorId` (`donorId`),
  ADD KEY `idx_location` (`latitude`,`longitude`);

--
-- Indexes for table `food_requests`
--
ALTER TABLE `food_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ngo_id` (`ngoId`),
  ADD KEY `idx_food_listing_id` (`foodListingId`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`createdAt`);

--
-- Indexes for table `ngo_details`
--
ALTER TABLE `ngo_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donor_id` (`donor_id`),
  ADD KEY `food_listing_id` (`food_listing_id`),
  ADD KEY `idx_ngo_id` (`ngo_id`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_location` (`latitude`,`longitude`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `food_listings`
--
ALTER TABLE `food_listings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `food_requests`
--
ALTER TABLE `food_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `ngo_details`
--
ALTER TABLE `ngo_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `food_listings`
--
ALTER TABLE `food_listings`
  ADD CONSTRAINT `food_listings_ibfk_1` FOREIGN KEY (`donorId`) REFERENCES `users` (`id`);

--
-- Constraints for table `ngo_details`
--
ALTER TABLE `ngo_details`
  ADD CONSTRAINT `ngo_details_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`ngo_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`donor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`food_listing_id`) REFERENCES `food_listings` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
