/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*
	Employees trigger
*/
DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `INSERT employees log` AFTER INSERT ON `employees` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employees', NEW.employee_id, 'created', NULL, NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `UPDATE employees log` AFTER UPDATE ON `employees` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employees', NEW.employee_id, 'modified', json_object('name', OLD.name, 'ssn', OLD.ssn, 'active', OLD.active, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `DELETE employees log` AFTER DELETE ON `employees` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(OLD.last_updated_author, OLD.last_updated_ip, 'employees', OLD.employee_id, 'deleted', json_object('name', OLD.name, 'ssn', OLD.ssn, 'active', OLD.active, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


/*
	Employee's contact information trigger
*/
DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `INSERT employee_contact_informations log` AFTER INSERT ON `employee_contact_informations` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employee_contact_informations', NEW.employee_contact_information_id, 'created', NULL, NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `UPDATE employee_contact_informations log` AFTER UPDATE ON `employee_contact_informations` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employee_contact_informations', NEW.employee_contact_information_id, 'modified', json_object('key', OLD.key, 'value', OLD.value, 'employee_id', OLD.employee_id, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `DELETE employee_contact_informations log` AFTER DELETE ON `employee_contact_informations` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(OLD.last_updated_author, OLD.last_updated_ip, 'employee_contact_informations', OLD.employee_contact_information_id, 'deleted', json_object('key', OLD.key, 'value', OLD.value, 'employee_id', OLD.employee_id, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


/*
	Employee's description trigger
*/
DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `INSERT employee_descriptions log` AFTER INSERT ON `employee_descriptions` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employee_descriptions', NEW.employee_description_id, 'created', NULL, NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `UPDATE eployee_descriptions log` AFTER UPDATE ON `employee_descriptions` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(NEW.last_updated_author, NEW.last_updated_ip, 'employee_descriptions', NEW.employee_description_id, 'modified', json_object('key', OLD.key, 'value', OLD.value, 'lang', OLD.language, 'employee_id', OLD.employee_id, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
	/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `DELETE employee_descriptions log` AFTER DELETE ON `employee_descriptions` FOR EACH ROW INSERT INTO `entry_logs` (`author`, `ip`, `table`, `table_reference_id`, `type`, `data_before`, `created_at`)
VALUES
	(OLD.last_updated_author, OLD.last_updated_ip, 'employee_descriptions', OLD.employee_description_id, 'deleted', json_object('key', OLD.key, 'value', OLD.value, 'lang', OLD.language, 'employee_id', OLD.employee_id, 'updated_at', OLD.updated_at, 'created_at', OLD.created_at), NOW()) */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
