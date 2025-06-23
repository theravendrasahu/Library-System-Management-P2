SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;

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
