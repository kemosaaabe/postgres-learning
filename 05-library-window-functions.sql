SELECT 
	id AS loan_id,
	reader_id,
	issue_date,
	first_value(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date
	) AS first_date,
	last_value(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS last_date,
	lag(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date, id
	) AS previous_date,
	lead(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date, id
	) AS next_date
FROM loans
ORDER BY reader_id, issue_date, loan_id;


SELECT 
	id AS loan_id,
	reader_id,
	issue_date,
	first_value(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date
	) AS first_issue_date,
	last_value(issue_date) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS last_issue_date
FROM loans;


WITH loans_stats AS (
	SELECT
		id AS loan_id,
		reader_id,
		issue_date,
		lead(issue_date) OVER(
			PARTITION BY reader_id
			ORDER BY issue_date, id
		) AS next_issue_date
	FROM loans
)
SELECT 
	loan_id,
	reader_id,
	issue_date,
	next_issue_date,
	next_issue_date - issue_date AS days_until_next
FROM loans_stats
ORDER BY reader_id, issue_date, loan_id;


WITH loans_stats AS (
	SELECT
		id AS loan_id,
		reader_id,
		issue_date,
		lag(issue_date) OVER(
			PARTITION BY reader_id
			ORDER BY issue_date, id
		) AS previous_issue_date
	FROM loans
)
SELECT
	loan_id,
	reader_id,
	issue_date,
	previous_issue_date,
	issue_date - previous_issue_date AS days_since_previous
FROM loans_stats
ORDER BY reader_id, issue_date, loan_id;


WITH books_stats AS (
	SELECT
		b.id AS book_id,
		b.title,
		count(l.id) AS loans_count
	FROM books AS b
	LEFT JOIN loans AS l
		ON b.id = l.book_id
	GROUP BY b.id
)
SELECT
	book_id,
	title,
	loans_count,
	ROW_NUMBER() OVER(
		ORDER BY loans_count DESC, book_id
	) AS row_num,
	RANK() OVER(
		ORDER BY loans_count DESC
	) AS rank,
	DENSE_RANK() OVER(
		ORDER BY loans_count DESC
	) AS dense_rank
FROM books_stats
ORDER BY loans_count DESC, book_id;


WITH row_number_stats AS (
	SELECT
		id AS loan_id,
		reader_id,
		book_id,
		issue_date,
		row_number() OVER(
			PARTITION BY reader_id
			ORDER BY issue_date DESC, id DESC
		) AS row_number_info
	FROM loans
)
SELECT
	loan_id,
	reader_id,
	book_id,
	issue_date
FROM row_number_stats
WHERE row_number_info = 1
ORDER BY reader_id;


SELECT 
	id AS loan_id,
	reader_id,
	issue_date,
	count(*) OVER(
		PARTITION BY reader_id
	) AS total_reader_loans,
	count(*) OVER (
		PARTITION BY reader_id
		ORDER BY issue_date, id
	) AS running_reader_loans
FROM loans
ORDER BY reader_id, issue_date, loan_id;


SELECT 
	id AS book_id,
	title,
	count AS stock,
	round(avg(count) OVER(
		ORDER BY id
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	), 2) AS moving_avg
FROM books;


SELECT 
	id AS loan_id,
	reader_id,
	issue_date,
	count(*) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date, id
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS count_by_rows,
	count(*) OVER(
		PARTITION BY reader_id
		ORDER BY issue_date
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS count_by_range
FROM loans
ORDER BY reader_id;


SELECT 
 id AS loan_id,
 issue_date,
 count(*) OVER(
 	ORDER BY issue_date
 	RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW
 ) AS loans_last_7_days
FROM loans
ORDER BY issue_date, loan_id;