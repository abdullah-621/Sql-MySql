SHOW DATABASES;

DROP DATABASE IF EXISTS college;


CREATE DATABASE IF NOT EXISTS college;

USE college;

CREATE TABLE IF NOT EXISTS student(
  rollno INT PRIMARY KEY,
  name VARCHAR(50),
  marks INT NOT NULL,
  grade VARCHAR(1),
  city VARCHAR(20)
);

SHOW TABLES;

INSERT INTO student
(rollno, name, marks, grade, city)
VALUES
(101, "anil", 78, "C", "Pune"),
(102, "bhumika", 93, "A", "Mumbai"),
(103, "chetan", 85, "B", "Mumbai"),
(104, "dhruv", 96, "A", "Delhi"),
(105, "emanuel", 12, "F", "Delhi"),
(106, "farah", 82, "B", "Delhi");

SELECT * FROM student;

-- ORDER BY Clause and LIMIT Clause

SELECT * FROM student
ORDER BY marks DESC 
LIMIT 3 
OFFSET 3;

SELECT * FROM student
ORDER BY marks DESC, city ASC;


-- String operation (% , _) LIKE Operator

SELECT * FROM student
WHERE name LIKE "a%"

SELECT * FROM student
WHERE name LIKE "%l"

SELECT * FROM student
WHERE name LIKE "%an%"

SELECT name, city FROM student
WHERE name LIKE "f___h";

-- BETWEEN Operator

SELECT * FROM student
WHERE marks BETWEEN 80 AND 100;

SELECT * FROM student
WHERE marks NOT BETWEEN 80 AND 100;


--  IN Operator

SELECT * FROM student
WHERE city IN ("Delhi", "Mumbai")

SELECT * FROM student
WHERE city NOT IN ("Delhi", "Mumbai")

-- IS NULL / IS NOT NULL

SELECT * FROM student
WHERE grade IS NULL;

SELECT * FROM student
WHERE grade IS NOT NULL;

-- Aggregate Functions

SELECT 
  COUNT(*) AS total_student,
  AVG(marks) AS avg_marks,
  MAX(marks) AS topper_marks,
  MIN(marks) AS lowerst_marks
FROM student;



-- GROUP BY Clause and HAVING Clause

SELECT city, COUNT(name)
FROM student
GROUP BY city;

SELECT city , AVG(marks) as avg_marks
FROM student
GROUP BY city
HAVING AVG(marks) >80;

SELECT city,grade, COUNT(*)
FROM student
GROUP BY city,grade;

SELECT city
FROM student
GROUP BY city
HAVING MAX(marks) > 90;


SELECT city, COUNT(*) AS total
FROM student
GROUP BY city
HAVING total > 1;



SELECT city, COUNT(*) AS total_student
FROM student
WHERE marks > 20
GROUP BY city 
HAVING COUNT(*) >= 1
ORDER BY total_student DESC
LIMIT 1; 

