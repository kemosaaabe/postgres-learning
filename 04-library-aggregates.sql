SELECT 
	id AS reader_id,
	name AS reader_name
FROM readers AS r
WHERE NOT EXISTS (
	SELECT 1
	FROM loans AS l
	WHERE r.id = l.reader_id 
		AND l.return_date  IS NULL
)
ORDER BY id;


SELECT 
	r.id AS reader_id,
	r.name,
	(
		SELECT 
			count(*)
		FROM loans AS l
		WHERE l.reader_id = r.id
			AND l.return_date  IS NULL
	) AS active_loans
FROM readers AS r
ORDER BY active_loans DESC, reader_id;


SELECT
	published_year,
	books_total.total_stock
FROM (
	SELECT 
		published_year,
		sum(count) AS total_stock
	FROM books
	GROUP BY published_year
) AS books_total
WHERE books_total.total_stock > 5;


SELECT
	id AS book_id,
	title,
	published_year,
	count
FROM books AS b1
WHERE count > (
	SELECT avg(b2.count)
	FROM books AS b2
	WHERE b1.published_year  = b2.published_year 
)
	AND published_year IS NOT NULL
ORDER BY published_year DESC, count DESC;


SELECT
	id AS reader_id,
	name AS reader_name
FROM readers AS r
WHERE EXISTS (
	SELECT 1
	FROM loans AS l
	WHERE r.id = l.reader_id
		AND l.return_date  IS NULL
)
ORDER BY id;


SELECT
	id AS book_id,
	title
FROM books AS b
WHERE NOT EXISTS (
	SELECT 1
	FROM loans AS l
	WHERE b.id = l.book_id 
)
ORDER BY id;


SELECT 
	id AS book_id,
	title,
	count
FROM books
WHERE count > (
	SELECT avg(count)
	FROM books
)
ORDER BY count DESC;


SELECT 
	id AS book_id,
	title
FROM books
WHERE id IN (
	SELECT book_id
	FROM loans
);


SELECT 
	b.published_year,
	count(DISTINCT b.id) AS books_count,
	count(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l
	ON b.id = l.book_id
WHERE b.published_year IS NOT NULL
GROUP BY b.published_year
HAVING count(DISTINCT b.id) >= 2
	AND count(l.id) >= 4
ORDER BY loans_count DESC;	


SELECT 
	r.id AS reader_id,
	r.name AS reader_name,
	count(l.id) AS loans_count
FROM readers AS r
JOIN loans AS l
	ON l.reader_id  = r.id
WHERE l.issue_date >= DATE '2026-09-01'
GROUP BY r.id
HAVING count(l.id) >= 3
ORDER BY loans_count DESC;


SELECT 
	b.id AS book_id,
	b.title,
	count(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l
	ON b.id = l.book_id
GROUP BY b.id
HAVING count(l.id) >=3
ORDER BY loans_count DESC;


SELECT 
	b.published_year,
	count(DISTINCT b.id) AS books_count,
	count(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l
	ON b.id = l.book_id
WHERE b.published_year IS NOT NULL
GROUP BY b.published_year
ORDER BY b.published_year DESC;


SELECT 
	b.id AS book_id,
	b.title,
	count(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l
	ON l.book_id = b.id
GROUP BY b.id
ORDER BY loans_count DESC, book_id ASC;


SELECT
	r.name AS reader_name,
	b.title AS book_title,
	l.issue_date AS issue_date
FROM books AS b
JOIN loans AS l
	ON b.id = l.book_id
JOIN readers AS r
	ON l.reader_id = r.id
WHERE l.return_date IS NULL
ORDER BY issue_date DESC;


SELECT 
	b.id AS book_id,
	title,
	count(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l
	ON l.book_id = b.id
GROUP BY b.id
ORDER BY loans_count DESC;


SELECT
	r.name AS reader_name,
	b.title AS book_title,
	l.issue_date AS issue_date,
	l.return_date AS return_date
FROM loans AS l
JOIN readers AS r
	ON r.id = l.reader_id
JOIN books AS b
	ON b.id = l.book_id
ORDER BY issue_date DESC;


SELECT	
	r.id AS reader_id,
	r.name,
	count(l.id) AS louns_count
FROM readers AS r
LEFT JOIN loans AS l
	ON l.reader_id = r.id
GROUP BY r.id
ORDER BY louns_count DESC;


SELECT 
	count(DISTINCT title) AS unique_titles, 
	sum(count) AS books_count,
	avg(count) AS avg_count
FROM books;

SELECT 
	count(published_year),
	count(DISTINCT published_year),
	min(published_year),
	max(published_year)
FROM books;

SELECT
	avg(count),
	min(count),
	max(count)
FROM books
WHERE published_year >= 2010
	AND count > 0;
	
SELECT * FROM books;

SELECT 
	published_year,
	SUM(count) AS books_count,
	count(*) AS titles_count
FROM books
WHERE published_year IS NOT null
GROUP BY published_year
ORDER BY published_year DESC;

SELECT
	published_year,
	sum(count) AS books_count
FROM books
GROUP BY published_year
HAVING sum(count) > 4
ORDER BY books_count DESC;

SELECT 
	published_year,
	count(*),
	avg(count) AS avg_count
FROM books
WHERE count > 0
GROUP BY published_year
HAVING count(*) >= 2;

