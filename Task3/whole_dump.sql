/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/* structure.sql */
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


/* triggers_for_log.sql */
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


/* seeder.sql */
LOCK TABLES `employees` WRITE,
`employee_contact_informations` WRITE,
`employee_descriptions` WRITE;

/*
	Employees
*/
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;

INSERT INTO `employees` (`employee_id`, `name`, `ssn`, `active`, `last_updated_author`, `last_updated_ip`, `created_at`, `updated_at`)
VALUES
  (1,'Mikk Pokk','39509166023','yes','Admin@Mikk','127.0.01','2018-09-16 16:25:28','2018-09-16 17:39:20');

/*!40000 ALTER TABLE `employees` ENABLE KEYS */;

/*
	Employee's contact information
*/
/*!40000 ALTER TABLE `employee_contact_informations` DISABLE KEYS */;
INSERT INTO `employee_contact_informations` (`employee_contact_information_id`, `employee_id`, `key`, `value`, `last_updated_author`, `last_updated_ip`, `created_at`, `updated_at`)
VALUES
  (1,1,'email','mikk@internationaleservices.eu','Admin@Mikk','127.0.01','2018-09-16 16:27:08','2018-09-16 17:39:07'),
  (2,1,'phone','+3725261555','Admin@Mikk','127.0.01','2018-09-16 16:27:11','2018-09-16 17:39:10'),
  (3,1,'address','Veerenni 15 - 11, 10135, Tallinn, Harjumaa','Admin@Mikk','127.0.01','2018-09-16 16:27:14','2018-09-16 17:39:10');

/*!40000 ALTER TABLE `employee_contact_informations` ENABLE KEYS */;

/*
	Employee's description
*/
/*!40000 ALTER TABLE `employee_descriptions` DISABLE KEYS */;
INSERT INTO `employee_descriptions` (`employee_description_id`, `employee_id`, `language`, `key`, `value`, `last_updated_author`, `last_updated_ip`, `created_at`, `updated_at`)
VALUES
  (1,1,'en','intro','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.','Admin@Mikk','127.0.01',NOW(),NOW()),
  (2,1,'en','prev_experience','It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).','Admin@Mikk','127.0.01',NOW(),NOW()),
  (3,1,'en','education','Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.\n\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.','Admin@Mikk','127.0.01',NOW(),NOW()),
  (4,1,'es','intro','Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas \"Letraset\", las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.','Admin@Mikk','127.0.01',NOW(),NOW()),
  (5,1,'es','prev_experience','Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo \"Contenido aquí, contenido aquí\". Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de \"Lorem Ipsum\" va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo. Muchas versiones han evolucionado a través de los años, algunas veces por accidente, otras veces a propósito (por ejemplo insertándole humor y cosas por el estilo).','Admin@Mikk','127.0.01',NOW(),NOW()),
  (6,1,'es','education','Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. Tiene sus raices en una pieza cl´sica de la literatura del Latin, que data del año 45 antes de Cristo, haciendo que este adquiera mas de 2000 años de antiguedad. Richard McClintock, un profesor de Latin de la Universidad de Hampden-Sydney en Virginia, encontró una de las palabras más oscuras de la lengua del latín, \"consecteur\", en un pasaje de Lorem Ipsum, y al seguir leyendo distintos textos del latín, descubrió la fuente indudable. Lorem Ipsum viene de las secciones 1.10.32 y 1.10.33 de \"de Finnibus Bonorum et Malorum\" (Los Extremos del Bien y El Mal) por Cicero, escrito en el año 45 antes de Cristo. Este libro es un tratado de teoría de éticas, muy popular durante el Renacimiento. La primera linea del Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", viene de una linea en la sección 1.10.32\n\nEl trozo de texto estándar de Lorem Ipsum usado desde el año 1500 es reproducido debajo para aquellos interesados. Las secciones 1.10.32 y 1.10.33 de \"de Finibus Bonorum et Malorum\" por Cicero son también reproducidas en su forma original exacta, acompañadas por versiones en Inglés de la traducción realizada en 1914 por H. Rackham.','Admin@Mikk','127.0.01',NOW(),NOW()),
  (7,1,'fr','intro','Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.','Admin@Mikk','127.0.01',NOW(),NOW()),
  (8,1,'fr','prev_experience','On sait depuis longtemps que travailler avec du texte lisible et contenant du sens est source de distractions, et empêche de se concentrer sur la mise en page elle-même. L\'avantage du Lorem Ipsum sur un texte générique comme \'Du texte. Du texte. Du texte.\' est qu\'il possède une distribution de lettres plus ou moins normale, et en tout cas comparable avec celle du français standard. De nombreuses suites logicielles de mise en page ou éditeurs de sites Web ont fait du Lorem Ipsum leur faux texte par défaut, et une recherche pour \'Lorem Ipsum\' vous conduira vers de nombreux sites qui n\'en sont encore qu\'à leur phase de construction. Plusieurs versions sont apparues avec le temps, parfois par accident, souvent intentionnellement (histoire d\'y rajouter de petits clins d\'oeil, voire des phrases embarassantes).','Admin@Mikk','127.0.01',NOW(),NOW()),
  (9,1,'fr','education','Contrairement à une opinion répandue, le Lorem Ipsum n\'est pas simplement du texte aléatoire. Il trouve ses racines dans une oeuvre de la littérature latine classique datant de 45 av. J.-C., le rendant vieux de 2000 ans. Un professeur du Hampden-Sydney College, en Virginie, s\'est intéressé à un des mots latins les plus obscurs, consectetur, extrait d\'un passage du Lorem Ipsum, et en étudiant tous les usages de ce mot dans la littérature classique, découvrit la source incontestable du Lorem Ipsum. Il provient en fait des sections 1.10.32 et 1.10.33 du \"De Finibus Bonorum et Malorum\" (Des Suprêmes Biens et des Suprêmes Maux) de Cicéron. Cet ouvrage, très populaire pendant la Renaissance, est un traité sur la théorie de l\'éthique. Les premières lignes du Lorem Ipsum, \"Lorem ipsum dolor sit amet...\", proviennent de la section 1.10.32.\n\nL\'extrait standard de Lorem Ipsum utilisé depuis le XVIè siècle est reproduit ci-dessous pour les curieux. Les sections 1.10.32 et 1.10.33 du \"De Finibus Bonorum et Malorum\" de Cicéron sont aussi reproduites dans leur version originale, accompagnée de la traduction anglaise de H. Rackham (1914).\n','Admin@Mikk','127.0.01',NOW(),NOW());

/*!40000 ALTER TABLE `employee_descriptions` ENABLE KEYS */;
UNLOCK TABLES;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
