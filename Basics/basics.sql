create database if not exists collage;

USE collage; 

create table if not exists students(
	id int primary key,
    name varchar(50),
    age int not null
    );

INSERT into students values(1, "Masum", 22);
INSERT into students values(2, "Noman", 17);

select * FROM students;

-- DROP database students;
-- DROP table students;

SHOW databases;
SHOW tables;
