USE collage;

SELECT * FROM student;

SET SQL_SAFE_UPDATEs = 0;

UPDATE student
SET grade = "O"
WHERE grade = "A";

UPDATE student
SET grade = "A"
WHERE grade = "C";

UPDATE student
SET marks = 90
WHERE roolno = 101;

UPDATE student
SET grade = "F"
WHERE marks < 80;


DELETE FROM student 
WHERE marks < 80;


