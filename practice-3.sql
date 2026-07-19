CREATE DATABASE IF NOT EXISTS temp;

USE temp;

CREATE TABLE IF NOT EXISTS student(
  id INT PRIMARY KEY,
  name VARCHAR(50),
  score INT,
  grade VARCHAR(2)
)

INSERT INTO student VALUES
(1, 'masum', 80, 'A+'),
(2, 'masum', 70, 'A'),
(3, 'masum', 60, 'A-'),
(4, 'masum', 80, 'A+')

SELECT * FROM student;

ALTER TABLE student
CHANGE COLUMN name full_name
VARCHAR(50);

DELETE FROM student
WHERE score < 80;


ALTER TABLE student
DROP COLUMN grade;