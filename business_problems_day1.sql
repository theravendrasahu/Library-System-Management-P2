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
--Task 6: Create Summary Tables
-- Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_cnts
AS
SELECT  b.isbn, b.book_title, COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

-- Task 7. **Retrieve All Books in a Specific Category**:
SELECT * FROM books
WHERE category = 'Classic'

-- 8. **Task 8: Find Total Rental Income by Category**:
SELECT  b.category , SUM(b.rental_price), COUNT(*) 
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1


-- 9. **List Members Who Registered in the Last 180 Days**:
SELECT * FROM members
WHERE reg_Date >= CURRENT_DATE- INTERVAL '180 days'
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C150', 'sam', '145 Main St', '2025-06-01'),
('C159', 'Aam', '5005 Main St', '2025-05-01')


-- 10. **List Employees with Their Branch Manager's Name and their branch details**:
SELECT e1.*, 
		e2.emp_name as manger,
		b.manager_id
FROM branch as b
join employees as e1
on b.branch_id = e1.branch_id
join employees as e2
on b.manager_id = e2.emp_id 

SELECT * FROM employees
SELECT * FROM branch

SELECT e.emp_name, b.manager_id


-- Task 11. **Create a Table of Books with Rental Price Above a 7USD
CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM books
WHERE rental_price > 7

--Task 12: **Retrieve the List of Books Not Yet Returned**
SELECT * FROM issued_status
SELECT * FROM return_status

SELECT 
		DISTINCT i.issued_book_isbn
FROM issued_status AS i
LEFT JOIN return_status AS r
ON i.issued_id= r.issued_id
WHERE r.return_id IS NULL;




