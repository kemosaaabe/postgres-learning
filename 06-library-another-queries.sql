SELECT 
	id AS entitity_id,
	name AS entity_name,
	'reader' AS entity_type
FROM readers
UNION ALL
SELECT
	id,
	title,
	'book'
FROM books
ORDER BY entity_type;
	

SELECT
	id AS book_id,
	title,
	count AS stock,
	CASE 
		WHEN count = 0 THEN 'out_of_stock'
		WHEN count <= 3 THEN 'low_stock'
		ELSE 'available'
	END AS stock_status
FROM books
ORDER BY
	CASE
		WHEN count = 0 THEN 0
		WHEN count <= 3 THEN 1
		ELSE 2
	END,
	title;


WITH readers_stats AS (
	SELECT
		r.id AS reader_id,
		r.name,
		(
			SELECT MAX(issue_date)
			FROM loans AS l
			WHERE r.id = l.reader_id 
		) AS last_loan_date
	FROM readers AS r
)
SELECT
	reader_id,
	name,
	last_loan_date,
	COALESCE(current_date - last_loan_date, 0) AS days_since_last_loan
FROM readers_stats
ORDER BY reader_id;


SELECT
	r.id AS reader_id,
	r.name,
	max(l.issue_date) AS last_loan_date,
	COALESCE(CURRENT_DATE - max(l.issue_date), 0) AS days_since_last_loan
FROM readers AS r
LEFT JOIN loans AS l
	 ON l.reader_id  = r.id
GROUP BY r.id
ORDER BY reader_id;


SELECT
	r.id AS reader_id,
	r.name,
	last_value(l.issue_date) OVER(
		PARTITION BY r.id
		ORDER BY issue_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS last_loan_date,
	COALESCE(l.issue_date - lag(l.issue_date) OVER(
		PARTITION BY r.id
		ORDER BY l.issue_date, l.id
	), 0) AS days_since_last_loan
FROM readers AS r
LEFT JOIN loans AS l 
	ON r.id = l.reader_id;