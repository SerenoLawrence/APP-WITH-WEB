-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 10, 2026 at 05:41 AM
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
-- Database: `civilwatch`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_01_01_000010_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `message` varchar(500) NOT NULL,
  `type` enum('report_submitted','report_assigned','status_update','report_resolved','system') NOT NULL DEFAULT 'system',
  `report_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Optional link back to the related report',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '6dd6eb0be9a03c8105391cee80ee84153d08ed288692ccd54e74d5444dc6b612', '[\"*\"]', NULL, NULL, '2026-08-09 05:11:23', '2026-08-09 05:11:23'),
(2, 'App\\Models\\User', 1, 'auth_token', '282a06889db178dd22dbbe0d6eaecc255edddc5b040929673a0b14a8ed9f16b1', '[\"*\"]', NULL, NULL, '2026-08-09 05:22:07', '2026-08-09 05:22:07'),
(3, 'App\\Models\\User', 1, 'auth_token', 'ae1a7a27420077e988eb4d2131420f2bf59b6f7c0da8a0cb227bab3df1161006', '[\"*\"]', '2026-08-09 05:23:13', NULL, '2026-08-09 05:23:13', '2026-08-09 05:23:13'),
(4, 'App\\Models\\User', 1, 'auth_token', '4d6f0f884aee8130a259d31bc0ce8fcfd6a60027b5a4447c514e0adc770e13cd', '[\"*\"]', '2026-08-09 05:23:24', NULL, '2026-08-09 05:23:24', '2026-08-09 05:23:24'),
(5, 'App\\Models\\User', 1, 'auth_token', '731a1e9692bd39b9e6b8b6b630a56807ae7cffef99a0e8875e4208117829c53b', '[\"*\"]', '2026-08-09 05:23:38', NULL, '2026-08-09 05:23:38', '2026-08-09 05:23:38'),
(6, 'App\\Models\\User', 1, 'auth_token', '6a002df94067a46359feb79b3d8f20ef1c144585f60a0c63a12e46158cb3d716', '[\"*\"]', '2026-08-09 05:23:51', NULL, '2026-08-09 05:23:50', '2026-08-09 05:23:51'),
(7, 'App\\Models\\User', 1, 'auth_token', '3935ed952ba85e24fe2856263ffadc0cc046b2acf64012e3740c3abef64176ec', '[\"*\"]', '2026-08-09 05:24:09', NULL, '2026-08-09 05:24:09', '2026-08-09 05:24:09'),
(9, 'App\\Models\\User', 1, 'auth_token', 'fbbfc2be0e5fe8aff60aea9b37c73cca6a5faea90374ff40b9f2c867dc0f5a08', '[\"*\"]', '2026-08-09 05:31:46', NULL, '2026-08-09 05:28:02', '2026-08-09 05:31:46');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(10) UNSIGNED NOT NULL,
  `reference_no` varchar(30) NOT NULL COMMENT 'e.g. CW-2026-00001',
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` enum('infrastructure','environmental','public_safety','sanitation','other') NOT NULL DEFAULT 'other',
  `status` enum('submitted','pending','assigned','in_progress','for_resolution','resolved') NOT NULL DEFAULT 'submitted',
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `barangay` varchar(100) DEFAULT NULL,
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `address_text` varchar(255) DEFAULT NULL COMMENT 'Human-readable address from reverse geocode',
  `submitted_by` varchar(120) DEFAULT NULL COMMENT 'Citizen name (unauthenticated submission)',
  `submitted_contact` varchar(100) DEFAULT NULL COMMENT 'Email or phone of citizen',
  `assigned_to_office` enum('CEO','CENRO') DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_assignments`
--

CREATE TABLE `report_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `report_id` int(10) UNSIGNED NOT NULL,
  `assigned_to` enum('CEO','CENRO') NOT NULL,
  `assigned_by` int(10) UNSIGNED NOT NULL COMMENT 'FK to users (super_admin)',
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_photos`
--

CREATE TABLE `report_photos` (
  `id` int(10) UNSIGNED NOT NULL,
  `report_id` int(10) UNSIGNED NOT NULL,
  `type` enum('before','after') NOT NULL DEFAULT 'before',
  `cloudinary_url` varchar(500) NOT NULL,
  `cloudinary_public_id` varchar(255) NOT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users; null = citizen upload',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_timeline`
--

CREATE TABLE `report_timeline` (
  `id` int(10) UNSIGNED NOT NULL,
  `report_id` int(10) UNSIGNED NOT NULL,
  `action` varchar(100) NOT NULL COMMENT 'e.g. status_change, note_added, photo_uploaded',
  `note` text DEFAULT NULL,
  `from_status` enum('submitted','pending','assigned','in_progress','for_resolution','resolved') DEFAULT NULL,
  `to_status` enum('submitted','pending','assigned','in_progress','for_resolution','resolved') DEFAULT NULL,
  `performed_by` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to users; null = system/citizen',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('super_admin','ceo','cenro') NOT NULL DEFAULT 'ceo',
  `office` varchar(100) DEFAULT NULL COMMENT 'e.g. CEO, CENRO — null for super_admin',
  `avatar_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `office`, `avatar_url`, `is_active`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'System Administrator', 'admin@civilwatch.gov.ph', '$2y$12$tmoJx.BhfXXcN59Pjx65VeBSvZtvwshfcpuvW2OlNXioYgEuk4okG', 'super_admin', NULL, NULL, 1, NULL, '2026-08-07 13:17:36', '2026-08-09 13:10:56'),
(2, 'CEO Administrator', 'ceo@civilwatch.gov.ph', '$2b$12$5t6T7q0X8gvKzTmRqHkpQO7yC8wP8bRrOJNkMwpbS4pV02r8mLBei', 'ceo', 'CEO', NULL, 1, NULL, '2026-08-07 13:17:36', '2026-08-07 13:17:36'),
(3, 'CENRO Administrator', 'cenro@civilwatch.gov.ph', '$2b$12$9bQzVxNE3wM7vCpT6LnHROqFZiDy2Jwr0K5mXt4sGkEuHYPbL1Oai', 'cenro', 'CENRO', NULL, 1, NULL, '2026-08-07 13:17:36', '2026-08-07 13:17:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user_id` (`user_id`),
  ADD KEY `idx_notifications_is_read` (`is_read`),
  ADD KEY `idx_notifications_created` (`created_at`),
  ADD KEY `fk_notifications_report` (`report_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reports_reference_no` (`reference_no`),
  ADD KEY `idx_reports_status` (`status`),
  ADD KEY `idx_reports_category` (`category`),
  ADD KEY `idx_reports_barangay` (`barangay`),
  ADD KEY `idx_reports_assigned` (`assigned_to_office`),
  ADD KEY `idx_reports_created_at` (`created_at`);

--
-- Indexes for table `report_assignments`
--
ALTER TABLE `report_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_assignments_report_id` (`report_id`),
  ADD KEY `fk_assignments_assigner` (`assigned_by`);

--
-- Indexes for table `report_photos`
--
ALTER TABLE `report_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_photos_report_id` (`report_id`),
  ADD KEY `fk_photos_uploader` (`uploaded_by`);

--
-- Indexes for table `report_timeline`
--
ALTER TABLE `report_timeline`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_timeline_report_id` (`report_id`),
  ADD KEY `idx_timeline_created_at` (`created_at`),
  ADD KEY `fk_timeline_performer` (`performed_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_assignments`
--
ALTER TABLE `report_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_photos`
--
ALTER TABLE `report_photos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_timeline`
--
ALTER TABLE `report_timeline`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_assignments`
--
ALTER TABLE `report_assignments`
  ADD CONSTRAINT `fk_assignments_assigner` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assignments_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_photos`
--
ALTER TABLE `report_photos`
  ADD CONSTRAINT `fk_photos_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_photos_uploader` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `report_timeline`
--
ALTER TABLE `report_timeline`
  ADD CONSTRAINT `fk_timeline_performer` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_timeline_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
