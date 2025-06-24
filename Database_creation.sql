-- 1. Database Setup
CREATE DATABASE library_project;

--Create Library managerment system
--Create books tables
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
	isbn VARCHAR(50) PRIMARY KEY,
	book_title VARCHAR(80),
	category VARCHAR(30),
	rental_price DECIMAL(10, 2),
	status VARCHAR(10),
	author VARCHAR(25),
	publisher VARCHAR(30)
);

--Create branch tables
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
	branch_id VARCHAR(10) PRIMARY KEY, --FK
	manager_id VARCHAR(10),
	branch_address VARCHAR(30),
	contact_no VARCHAR(15)
);

--Create employees tables
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
	emp_id	  VARCHAR(10) PRIMARY KEY,
	emp_name  VARCHAR(30),
	position  VARCHAR(30),
	salary    DECIMAL(10,2),
	branch_id VARCHAR(10)	--FK
);

--Create members tables
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(20),
	member_address VARCHAR(20),
	reg_date DATE
);
--Create issued_status tables
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
	issued_id	  VARCHAR(10) PRIMARY KEY,
	issued_member_id  VARCHAR(30), --FK
	issued_book_name  VARCHAR(80),
	issued_date    DATE,
	issued_book_isbn VARCHAR(50), --FK
	issued_emp_id VARCHAR(10) --FK
);

--Create return_status tables
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(	
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10), --FK
	return_book_name VARCHAR(10),
	return_date DATE,
	return_book_isbn VARCHAR(10) --FK
);

--ADDING THE FOREIGN KEYS
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_status
FOREIGN KEY (return_book_isbn)
REFERENCES books(isbn);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

