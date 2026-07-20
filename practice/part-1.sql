CREATE DATABASE IF NOT EXISTS school;

DROP DATABASE IF EXISTS school;

SHOW DATABASES;


USE school;


CREATE TABLE IF NOT EXISTS stu(
  rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT NOT NULL,
    grade VARCHAR(1),
    city VARCHAR(20)
)

INSERT INTO stu 
(rollno, name, marks,grade,city) 
VALUES
(101, "anil", 78, "C", "Pune"),
(102, "bhumika", 93, "A", "Mumbai"),
(103, "chetan", 85, "B", "Mumbai"),
(104, "dhruv", 96, "A", "Delhi"),
(105, "emanuel", 12, "F", "Delhi"),
(106, "farah", 82, "B", "Delhi");

SELECT * FROM stu;


-- ============= --
-- ALTER TABLE
-- ============= --

ALTER TABLE stu
ADD COLUMN age INT NOT NULL DEFAULT 19;

ALTER TABLE stu
DROP COLUMN age;

ALTER TABLE stu
RENAME To stu;

ALTER TABLE stu
MODIFY rollno VARCHAR(5);

ALTER TABLE stu
CHANGE rollno id INT;


TRUNCATE TABLE stu;

DROP TABLE stu;


CREATE TABLE IF NOT EXISTS temp1(
  cust_id INT,
  FOREIGN KEY (cust_id) REFERENCES stu(rollno)
)

INSERT INTO temp1 
(cust_id) 
VALUES (101), (102) , (103);

ALTER TABLE temp1
ADD COLUMN age124 INT UNIQUE;

SELECT * FROM temp1;



CREATE TABLE city (
    id INT PRIMARY KEY,
    city VARCHAR(50),
    age INT,
    CONSTRAINT age_check CHECK (age >= 18 AND city = "Delhi")
);

INSERT INTO city (id, city, age) VALUES
(1, 'Delhi', 24),
(2, 'Delhi', 27),
(5, 'Delhi', 23);

SELECT * FROM city;


UPDATE city
SET id = 3
WHERE id = 5


DELETE FROM city
WHERE age > 22


SELECT DISTINCT city FROM city;


SELECT * FROM city
WHERE city IN ('Delhi', 'Mumbai')


SELECT name AS student_name , marks AS score FROM stu;

SELECT name, marks + 10 AS bonus_marks FROM stu;







