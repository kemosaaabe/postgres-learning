INSERT INTO readers (name, email)
VALUES 
	('sanek sanekov', 'sanekov@mail.com')
RETURNING name, created_at;


UPDATE readers
SET email = '1sanekov@mail.com'
WHERE id = 9
RETURNING *;

DELETE FROM readers 
WHERE id = 9
RETURNING *;

INSERT INTO books (title, published_year, count, isbn)
VALUES
	('Refactoring', 2018, 5, '9780132350885'),
	('Domain-Driven Design', 2003, 0, '9780132350886'),
	('Designing Data-Intensive Applications', 2017, 4, '9780132350887'),
	('The Mythical Man-Month', 1975, 2, '9780132350888'),
	('Database Internals', 2019, 3, '9780132350889')
RETURNING *;

SELECT title, published_year, count AS books_count FROM books
WHERE  published_year >= 2010 
	AND count > 0
ORDER BY published_year DESC, title ASC
LIMIT 3 OFFSET 1;

SELECT * FROM books
WHERE published_year BETWEEN 2000 AND 2020
	AND count >= 1
	AND title ILIKE '%design%'
ORDER BY published_year DESC;

SELECT title, published_year FROM books
WHERE published_year IS NULL
	OR published_year IN (1975, 2003, 2019)
	AND title NOT LIKE 'The%';

SELECT * FROM books;

