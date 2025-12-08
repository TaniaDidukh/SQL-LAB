DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

CREATE TABLE IF NOT EXISTS `employee` (
	`employee_id` int NOT NULL,
	`user_name` varchar(30) NOT NULL,
	`first_name` varchar(30) NOT NULL,
	`last_name` varchar(30) NOT NULL,
	`position` varchar(30) NOT NULL,
	`employment_date` date NOT NULL,
	`department_id` int,
	`manager_id` int,
	`rate` float NOT NULL,
	`bonus` float,
	PRIMARY KEY (`employee_id`)
);

CREATE TABLE IF NOT EXISTS `department` (
	`department_id` int NOT NULL,
	`department_name` varchar(30) NOT NULL,
	`city` varchar(30) NOT NULL,
	`street` varchar(50) NOT NULL,
	`building_no` int(4),
	PRIMARY KEY (`department_id`)
);

CREATE TABLE IF NOT EXISTS `product` (
	`product_id` int NOT NULL,
	`product_name` varchar(40) NOT NULL,
	`product_description` varchar(150) NOT NULL,
	`category` varchar(15) NOT NULL,
	`manufacture` varchar(30) NOT NULL,
	`product_type` varchar(15) NOT NULL,
	`amount` int NOT NULL,
	`price` float NOT NULL,
	PRIMARY KEY (`product_id`)
);

CREATE TABLE IF NOT EXISTS `customer` (
	`customer_id` int AUTO_INCREMENT NOT NULL,
	`first_name` varchar(30) NOT NULL,
	`last_name` varchar(30) NOT NULL,
	`gender` varchar(1) NOT NULL,
	`birth_date` date NOT NULL,
	`phone_number` BIGINT(15) NOT NULL,
	`email` varchar(50) NOT NULL,
	`discount` int NOT NULL,
	PRIMARY KEY (`customer_id`)
);

CREATE TABLE IF NOT EXISTS `orders` (
	`orders_id` int AUTO_INCREMENT NOT NULL,
	`product_id` int NOT NULL,
    `invoice_id` bigint(15) NOT NULL,
	`order_datetime` DATETIME NOT NULL,
	`quantity` INT NOT NULL,
	PRIMARY KEY (`orders_id`)
);
 CREATE TABLE IF NOT EXISTS `invoice` (
 `invoice_id` bigint(15) NOT NULL,
 `employee_id` INT NOT NULL,
 `customer_id` INT,
 `payment_method` INT NOT NULL,
 `transaction_moment` DATETIME NOT NULL,
 `status` varchar(10) NOT NULL,
  PRIMARY KEY (`invoice_id`)
 );

ALTER TABLE `employee` ADD CONSTRAINT `employee_fk6` FOREIGN KEY (`department_id`) REFERENCES `department`(`department_id`);

ALTER TABLE `employee` ADD CONSTRAINT `employee_fk7` FOREIGN KEY (`manager_id`) REFERENCES `employee`(`employee_id`);




ALTER TABLE `orders` ADD CONSTRAINT `orders_fk2` FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`);

ALTER TABLE `orders` ADD CONSTRAINT `orders_fk4` FOREIGN KEY (`invoice_id`) REFERENCES `invoice`(`invoice_id`);

ALTER TABLE `invoice` ADD CONSTRAINT `invoice_fk1` FOREIGN KEY (`employee_id`) REFERENCES `employee`(`employee_id`);

ALTER TABLE `invoice` ADD CONSTRAINT `invoice_fk2` FOREIGN KEY (`customer_id`) REFERENCES `customer`(`customer_id`);

ALTER TABLE `employee` ADD UNIQUE (`user_name`);

ALTER TABLE `department` ALTER COLUMN `city` SET DEFAULT 'Lviv';

SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM invoice;
SELECT * FROM orders;

USE company;
SELECT *
FROM employee;

SELECT employee_id, first_name, last_name, position
FROM employee
LIMIT 7;
SELECT DISTINCT position
FROM employee
ORDER By position ASC;

SELECT employee_id, last_name, first_name, position, employment_date
FROM employee
WHERE position = 'Seller'
ORDER By employment_date ASC;

SELECT employee_id, last_name, first_name, position, employment_date
FROM employee
WHERE (position = 'Seller' OR position = 'Consultant') 
AND employment_date > '2013-01-01' 
ORDER BY employment_date DESC;

-- solution 1
SELECT last_name, first_name, position, employment_date
FROM employee
WHERE (position LIKE 'Seller' OR position IN ('Senior Consultant','Consultant'))
AND employment_date > '2013-01-01'
ORDER By employment_date DESC;

SELECT last_name, first_name, position, employment_date, bonus
FROM employee
WHERE manager_id IS NULL
OR department_id IS NOT NULL
ORDER BY manager_id ASC;

SELECT last_name, first_name, position, employment_date, bonus
FROM employee
WHERE bonus IS NOT NULL
AND ( employment_date > '2015-12-31' and employment_date < '2020-12-31' )
ORDER BY last_name ASC;

SELECT last_name, first_name, position,
CASE
WHEN position = 'Senior Consultant' THEN 'Can Seles, Consulting and Lead'
WHEN position IN ('Senior Consultant', 'Consultant') THEN 'Can Seles and Consulting' 
WHEN position like 'Assistant Consultant' THEN 'Can only Consulting'
WHEN position LIKE 'Seller' THEN 'Can only Sale' ELSE 'Service Roles'
END AS 'Relation to Customer'
FROM employee
ORDER By last_name;

SELECT last_name "Last Name", first_name 'First Name', position Title, 
employment_date AS 'Hire Date'
From employee;

-- homework
-- Показати всіх клієнті відсортувати за прізвищем
SELECT *
FROM customer
ORDER BY last_name ASC;

-- Унікальні назви виробників (manufacture) за алфавітом
SELECT DISTINCT manufacture
FROM product
ORDER BY manufacture ASC;

-- інформація про продукти DELL,  за назвою продукту
SELECT product_name, manufacture, category, product_type, price
FROM product
WHERE manufacture = 'DELL'
ORDER BY product_name ASC;

-- Інформація про клієнток 1990- 2000 років за прізвищем
SELECT first_name, last_name, gender, birth_date, phone_number
FROM customer
WHERE gender = 'F'
  AND birth_date BETWEEN '1990-01-01' AND '2000-12-31'
ORDER BY last_name ASC;

-- 4. Наявні ноутбуки з диском 512 ГБ
SELECT *
FROM product
WHERE category = 'NOTEBOOK'
  AND product_description LIKE '%512GB%'
AND amount > 0;

-- 5 Наявні ноутбуки або ПК з диском 512 ГБ або 1 ТБ
SELECT *
FROM product
WHERE (category = 'NOTEBOOK' OR category = 'Desktop')
  AND (product_description LIKE '%512GB%' OR product_description LIKE '%1TB%');
  
  -- Усі покупки неавторизованих клієнтів (customer_id = NULL)
SELECT *
FROM invoice
WHERE customer_id IS NULL;
-- 1) Список всіх замовлених товарів, клієнтів та момент транзакції 
USE company;
SELECT 
    o.orders_id AS 'Orders ID',
    p.product_name AS 'Product name',
    p.category AS 'Product category',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction moment',
    c.last_name AS 'Customer last name',
    c.first_name AS 'Customer first name'
FROM orders o
JOIN product p ON o.product_id = p.product_id
JOIN invoice i ON o.invoice_id = i.invoice_id
JOIN customer c ON i.customer_id = c.customer_id
ORDER BY o.orders_id;

-- 2) Товари, замовлені через відділ меркурій за період 07.01-10ю01
USE company;
SELECT 
    o.orders_id AS 'Orders ID',
    p.product_name AS 'Product name',
    p.category AS 'Product category',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction moment',
    c.last_name AS 'Customer last name',
    c.first_name AS 'Customer first name'
FROM orders o
JOIN product p ON o.product_id = p.product_id
JOIN invoice i ON o.invoice_id = i.invoice_id
LEFT JOIN customer c ON i.customer_id = c.customer_id
JOIN employee e ON i.employee_id = e.employee_id
JOIN department d ON e.department_id = d.department_id
WHERE d.department_name = 'Mercury'  
  AND i.transaction_moment BETWEEN '2023-07-01' AND '2023-10-01'
ORDER BY o.orders_id;

-- 3) Клієнти і замовлення включаючи клієнтів без замовлень і наоборот
USE company;
SELECT 
    c.customer_id AS 'Customer ID',
    c.last_name AS 'Last Name',
    c.first_name AS 'First Name',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction Moment'
FROM customer c
LEFT JOIN invoice i ON c.customer_id = i.customer_id
UNION
SELECT 
    c.customer_id AS 'Customer ID',
    c.last_name AS 'Last Name',
    c.first_name AS 'First Name',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction Moment'
FROM customer c
RIGHT JOIN invoice i ON c.customer_id = i.customer_id
WHERE c.customer_id IS NULL
ORDER BY `Invoice ID`;
-- 1) Інформація про товари
USE company;
SELECT 
    LPAD(product_id, 4, '0') AS 'Product ID',
    CONCAT(manufacture, ':: ', product_name) AS 'Product Name',
    UPPER(CONCAT(product_type, ' - ', category)) AS 'Category'
FROM product
ORDER BY manufacture;

-- 2) Продажі по місяцях 
SELECT 
    LPAD(MONTH(i.transaction_moment), 2, '0') AS 'Month',
    FORMAT(SUM(o.quantity * p.price), 2) AS 'Total revenue',
    CONCAT('Quater ', QUARTER(i.transaction_moment), '-', YEAR(i.transaction_moment)) AS 'Sales Period'
FROM orders o
JOIN invoice i ON o.invoice_id = i.invoice_id
JOIN product p ON o.product_id = p.product_id
GROUP BY 
    YEAR(i.transaction_moment), 
    MONTH(i.transaction_moment),
    `Month`, 
    `Sales Period`
ORDER BY YEAR(i.transaction_moment), MONTH(i.transaction_moment);

-- 3.1) Товари з доходом більше 50 000 
SELECT 
    LPAD(p.product_id, 4, '0') AS 'Product ID',
    p.product_name AS 'Product name',
    p.price AS 'Product Price',
    SUM(o.quantity) AS 'Product Quantity',
    FORMAT(SUM(o.quantity * p.price), 2) AS 'Total Amount'
FROM product p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.price
HAVING SUM(o.quantity * p.price) > 50000
ORDER BY SUM(o.quantity * p.price) DESC;

-- 3.2) Топ-10 клієнтів
SELECT 
    LPAD(c.customer_id, 3, '0') AS 'Customer ID',
    c.last_name AS 'Customer last name',
    c.first_name AS 'Customer first name',
    FORMAT(SUM(o.quantity * p.price), 2) AS 'Total Amount'
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN orders o ON i.invoice_id = o.invoice_id
JOIN product p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.last_name, c.first_name
ORDER BY SUM(o.quantity * p.price) DESC
LIMIT 10;