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

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;

--2. CRUD Operations
- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.


--Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
--Task 2: Update an Existing Member's Address for member C103 to address this 125 Oak St

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

--Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE  issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E107'
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E107'

--Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.\
SELECT * FROM issued_status;

SELECT issued_member_id, COUNT(issued_id) AS issued_books_count
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) >1;

--3. CTAS (Create Table As Select)

--Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**




