SELECT
	r.id AS reader_id,
	r.name,
	count(l.id) AS total_loans,
	count(l.id) FILTER(
		WHERE l.return_date IS NULL
	) AS active_loans,
	count(l.id) FILTER(
		WHERE l.return_date IS NOT NULL
	) AS returned_loans
FROM readers AS r
LEFT JOIN loans AS l
	ON r.id = l.reader_id
GROUP BY r.id
ORDER BY reader_id;


WITH library_aggregate_stats AS (
	SELECT 
		r.id AS reader_id,
		r.name,
		count(l.id) AS total_loans,
		count(l.id) FILTER(
			WHERE l.return_date IS NULL
		) AS active_loans,
		max(l.issue_date) AS last_loan_date
	FROM readers AS r
	LEFT JOIN loans AS l
		ON r.id = l.reader_id
	GROUP BY r.id
),
last_books AS (
	SELECT DISTINCT ON (l.reader_id)
		l.reader_id,
		b.title AS last_book_title
	FROM loans AS l
	JOIN books AS b
		ON l.book_id = b.id
	ORDER BY l.reader_id, l.issue_date DESC, l.id DESC
)
SELECT
	ls.reader_id,
	ls.name,
	ls.total_loans,
	ls.active_loans,
	ls.last_loan_date,
	lb.last_book_title,
	rank() OVER(
		ORDER BY total_loans DESC
	) AS activity_rank
FROM library_aggregate_stats AS ls
LEFT JOIN last_books AS lb
	ON lb.reader_id  = ls.reader_id 
ORDER BY activity_rank, reader_id;

SELECT DISTINCT ON (reader_id)
  reader_id,
  book_id,
  issue_date
FROM loans AS 
LEFT JOIN 
ORDER BY reader_id, issue_date DESC, id DESC;


SELECT 
	r.id AS reader_id,
	r.name,
	l.issue_date,
	l.return_date,
	b.title
FROM readers AS r
LEFT JOIN loans AS l
	ON r.id = l.reader_id
LEFT JOIN books AS b
	ON b.id = l.book_id
ORDER BY reader_id;