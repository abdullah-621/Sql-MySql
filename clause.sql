USE collage;

SELECT * FROM student WHERE marks > 80 AND city = "Dhaka";

-- WHERE (only for row)
SELECT * FROM student WHERE marks + 10 > 100 AND city = "Dhaka";

-- BETWEEN
SELECT * FROM student WHERE marks BETWEEN 80 AND 90;

-- IN
SELECT * FROM student WHERE city IN ("Dhaka", "Dinajpure");

-- NOT IN
SELECT * FROM student WHERE city NOT IN ("Dhaka", "Dinajpure");

-- NOT BETWEEN
SELECT * FROM student WHERE marks NOT BETWEEN 80 AND 90;

-- LIMIT
SELECT * FROM student WHERE marks BETWEEN 70 AND 90 LIMIT 3;

-- ORDER BY
SELECT * FROM student ORDER BY marks DESC;

-- GROUP BY
SELECT city, COUNT(roolno), AVG(marks) 
FROM student 
GROUP BY city 
ORDER BY city DESC;

-- Having (for row and group)
SELECT city, AVG(marks)
FROM student 
GROUP BY city
HAVING AVG(marks) < 85;


-- General Oder
SELECT city, AVG(marks)
FROM student
WHERE marks > 60
GROUP BY city
HAVING AVG(marks) > 80
ORDER BY AVG(marks) DESC;


DELETE FROM student WHERE city = "Dinajpure"




SELECT city, COUNT(roolno) AS student_count  
FROM student 
GROUP BY city 
ORDER BY student_count DESC;



SELECT city, AVG(marks) 
FROM student 
GROUP BY city 
ORDER BY AVG(marks) ASC ;