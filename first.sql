CREATE TABLE IF NOT EXISTS test_users (
	id integer PRIMARY KEY,
	name text NOT null
);

INSERT INTO test_users (id, name)
VALUES 
	(1, 'Alex'),
	(2, 'Kate');

SELECT * FROM test_users;
