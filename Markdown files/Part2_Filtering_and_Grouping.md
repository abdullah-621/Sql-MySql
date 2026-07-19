# SQL Handbook — Part 2: Filtering & Grouping

*This part assumes the `student` table created in Part 1.*

```sql
CREATE DATABASE college;
USE college;

CREATE TABLE student (
    rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT NOT NULL,
    grade VARCHAR(1),
    city VARCHAR(20)
);

INSERT INTO student
(rollno, name, marks, grade, city)
VALUES
(101, "anil", 78, "C", "Pune"),
(102, "bhumika", 93, "A", "Mumbai"),
(103, "chetan", 85, "B", "Mumbai"),
(104, "dhruv", 96, "A", "Delhi"),
(105, "emanuel", 12, "F", "Delhi"),
(106, "farah", 82, "B", "Delhi");
```

---

## 1. ORDER BY Clause

Used to **sort** the result set in ascending (`ASC`) or descending (`DESC`) order.

**Syntax:**
```sql
SELECT col1, col2 FROM table_name
ORDER BY col_name(s) ASC | DESC;
```

**Example — ascending (default):**
```sql
SELECT * FROM student
ORDER BY city ASC;
```

**Example — descending:**
```sql
SELECT * FROM student
ORDER BY marks DESC;
```

**Example — sort by multiple columns:**
```sql
SELECT * FROM student
ORDER BY city ASC, marks DESC;
```
This sorts rows by `city` first; for rows with the same `city`, it further sorts by `marks` in descending order.

> **Note:** If `ASC`/`DESC` is not specified, SQL defaults to `ASC`.

---

## 2. LIMIT Clause

Sets an upper limit on the number of rows returned by a query.

**Syntax:**
```sql
SELECT col1, col2 FROM table_name
LIMIT number;
```

**Example:**
```sql
SELECT * FROM student LIMIT 3;
```

**Example — Pagination using OFFSET:**
```sql
SELECT * FROM student
LIMIT 3 OFFSET 3;   -- skips first 3 rows, then returns next 3
```

**Example — Top N records:**
```sql
SELECT * FROM student
ORDER BY marks DESC
LIMIT 1;   -- topper of the class
```

> **Note:** `LIMIT` is MySQL/PostgreSQL syntax. SQL Server uses `TOP`, and Oracle uses `FETCH FIRST n ROWS ONLY`.

---

## 3. LIKE Operator

Used inside `WHERE` for **pattern matching** on string values.

**Wildcards:**
| Symbol | Meaning |
|---|---|
| `%` | Matches zero, one, or multiple characters |
| `_` | Matches exactly one character |

**Syntax:**
```sql
SELECT col1, col2 FROM table_name
WHERE col_name LIKE pattern;
```

**Example — starts with 'a':**
```sql
SELECT * FROM student WHERE name LIKE 'a%';
```

**Example — ends with 'l':**
```sql
SELECT * FROM student WHERE name LIKE '%l';
```

**Example — contains 'an' anywhere:**
```sql
SELECT * FROM student WHERE name LIKE '%an%';
```

**Example — exactly 5 characters, starting with 'a':**
```sql
SELECT * FROM student WHERE name LIKE 'a____';
```

**Example — NOT LIKE:**
```sql
SELECT * FROM student WHERE name NOT LIKE 'a%';
```

---

## 4. BETWEEN Operator

Selects values within a given range (**inclusive** of both endpoints).

**Syntax:**
```sql
SELECT * FROM table_name
WHERE col_name BETWEEN val1 AND val2;
```

**Example:**
```sql
SELECT * FROM student WHERE marks BETWEEN 80 AND 90;
```

**Example — with dates:**
```sql
SELECT * FROM student WHERE dob BETWEEN '1995-01-01' AND '1995-12-31';
```

**Example — NOT BETWEEN:**
```sql
SELECT * FROM student WHERE marks NOT BETWEEN 80 AND 90;
```

---

## 5. IN Operator

Matches any value in a given list — a shorthand for multiple `OR` conditions.

**Syntax:**
```sql
SELECT * FROM table_name
WHERE col_name IN (value1, value2, ...);
```

**Example:**
```sql
SELECT * FROM student WHERE city IN ("Delhi", "Mumbai");
```

This is equivalent to:
```sql
SELECT * FROM student WHERE city = "Delhi" OR city = "Mumbai";
```

**Example — NOT IN:**
```sql
SELECT * FROM student WHERE city NOT IN ("Delhi", "Mumbai");
```

---

## 6. IS NULL / IS NOT NULL

Used to check for **NULL** (missing/unknown) values. You **cannot** use `= NULL`; SQL requires the special `IS NULL` operator.

**Syntax:**
```sql
SELECT * FROM table_name WHERE col_name IS NULL;
SELECT * FROM table_name WHERE col_name IS NOT NULL;
```

**Example:**
```sql
SELECT * FROM student WHERE grade IS NULL;
SELECT * FROM student WHERE grade IS NOT NULL;
```

> **Note:** `NULL` means "no value" — it is different from `0` or an empty string `''`. Any arithmetic or comparison with `NULL` returns `NULL` (unknown), not `TRUE` or `FALSE`.

---

## 7. Aggregate Functions

Aggregate functions perform a calculation on a **set of values** and return a **single value**.

| Function | Description |
|---|---|
| `COUNT()` | Counts the number of rows |
| `SUM()` | Adds up numeric values |
| `AVG()` | Calculates the average |
| `MAX()` | Returns the highest value |
| `MIN()` | Returns the lowest value |

### 7.1 COUNT()

```sql
-- Count total number of students
SELECT COUNT(*) FROM student;

-- Count students with non-null grade
SELECT COUNT(grade) FROM student;

-- Count distinct cities
SELECT COUNT(DISTINCT city) FROM student;
```

### 7.2 SUM()

```sql
SELECT SUM(marks) FROM student;
```

### 7.3 AVG()

```sql
SELECT AVG(marks) FROM student;
```

### 7.4 MAX()

```sql
SELECT MAX(marks) FROM student;
```

### 7.5 MIN()

```sql
SELECT MIN(marks) FROM student;
```

**Example — combining aggregates:**
```sql
SELECT
    COUNT(*) AS total_students,
    AVG(marks) AS avg_marks,
    MAX(marks) AS topper_marks,
    MIN(marks) AS lowest_marks
FROM student;
```

> **Note:** Aggregate functions ignore `NULL` values (except `COUNT(*)`, which counts all rows regardless of NULLs).

---

## 8. GROUP BY Clause

Groups rows that have the same values in specified column(s) into **summary rows**. It is almost always used together with an aggregate function.

**Syntax:**
```sql
SELECT col_name, AGG_FUNC(col_name)
FROM table_name
GROUP BY col_name;
```

**Example — Count number of students in each city:**
```sql
SELECT city, COUNT(name)
FROM student
GROUP BY city;
```

**Output:**
```
+--------+-------------+
| city   | COUNT(name) |
+--------+-------------+
| Pune   | 1           |
| Mumbai | 2           |
| Delhi  | 3           |
+--------+-------------+
```

**Example — Average marks per city:**
```sql
SELECT city, AVG(marks) AS avg_marks
FROM student
GROUP BY city;
```

**Example — Group by multiple columns:**
```sql
SELECT city, grade, COUNT(*)
FROM student
GROUP BY city, grade;
```

> **Note:** Every column in the `SELECT` list that is **not** inside an aggregate function must appear in the `GROUP BY` clause (in standard SQL).

---

## 9. HAVING Clause

Similar to `WHERE`, but used to filter groups **after** aggregation (i.e., after `GROUP BY` has run). `WHERE` cannot filter on aggregate function results — `HAVING` can.

**Syntax:**
```sql
SELECT col_name, AGG_FUNC(col_name)
FROM table_name
GROUP BY col_name
HAVING condition;
```

**Example — Cities where max marks cross 90:**
```sql
SELECT COUNT(name), city
FROM student
GROUP BY city
HAVING MAX(marks) > 90;
```

**Example — Cities with more than 1 student:**
```sql
SELECT city, COUNT(*) AS total
FROM student
GROUP BY city
HAVING COUNT(*) > 1;
```

### WHERE vs HAVING

| Feature | WHERE | HAVING |
|---|---|---|
| Filters | Individual rows | Groups (after GROUP BY) |
| Can use aggregate functions | No | Yes |
| Executes | Before grouping | After grouping |
| Used with | Any SELECT query | Mainly with GROUP BY |

---

## 10. General SQL Execution Order

SQL queries are **written** in one order but **executed** in a different (logical) order internally.

**Written order (syntax order):**
```sql
SELECT column(s)
FROM table_name
WHERE condition
GROUP BY column(s)
HAVING condition
ORDER BY column(s) ASC;
```

**Actual logical execution order:**

1. `FROM` — identify the source table(s)
2. `WHERE` — filter individual rows
3. `GROUP BY` — group remaining rows
4. `HAVING` — filter groups
5. `SELECT` — pick columns / compute expressions
6. `DISTINCT` — remove duplicate rows (if used)
7. `ORDER BY` — sort the final result
8. `LIMIT` — restrict number of returned rows

**Example illustrating the full order:**
```sql
SELECT city, COUNT(*) AS total_students
FROM student
WHERE marks > 20
GROUP BY city
HAVING COUNT(*) >= 1
ORDER BY total_students DESC
LIMIT 5;
```

**How this executes internally:**
1. Read all rows from `student` (`FROM`)
2. Remove students with `marks <= 20` (`WHERE`)
3. Group remaining rows by `city` (`GROUP BY`)
4. Keep only groups with 1+ students (`HAVING`)
5. Select `city` and count of students (`SELECT`)
6. Sort the groups by `total_students` descending (`ORDER BY`)
7. Return only the top 5 rows (`LIMIT`)

> **Why this matters:** Understanding this order explains *why* you can't use a `SELECT` alias inside `WHERE` (since `WHERE` runs before `SELECT`), but you generally *can* use it in `ORDER BY` (which runs after `SELECT`).

---

## Practice Questions — Part 2

1. Write a query to display all students sorted by `marks` in descending order.
2. Write a query to display the top 3 highest scoring students.
3. Write a query to find all students whose name starts with the letter 'a'.
4. Write a query to find all students whose name contains the substring "an".
5. Write a query to find students with marks between 70 and 90 (inclusive).
6. Write a query to find students who live in either "Delhi" or "Pune".
7. Write a query to find students who do NOT live in "Mumbai".
8. Write a query to find rows where `grade` is `NULL`.
9. Write a query to count the total number of students in the table.
10. Write a query to find the average marks of all students.
11. Write a query to find the number of students in each grade, using `GROUP BY`.
12. Write a query to find cities having more than 2 students.
13. Write a query to find cities where the average marks is above 70.
14. Write a query combining `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, and `LIMIT` in a single statement, and explain the execution order step by step.
15. Explain, with an example, why you cannot use `WHERE COUNT(*) > 1` but you can use `HAVING COUNT(*) > 1`.

---

**End of Part 2 — Continue to Part 3: All Joins**
