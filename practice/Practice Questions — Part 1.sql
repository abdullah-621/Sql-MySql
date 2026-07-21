SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS school_2;

USE school_2;

CREATE TABLE IF NOT EXISTS teacher(
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  subject VARCHAR(50),
  salary INT DEFAULT(30000)
);


INSERT INTO teacher (name, subject, salary) VALUES
("Milkon", "Advanced Algo", 70000),
("Mohaimin", "Image Process", 50000),
("Rifat", "DBMS Lab", 60000),
("Noman Amin", "DBMS", 65000),
("Lia", "Advanced Algo lab", 70000);

SELECT * FROM teacher;

SELECT name, subject FROM teacher
WHERE salary > 60000;


ALTER TABLE teacher
ADD COLUMN email VARCHAR(50);

ALTER TABLE teacher
RENAME COLUMN depertment to subject;


DELETE FROM teacher
WHERE salary < 60000;


UPDATE teacher
SET salary = 50000
WHERE depertment LIKE "%DBMS%";


SELECT DISTINCT depertment 
FROM teacher;


SELECT name FROM teacher
WHERE salary BETWEEN 60000 AND 70000;


TRUNCATE TABLE teacher;
DELETE FROM teacher;
DROP TABLE teacher;


CREATE TABLE IF NOT EXISTS course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teacher(id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


SELECT name , salary, salary * 1.10 AS new_salary FROM teacher;



