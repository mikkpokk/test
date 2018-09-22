/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*
	Employees
*/
DROP TABLE IF EXISTS `employees`;

CREATE TABLE `employees` (
  `employee_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL DEFAULT '',
  `ssn` varchar(20) NOT NULL DEFAULT '' COMMENT 'ID code / SSN',
  `active` enum('yes','no') NOT NULL DEFAULT 'yes',
  `last_updated_author` varchar(40) NOT NULL DEFAULT 'SQL Import',
  `last_updated_ip` varchar(45) NOT NULL DEFAULT 'N/A',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*
	Employee's contact information
*/
DROP TABLE IF EXISTS `employee_contact_informations`;

CREATE TABLE `employee_contact_informations` (
  `employee_contact_information_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) unsigned NOT NULL,
  `key` varchar(30) NOT NULL DEFAULT '',
  `value` varchar(250) DEFAULT NULL,
  `last_updated_author` varchar(40) NOT NULL DEFAULT 'SQL Import',
  `last_updated_ip` varchar(45) NOT NULL DEFAULT 'N/A',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_contact_information_id`),
  UNIQUE KEY `employee_id_key_unique` (`employee_id`,`key`),
  KEY `employee_id_index` (`employee_id`),
  CONSTRAINT `employee_id_foreign_eci` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*
	Employee's description
*/
DROP TABLE IF EXISTS `employee_descriptions`;

CREATE TABLE `employee_descriptions` (
  `employee_description_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) unsigned NOT NULL,
  `language` varchar(2) NOT NULL DEFAULT 'en',
  `key` varchar(20) NOT NULL DEFAULT '',
  `value` text,
  `last_updated_author` varchar(40) NOT NULL DEFAULT 'SQL Import',
  `last_updated_ip` varchar(45) NOT NULL DEFAULT 'N/A',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_description_id`),
  UNIQUE KEY `employee_id_key_language_unique` (`employee_id`,`key`,`language`),
  KEY `employee_id_index` (`employee_id`),
  CONSTRAINT `employee_id_foreign_ed` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*
	Table for logging
*/
DROP TABLE IF EXISTS `entry_logs`;

CREATE TABLE `entry_logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author` varchar(40) NOT NULL DEFAULT '',
  `ip` varchar(45) DEFAULT NULL,
  `table` varchar(40) NOT NULL DEFAULT '',
  `table_reference_id` int(11) NOT NULL,
  `type` enum('created','modified','deleted') DEFAULT NULL,
  `data_before` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
