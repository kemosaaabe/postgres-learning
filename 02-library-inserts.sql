INSERT INTO readers (name, email)
VALUES 
	('Sanek', 'sanek@mail.com'),
	('Nastya', 'nastya@mail.com');

INSERT INTO books (title, isbn, published_year, count)
VALUES 
	('Clean Code', '9780132350884', 2008, 3),
	('The Pragmatic Programmer', '9780135957059', 2019, 2);

INSERT INTO loans (reader_id, book_id)
VALUES
	(1, 1);

SELECT * FROM loans;
SELECT * FROM readers;
SELECT * FROM books;
