# Create database
```
CREATE DATABASE `test_task_3`
```

# Import

### Option 1: using 3 separate files
1. structure.sql
2. triggers_for_log.sql **(MySQL 5.7.8+ required)**
3. seeder.sql

### Option 2: using one import file
1. Import: whole_dump.sql **(MySQL 5.7.8+ required)**




# Write example *query* to get 1-person data in all languages


### Example 1: To get result as 1 row
```
SELECT
	`e`.`employee_id`, `e`.`name`, `e`.`ssn`, `e`.`active`,
	`eci1`.`value` as `email`,
	`eci2`.`value` as `phone`,
	`eci3`.`value` as `address`,
	`ed1`.`value` as `intro_en`,
	`ed2`.`value` as `prev_experience_en`,
	`ed3`.`value` as `education_en`,
	`ed4`.`value` as `intro_es`,
	`ed5`.`value` as `prev_experience_es`,
	`ed6`.`value` as `education_es`,
	`ed7`.`value` as `intro_fr`,
	`ed8`.`value` as `prev_experience_fr`,
	`ed9`.`value` as `education_fr`
FROM `employees` `e`
	LEFT JOIN `employee_contact_informations` `eci1` ON `eci1`.`employee_id` = `e`.`employee_id` AND `eci1`.`key` = 'email'
	LEFT JOIN `employee_contact_informations` `eci2` ON `eci2`.`employee_id` = `e`.`employee_id` AND `eci2`.`key` = 'phone'
	LEFT JOIN `employee_contact_informations` `eci3` ON `eci3`.`employee_id` = `e`.`employee_id` AND `eci3`.`key` = 'address'

	LEFT JOIN `employee_descriptions` `ed1` ON `ed1`.`employee_id` = `e`.`employee_id` AND `ed1`.`key` = 'intro' AND `ed1`.`language`='en'
	LEFT JOIN `employee_descriptions` `ed2` ON `ed2`.`employee_id` = `e`.`employee_id` AND `ed2`.`key` = 'prev_experience' AND `ed2`.`language`='en'
	LEFT JOIN `employee_descriptions` `ed3` ON `ed3`.`employee_id` = `e`.`employee_id` AND `ed3`.`key` = 'education' AND `ed3`.`language`='en'

	LEFT JOIN `employee_descriptions` `ed4` ON `ed4`.`employee_id` = `e`.`employee_id` AND `ed4`.`key` = 'intro' AND `ed4`.`language`='es'
	LEFT JOIN `employee_descriptions` `ed5` ON `ed5`.`employee_id` = `e`.`employee_id` AND `ed5`.`key` = 'prev_experience' AND `ed5`.`language`='es'
	LEFT JOIN `employee_descriptions` `ed6` ON `ed6`.`employee_id` = `e`.`employee_id` AND `ed6`.`key` = 'education' AND `ed6`.`language`='es'

	LEFT JOIN `employee_descriptions` `ed7` ON `ed7`.`employee_id` = `e`.`employee_id` AND `ed7`.`key` = 'intro' AND `ed7`.`language`='fr'
	LEFT JOIN `employee_descriptions` `ed8` ON `ed8`.`employee_id` = `e`.`employee_id` AND `ed8`.`key` = 'prev_experience' AND `ed8`.`language`='fr'
	LEFT JOIN `employee_descriptions` `ed9` ON `ed9`.`employee_id` = `e`.`employee_id` AND `ed9`.`key` = 'education' AND `ed9`.`language`='fr'
LIMIT 1
```

### Example 2: To get user's descriptions as multiple rows
```
SELECT
	`e`.`employee_id`, `e`.`name`, `e`.`ssn`, `e`.`active`,
	`eci1`.`value` as `email`,
	`eci2`.`value` as `phone`,
	`eci3`.`value` as `address`,
	`ed`.`key` as `description_key`,
	`ed`.`value` as `description_value`,
	`ed`.`language` as `description_language`
FROM `employees` `e`
	LEFT JOIN `employee_contact_informations` `eci1` ON `eci1`.`employee_id` = `e`.`employee_id` AND `eci1`.`key` = 'email'
	LEFT JOIN `employee_contact_informations` `eci2` ON `eci2`.`employee_id` = `e`.`employee_id` AND `eci2`.`key` = 'phone'
	LEFT JOIN `employee_contact_informations` `eci3` ON `eci3`.`employee_id` = `e`.`employee_id` AND `eci3`.`key` = 'address'

	LEFT JOIN `employee_descriptions` `ed` ON `ed`.`employee_id` = `e`.`employee_id`
WHERE `e`.`employee_id`=1
```
