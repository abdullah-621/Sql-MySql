USE collage;

SELECT * FROM student;

-- add columns
ALTER TABLE student
ADD COLUMN age INT NOT NULL DEFAULT 19;

-- drop columns
ALTER TABLE student
DROP COLUMN age;

-- rename table
ALTER TABLE students
RENAME TO student

-- rename columns
ALTER TABLE student
CHANGE COLUMN city current_city VARCHAR(50);

-- modify datatype and constraint
ALTER TABLE student
MODIFY current_city VARCHAR(50) NOT NULL;

