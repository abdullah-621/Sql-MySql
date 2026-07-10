CREATE DATABASE IF NOT EXISTS XYZ;

USE XYZ;

CREATE TABLE IF NOT EXISTS employee(
  id int primary key,
  name varchar(50),
  salary int
);

INSERT INTO employee (id, name, salary) VALUES(1, 'masum', 25000), (2, 'noman', 20000), (3, 'shafi', 15000);

SELECT * FROM employee;


