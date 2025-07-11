--SQL PROJECT - LIBRARY MANAGERMENT SYSTEM DAY 2

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status
where issued_id = 'IS135';
SELECT * FROM members;

/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's
name, book title, issue date, and days overdue.
*/


-- issued_status = members == book == return_status
-- filter books which is return
-- if overdue >30

SELECT 
		mb.member_id,
		mb.member_name,
		bk.book_title,
		ist.issued_date,
		(CURRENT_DATE - ist.issued_date) AS over_dues
FROM issued_status as ist
JOIN books as bk
ON ist.issued_book_isbn = bk.isbn
JOIN members as mb
ON ist.issued_member_id = mb.member_id
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
	rs.return_date IS NULL
	AND CURRENT_DATE - ist.issued_date >30;

/*
**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes"
when they are returned (based on entries in the return_status table).
*/

--STORE PROCEDURES 
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

CALL add_return_records('RS152', 'IS135', 'GOOD')

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

SELECT * FROM branch;

SELECT * FROM issued_status;

SELECT * FROM employees;

SELECT * FROM books;

SELECT * FROM return_status;

SELECT b.branch_id, count(ist.issued_id) as books_issued, count(rs.issued_id) as books_return
FROM branch as b
JOIN employees AS e
ON e.branch_id = b.branch_id
JOIN issued_status as ist
ON ist.issued_emp_id = e.emp_id
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
GROUP BY 1
ORDER BY 2 DESC, 3;

/*
**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table 
active_members containing members who have issued at least one book in the last 2 months.
*/
CREATE TABLE active_members
AS
SELECT DISTINCT ist.issued_member_id
FROM members as m
JOIN issued_status as ist
ON ist.issued_member_id = m.member_id
WHERE ist.issued_date >= CURRENT_DATE - INTERVAL '2 MONTH';

SELECT * FROM active_members;

/*
Task 17: Find Employees with the Most Book Issues Processed  
Write a query to find the top 3 employees who have processed 
the most book issues. Display the employee name, number of books processed, and their branch.
*/


SELECT ist.issued_emp_id, e.emp_name, e.branch_id,  count(ist.issued_id) as total_books_issued
FROM employees as e
JOIN issued_status AS ist
ON ist.issued_emp_id = e.emp_id
GROUP BY 1, 2, 3
ORDER BY count(ist.issued_id) DESC
LIMIT 3;


/* Task 18: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have
issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines  */
CREATE TABLE overdue_books_fines AS
SELECT 
    m.member_id,
    COUNT(CASE 
             WHEN rst.return_date IS NULL 
                  AND ist.issued_date <= CURRENT_DATE - INTERVAL '30 days' 
             THEN 1 
          END) AS overdue_books,
    SUM(CASE 
             WHEN rst.return_date IS NULL 
                  AND ist.issued_date <= CURRENT_DATE - INTERVAL '30 days' 
             THEN 0.50 * (CURRENT_DATE - ist.issued_date - 30) 
        END) AS total_fines
FROM issued_status ist
JOIN members m ON m.member_id = ist.issued_member_id
LEFT JOIN return_status rst ON rst.issued_id = ist.issued_id
GROUP BY m.member_id
ORDER BY overdue_books DESC;

select * from overdue_books_fines


/* Task 19: Stored Procedure
Objective: Create a stored procedure to manage the status of books in a library system.
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.

The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message
indicating that the book is currently not available.IDENTITY
*/


SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM return_status;



CREATE OR REPLACE PROCEDURE books_issued(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(50), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$
DECLARE
		v_status VARCHAR(10);
		v_book_name VARCHAR(80);
BEGIN

	SELECT 
        status,
		book_title
        INTO
        v_status,
		v_book_name
    FROM books
    WHERE isbn = p_issued_book_isbn;
	
	IF
		v_status = 'yes' THEN
			INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
			VALUES (p_issued_id, p_issued_member_id, v_book_name, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

			UPDATE books
			SET status = 'no'
			WHERE isbn = p_issued_book_isbn;

			RAISE NOTICE 'Thank you for issued the book: %', v_book_name;
	
		ELSE 
			RAISE NOTICE 'Sorry to inform you that book is unavilable: %', v_book_name;
	END IF;
END;
$$


-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL books_issued('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL books_issued('IS156', 'C108', '978-0-375-41398-8', 'E104');


SELECT * FROM books
WHERE isbn = '978-0-553-29698-2'

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'



