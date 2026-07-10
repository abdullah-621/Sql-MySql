CREATE DATABASE IF NOT EXISTS University;

USE University;

CREATE TABLE students(
  id INT primary key,
  name varchar(50),
  age int not null
);

INSERT INTO students (id , name , age) VALUES(1, "Masum", 23);
INSERT INTO students VALUES(2, "Noman", 17);

INSERT INTO students (id , name , age) VALUES(3, "Masum", 23);

INSERT INTO students (id, name, age) VALUES (4, 'shafi', 24), (5, 'kalam', 25);

SELECT * FROM students;

DROP TABLE students;

SHOW tables;
SHOW databases;