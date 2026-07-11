CREATE DATABASE IF NOT EXISTS collage;

USE collage;

CREATE TABLE IF NOT EXISTS student(
  roolno INT PRIMARY KEY,
  name VARCHAR(50),
  marks INT NOT NULL,
  grade VARCHAR(5),
  city VARCHAR(50)
)

INSERT INTO student(roolno, name, marks, grade, city) VALUES (101, 'masum', 78, 'C', "Dhaka"),
(102, 'noman', 80, 'A', "Rjahshahi"),
(103, 'masum', 12, 'F', "Joypurhat"),
(104, 'akash', 96, 'A', "Dhaka"),
(105, 'shafi', 85, 'B', "Dinajpure"),
(106, 'masum', 82, 'B', "Dhaka");

INSERT INTO student VALUES(107, 'masum', 78, 'C', "Dhaka");
INSERT INTO student VALUES(108, 'shafi', 95, 'B', "Dinajpure");

SELECT * FROM student;


SELECT roolno, name, marks FROM student;

SELECT DISTINCT name, city FROM student;