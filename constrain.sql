CREATE DATABASE IF NOT EXISTS temp1;

USE temp1;

CREATE TABLE student(
  id INT PRIMARY KEY,
  name VARCHAR(50),
  age int NOT NULL,
  email VARCHAR(50) UNIQUE
)

INSERT INTO student VALUES (1, 'mausm', 23, "masum@gmail.com");
INSERT INTO student VALUES (2, 'noman', 23, "noman@gmail.com");
INSERT INTO student VALUES (3, 'shafi', 23, "shafi@gmail.com");


SELECT * FROM student;


CREATE TABLE IF NOT EXISTS dept(
  std_id INT PRIMARY KEY,
  FOREIGN KEY (std_id) references student (id),
  cost INT DEFAULT 25000
);


INSERT INTO dept VALUES (1, 40000);
INSERT INTO dept VALUES (3, 20000);
INSERT INTO dept (std_id) VALUES (2);
INSERT INTO dept VALUES (10, 40000);

SELECT * FROM dept;



CREATE TABLE IF NOT EXISTS test(
  id INT PRIMARY KEY,
  city VARCHAR(50),
  CONSTRAINT id_check CHECK (id < 10 AND city = "Dhaka")
);


INSERT INTO test VALUES(1, "Dhaka");
INSERT INTO test VALUES(2, "Rajshahi");
INSERT INTO test VALUES(10, "Dhaka");

CREATE TABLE IF NOT EXISTS tab(
  age INT CHECK (age <= 10)
)

INSERT INTO tab VALUES(10);
INSERT INTO tab VALUES(11);