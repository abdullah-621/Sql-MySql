CREATE DATABASE IF NOT EXISTS test1;

SHOW DATABASES;

USE test1;


CREATE TABLE tableA (
    rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT,
    city VARCHAR(20)
);

INSERT INTO tableA 
(rollno, name, marks, city) 
VALUES
(101, "anil", 78, "Pune"),
(102, "bhumika", 93, "Mumbai"),
(103, "chetan", 85, "Mumbai"),
(104, "dhruv", 96, "Delhi"),
(105, "emanuel", 92, "Delhi"),
(106, "farah", 82, "Delhi");



CREATE TABLE tableB (
    rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT,
    city VARCHAR(20)
);

INSERT INTO tableB
(rollno, name, marks, city) 
VALUES
(101, "anil", 78, "Pune"),
(102, "bhumika", 93, "Mumbai"),
(103, "chetan", 85, "Mumbai"),
(104, "dhruv", 96, "Delhi"),
(105, "emanuel", 92, "Delhi"),
(106, "farah", 82, "Delhi");

SELECT name,city FROM tableA
UNION
SELECT name,city FROM tableB;


SELECT * FROM tableA
ORDER BY marks DESC
LIMIT 1 OFFSET 1;


