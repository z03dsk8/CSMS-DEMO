-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               12.3.2-MariaDB - MariaDB Server
-- Server OS:                    Win64
-- HeidiSQL Version:             12.18.0.7304
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for csms_db
CREATE DATABASE IF NOT EXISTS `csms_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `csms_db`;

-- Dumping structure for table csms_db.approval_history
CREATE TABLE IF NOT EXISTS `approval_history` (
  `approval_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `approver_user_id` varchar(50) DEFAULT NULL,
  `approval_status` varchar(50) NOT NULL,
  `approved_at` timestamp NULL DEFAULT current_timestamp(),
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`approval_id`),
  KEY `fk_ah_permit` (`permit_id`),
  KEY `fk_ah_approver` (`approver_user_id`),
  CONSTRAINT `fk_ah_approver` FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ah_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.approval_history: ~1 rows (approximately)
INSERT INTO `approval_history` (`approval_id`, `permit_id`, `approver_user_id`, `approval_status`, `approved_at`, `comment`) VALUES
	('APP-001', 'WP-001', 'USR-003', 'Approved', '2026-08-18 04:00:00', 'APAR dan Fire Blanket wajib standby sebelum kerja dimulai');

-- Dumping structure for table csms_db.contractor_company
CREATE TABLE IF NOT EXISTS `contractor_company` (
  `company_id` varchar(50) NOT NULL,
  `company_name` varchar(150) NOT NULL,
  `license_no` varchar(100) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.contractor_company: ~1 rows (approximately)
INSERT INTO `contractor_company` (`company_id`, `company_name`, `license_no`, `contact_phone`, `address`) VALUES
	('CMP-001', 'PT Teknik Mandiri Jaya', 'LIC-2026-9982', '021-5550192', 'Jl. Industri No. 12, Bekasi');

-- Dumping structure for table csms_db.contractor_monitoring_log
CREATE TABLE IF NOT EXISTS `contractor_monitoring_log` (
  `log_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `log_date` timestamp NULL DEFAULT current_timestamp(),
  `observation` text DEFAULT NULL,
  `action_taken` text DEFAULT NULL,
  `monitored_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `fk_cml_permit` (`permit_id`),
  KEY `fk_cml_user` (`monitored_by`),
  CONSTRAINT `fk_cml_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cml_user` FOREIGN KEY (`monitored_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.contractor_monitoring_log: ~0 rows (approximately)

-- Dumping structure for table csms_db.document_qr
CREATE TABLE IF NOT EXISTS `document_qr` (
  `doc_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `doc_type` varchar(50) NOT NULL,
  `qr_code` varchar(255) NOT NULL,
  `file_url` text NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`doc_id`),
  KEY `fk_dq_permit` (`permit_id`),
  CONSTRAINT `fk_dq_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.document_qr: ~1 rows (approximately)
INSERT INTO `document_qr` (`doc_id`, `permit_id`, `doc_type`, `qr_code`, `file_url`, `uploaded_at`) VALUES
	('DOC-001', 'WP-001', 'Permit Document', 'QR-WP-2026-001', 'https://storage.csms.local/docs/PTW-2026-08-001.pdf', '2026-08-18 04:00:00');

-- Dumping structure for table csms_db.ehs_patrol
CREATE TABLE IF NOT EXISTS `ehs_patrol` (
  `patrol_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `patrol_date` timestamp NULL DEFAULT current_timestamp(),
  `patrol_officer_id` varchar(50) DEFAULT NULL,
  `area_zone` varchar(100) NOT NULL,
  `patrol_summary` text DEFAULT NULL,
  PRIMARY KEY (`patrol_id`),
  KEY `fk_ep_permit` (`permit_id`),
  KEY `fk_ep_officer` (`patrol_officer_id`),
  CONSTRAINT `fk_ep_officer` FOREIGN KEY (`patrol_officer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ep_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.ehs_patrol: ~1 rows (approximately)
INSERT INTO `ehs_patrol` (`patrol_id`, `permit_id`, `patrol_date`, `patrol_officer_id`, `area_zone`, `patrol_summary`) VALUES
	('PAT-001', 'WP-001', '2026-08-18 04:00:00', 'USR-002', 'Area Boiler Zone 3', 'Patroli rutin area kerja panas');

-- Dumping structure for table csms_db.ehs_patrol_finding
CREATE TABLE IF NOT EXISTS `ehs_patrol_finding` (
  `finding_id` varchar(50) NOT NULL,
  `patrol_id` varchar(50) DEFAULT NULL,
  `finding_description` text NOT NULL,
  `severity` varchar(20) NOT NULL,
  `status` varchar(50) NOT NULL,
  `remediation_action` text DEFAULT NULL,
  `found_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`finding_id`),
  KEY `fk_epf_patrol` (`patrol_id`),
  CONSTRAINT `fk_epf_patrol` FOREIGN KEY (`patrol_id`) REFERENCES `ehs_patrol` (`patrol_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.ehs_patrol_finding: ~1 rows (approximately)
INSERT INTO `ehs_patrol_finding` (`finding_id`, `patrol_id`, `finding_description`, `severity`, `status`, `remediation_action`, `found_at`) VALUES
	('FND-001', 'PAT-001', 'Pekerja tidak menggunakan kacamata las', 'Medium', 'Closed', 'Teguran langsung & kacamata langsung dipakai', '2026-08-18 04:00:00'),
	('FND-1787027337265', 'PAT-001', 'Pekerja Tidak Menggunakan Fire Blanket ketika pengelasan', 'Critical', 'Open', 'gunakan Fire Blanket ketika pengelasan', '2026-08-18 04:28:57');

-- Dumping structure for table csms_db.hazard_environment_aspect
CREATE TABLE IF NOT EXISTS `hazard_environment_aspect` (
  `hazard_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `hazard_type` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `risk_level` varchar(20) NOT NULL,
  `mitigation_notes` text DEFAULT NULL,
  PRIMARY KEY (`hazard_id`),
  KEY `fk_hea_permit` (`permit_id`),
  CONSTRAINT `fk_hea_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.hazard_environment_aspect: ~1 rows (approximately)
INSERT INTO `hazard_environment_aspect` (`hazard_id`, `permit_id`, `hazard_type`, `description`, `risk_level`, `mitigation_notes`) VALUES
	('HAZ-001', 'WP-001', 'Pengelasan / Hot Work', 'Potensi percikan api di sekitar pipa gas', 'High', 'Gunakan Fire Blanket & sediakan APAR 6kg');

-- Dumping structure for table csms_db.performance_assessment
CREATE TABLE IF NOT EXISTS `performance_assessment` (
  `assessment_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `assessment_date` timestamp NULL DEFAULT current_timestamp(),
  `score` decimal(5,2) NOT NULL,
  `remarks` text DEFAULT NULL,
  `assessor_user_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`assessment_id`),
  KEY `fk_pa_permit` (`permit_id`),
  KEY `fk_pa_assessor` (`assessor_user_id`),
  CONSTRAINT `fk_pa_assessor` FOREIGN KEY (`assessor_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_pa_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.performance_assessment: ~0 rows (approximately)
INSERT INTO `performance_assessment` (`assessment_id`, `permit_id`, `assessment_date`, `score`, `remarks`, `assessor_user_id`) VALUES
	('ASM-1787027914929', 'WP-001', '2026-08-18 04:38:34', 90.00, 'Ok', 'USR-002');

-- Dumping structure for table csms_db.project_identity
CREATE TABLE IF NOT EXISTS `project_identity` (
  `project_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `project_code` varchar(50) NOT NULL,
  `project_name` varchar(150) NOT NULL,
  `location` varchar(150) NOT NULL,
  PRIMARY KEY (`project_id`),
  KEY `fk_pi_permit` (`permit_id`),
  CONSTRAINT `fk_pi_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.project_identity: ~1 rows (approximately)
INSERT INTO `project_identity` (`project_id`, `permit_id`, `project_code`, `project_name`, `location`) VALUES
	('PRJ-001', 'WP-001', 'PRJ-BLDG-02', 'Pemasangan Piping Jalur B', 'Area Boiler Zone 3');

-- Dumping structure for table csms_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.users: ~3 rows (approximately)
INSERT INTO `users` (`user_id`, `name`, `email`, `role`, `created_at`) VALUES
	('USR-001', 'Budi Santoso', 'budi@contractor.com', 'Contractor Supervisor', '2026-08-18 03:59:59'),
	('USR-002', 'Siti Rahma', 'siti@company.com', 'EHS Officer', '2026-08-18 03:59:59'),
	('USR-003', 'Agus Setiawan', 'agus@company.com', 'Approver Manager', '2026-08-18 03:59:59');

-- Dumping structure for table csms_db.work_permit
CREATE TABLE IF NOT EXISTS `work_permit` (
  `permit_id` varchar(50) NOT NULL,
  `permit_number` varchar(100) NOT NULL,
  `status` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `user_id` varchar(50) DEFAULT NULL,
  `company_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`permit_id`),
  UNIQUE KEY `permit_number` (`permit_number`),
  KEY `fk_wp_user` (`user_id`),
  KEY `fk_wp_company` (`company_id`),
  CONSTRAINT `fk_wp_company` FOREIGN KEY (`company_id`) REFERENCES `contractor_company` (`company_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wp_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.work_permit: ~1 rows (approximately)
INSERT INTO `work_permit` (`permit_id`, `permit_number`, `status`, `created_at`, `user_id`, `company_id`) VALUES
	('WP-001', 'PTW-2026-08-001', 'Approved', '2026-08-18 04:00:00', 'USR-001', 'CMP-001');

-- Dumping structure for table csms_db.work_permit_members
CREATE TABLE IF NOT EXISTS `work_permit_members` (
  `member_id` varchar(50) NOT NULL,
  `permit_id` varchar(50) DEFAULT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `role_on_permit` varchar(50) NOT NULL,
  `assigned_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`member_id`),
  KEY `fk_wpm_permit` (`permit_id`),
  KEY `fk_wpm_user` (`user_id`),
  CONSTRAINT `fk_wpm_permit` FOREIGN KEY (`permit_id`) REFERENCES `work_permit` (`permit_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wpm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table csms_db.work_permit_members: ~1 rows (approximately)
INSERT INTO `work_permit_members` (`member_id`, `permit_id`, `user_id`, `role_on_permit`, `assigned_at`) VALUES
	('MEM-001', 'WP-001', 'USR-001', 'Field Supervisor', '2026-08-18 04:00:00');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
