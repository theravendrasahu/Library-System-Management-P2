--SQL PROJECT - LIBRARY MANAGERMENT SYSTEM DAY 2

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
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



