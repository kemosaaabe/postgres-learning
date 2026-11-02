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