# SQL Handbook — Part 4: Subqueries & Set Operations

## Sample Data Used in This Part

```sql
CREATE TABLE student (
    rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT,
    city VARCHAR(20)
);

INSERT INTO student (rollno, name, marks, city) VALUES
(101, "anil", 78, "Pune"),
(102, "bhumika", 93, "Mumbai"),
(103, "chetan", 85, "Mumbai"),
(104, "dhruv", 96, "Delhi"),
(105, "emanuel", 92, "Delhi"),
(106, "farah", 82, "Delhi");
```

---

## 1. Subquery (Inner Query / Nested Query)

A **Subquery**, also called an **Inner Query** or **Nested Query**, is a query written **within** another SQL query. It involves at least **2 SELECT statements** — the outer query and the inner (sub) query.

```
Query
 └── Sub Query
```

**Syntax:**
```sql
SELECT column(s)
FROM table_name
WHERE col_name operator
(subquery);
```

The subquery is executed **first**, and its result is used by the outer query.

**Example 1 — Students who scored more than class average:**

*Step 1: Find the average marks of the class*
```sql
SELECT AVG(marks) FROM student;  -- returns 87.67 (approx)
```

*Step 2: Find students scoring above that average*
```sql
SELECT name FROM student
WHERE marks > (SELECT AVG(marks) FROM student);
```

**Example 2 — Students with even roll numbers:**
```sql
SELECT name FROM student
WHERE rollno IN (
    SELECT rollno FROM student WHERE rollno % 2 = 0
);
```

**Example 3 — Subquery in the FROM clause (finding max marks of students from Delhi):**
```sql
SELECT MAX(marks)
FROM (
    SELECT * FROM student WHERE city = "Delhi"
) AS delhi_students;
```

> **Note:** A subquery used in the `FROM` clause must always be given an **alias** — it's treated as a temporary (derived) table.

### Types of Subqueries by Location

| Location | Example |
|---|---|
| In `WHERE` | `WHERE marks > (SELECT AVG(marks) FROM student)` |
| In `FROM` | `FROM (SELECT * FROM student WHERE city="Delhi") AS d` |
| In `SELECT` | `SELECT name, (SELECT AVG(marks) FROM student) AS class_avg FROM student` |
| In `HAVING` | `HAVING COUNT(*) > (SELECT AVG(cnt) FROM ...)` |

---

## 2. Nested Query

A **Nested Query** is simply a subquery placed **inside another subquery**, forming multiple levels of nesting.

**Example — Students scoring more than the average of students from Mumbai:**
```sql
SELECT name FROM student
WHERE marks > (
    SELECT AVG(marks) FROM student
    WHERE city = (
        SELECT city FROM student WHERE name = "chetan"
    )
);
```

Here, the innermost query finds Chetan's city, the middle query finds the average marks in that city, and the outer query finds students scoring above that average.

> **Note:** While SQL allows deep nesting, more than 2–3 levels usually hurts readability. Consider breaking such queries into `CTEs` (`WITH` clause) or `VIEWS` for clarity.

---

## 3. EXISTS

Returns `TRUE` if the subquery returns **at least one row**; otherwise `FALSE`. Commonly used to check for the existence of related records.

**Syntax:**
```sql
SELECT column(s)
FROM table_name
WHERE EXISTS (subquery);
```

**Example — Students who have a matching entry in the course table:**
```sql
SELECT name FROM student s
WHERE EXISTS (
    SELECT 1 FROM course c WHERE c.student_id = s.rollno
);
```

> **Note:** `EXISTS` is often more efficient than `IN` for large datasets, since it stops scanning as soon as it finds one match (short-circuit evaluation).

---

## 4. NOT EXISTS

Returns `TRUE` if the subquery returns **no rows**.

**Syntax:**
```sql
SELECT column(s)
FROM table_name
WHERE NOT EXISTS (subquery);
```

**Example — Students who have NOT enrolled in any course:**
```sql
SELECT name FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM course c WHERE c.student_id = s.rollno
);
```

---

## 5. IN (with Subquery)

Checks if a value matches **any value** returned by the subquery.

**Syntax:**
```sql
SELECT column(s) FROM table_name
WHERE col_name IN (subquery);
```

**Example — Students enrolled in at least one course:**
```sql
SELECT name FROM student
WHERE rollno IN (SELECT student_id FROM course);
```

**Example — NOT IN:**
```sql
SELECT name FROM student
WHERE rollno NOT IN (SELECT student_id FROM course);
```

> **Warning:** Be careful using `NOT IN` with a subquery that might return `NULL` values — if the subquery result contains even one `NULL`, the entire `NOT IN` condition can unexpectedly return **no rows**. Prefer `NOT EXISTS` when NULLs are possible.

---

## 6. ANY

Compares a value to **any** value in a list/subquery result — the condition is true if **at least one** comparison is true.

**Syntax:**
```sql
SELECT column(s) FROM table_name
WHERE col_name operator ANY (subquery);
```

**Example — Students who scored more than at least one student from Delhi:**
```sql
SELECT name FROM student
WHERE marks > ANY (
    SELECT marks FROM student WHERE city = "Delhi"
);
```

This means: marks greater than the **minimum** value in the subquery result would already satisfy the condition.

---

## 7. ALL

Compares a value to **all** values in a list/subquery result — the condition is true only if the comparison holds for **every** value.

**Syntax:**
```sql
SELECT column(s) FROM table_name
WHERE col_name operator ALL (subquery);
```

**Example — Students who scored more than every student from Delhi:**
```sql
SELECT name FROM student
WHERE marks > ALL (
    SELECT marks FROM student WHERE city = "Delhi"
);
```

This means: marks greater than the **maximum** value in the subquery result.

### ANY vs ALL — Quick Comparison

| Operator | Condition True When... | Roughly Equivalent To |
|---|---|---|
| `> ANY` | greater than at least one value | `> MIN(subquery)` |
| `> ALL` | greater than every value | `> MAX(subquery)` |
| `< ANY` | less than at least one value | `< MAX(subquery)` |
| `< ALL` | less than every value | `< MIN(subquery)` |

---

## 8. UNION

Combines the result-set of **two or more** `SELECT` statements into a single result-set, returning only **unique (distinct)** rows.

**Rules for using UNION:**
- Every `SELECT` must have the **same number of columns**
- Columns must have **similar/compatible datatypes**
- Columns in every `SELECT` must be in the **same order**

**Syntax:**
```sql
SELECT column(s) FROM tableA
UNION
SELECT column(s) FROM tableB;
```

**Example — Combine names of students from two different tables:**
```sql
SELECT name, city FROM student_old
UNION
SELECT name, city FROM student_new;
```

> **Note:** `UNION` automatically removes duplicate rows across both result sets (like `DISTINCT`).

---

## 9. UNION ALL

Same as `UNION`, but **keeps duplicate rows** instead of removing them. It's faster than `UNION` since it skips the duplicate-removal step.

**Syntax:**
```sql
SELECT column(s) FROM tableA
UNION ALL
SELECT column(s) FROM tableB;
```

**Example:**
```sql
SELECT name, city FROM student_old
UNION ALL
SELECT name, city FROM student_new;
```

### UNION vs UNION ALL

| Feature | UNION | UNION ALL |
|---|---|---|
| Removes duplicates | Yes | No |
| Performance | Slower (extra dedup step) | Faster |
| Use case | Need only unique combined rows | Need every row, including duplicates |

---

## 10. INTERSECT

Returns only the rows that are **common to both** SELECT statements (like an intersection in set theory).

**Syntax:**
```sql
SELECT column(s) FROM tableA
INTERSECT
SELECT column(s) FROM tableB;
```

**Example — Cities that have students in both `student_2023` and `student_2024`:**
```sql
SELECT city FROM student_2023
INTERSECT
SELECT city FROM student_2024;
```

> **Note:** `INTERSECT` is supported in PostgreSQL, SQL Server, and Oracle. **MySQL (before v8.0.31) does not support `INTERSECT` directly** — it can be simulated using `INNER JOIN` or `IN`:
> ```sql
> SELECT DISTINCT a.city FROM student_2023 a
> INNER JOIN student_2024 b ON a.city = b.city;
> ```

---

## 11. EXCEPT (MINUS)

Returns rows from the **first** SELECT statement that do **not** appear in the second SELECT statement (set difference).

**Syntax (SQL Server / PostgreSQL):**
```sql
SELECT column(s) FROM tableA
EXCEPT
SELECT column(s) FROM tableB;
```

**Syntax (Oracle):**
```sql
SELECT column(s) FROM tableA
MINUS
SELECT column(s) FROM tableB;
```

**Example — Students in `student_2023` who are NOT in `student_2024`:**
```sql
SELECT name FROM student_2023
EXCEPT
SELECT name FROM student_2024;
```

> **Note:** MySQL does not support `EXCEPT`/`MINUS` directly (until recent versions). It's typically simulated with `LEFT JOIN ... WHERE ... IS NULL` or `NOT IN`:
> ```sql
> SELECT a.name FROM student_2023 a
> LEFT JOIN student_2024 b ON a.name = b.name
> WHERE b.name IS NULL;
> ```

---

## 12. Correlated Subquery

A **Correlated Subquery** is a subquery that **references a column from the outer query**. Unlike a regular subquery (which runs once), a correlated subquery runs **once for every row** processed by the outer query.

**Syntax:**
```sql
SELECT column(s)
FROM tableA a
WHERE col_name operator (
    SELECT AGG_FUNC(col_name)
    FROM tableB b
    WHERE b.related_col = a.related_col
);
```

**Example — Students who scored more than the average marks of their own city:**
```sql
SELECT name, city, marks
FROM student s1
WHERE marks > (
    SELECT AVG(marks)
    FROM student s2
    WHERE s2.city = s1.city
);
```

**How it works:**
1. For each row in the outer query (`s1`), the inner query recalculates the average marks **only for that student's city** (`s2.city = s1.city`).
2. The outer row is kept only if its marks exceed that city-specific average.

**Example — Find the second highest marks using a correlated subquery:**
```sql
SELECT name, marks FROM student s1
WHERE 1 = (
    SELECT COUNT(*) FROM student s2
    WHERE s2.marks > s1.marks
);
```
This finds the row where exactly **one** other student has higher marks — i.e., the second highest scorer.

### Regular Subquery vs Correlated Subquery

| Feature | Regular Subquery | Correlated Subquery |
|---|---|---|
| Dependency on outer query | Independent | References outer query's columns |
| Execution | Runs once | Runs once per outer row |
| Performance | Generally faster | Can be slower on large tables |
| Common use | Filtering by a computed constant | Row-by-row comparisons |

---

## Practice Questions — Part 4

1. Write a subquery to find students who scored below the class average.
2. Write a subquery in the `FROM` clause to find the minimum marks among students from "Mumbai".
3. Write a query using `EXISTS` to find students who have at least one course enrollment.
4. Write a query using `NOT EXISTS` to find students with zero course enrollments.
5. Write a query using `IN` to find students enrolled in any course.
6. Explain, with an example, why `NOT IN` can behave unexpectedly when the subquery contains `NULL` values.
7. Write a query using `> ANY` to find students who scored more than at least one student from "Delhi".
8. Write a query using `> ALL` to find students who scored more than every student from "Delhi".
9. Write a `UNION` query combining names from two tables `alumni` and `current_students`.
10. Write the same query as Q9 using `UNION ALL`, and explain the difference in the result.
11. Write a query (or its MySQL-compatible simulation) to find cities common to both `student_2023` and `student_2024` using `INTERSECT`.
12. Write a query (or its MySQL-compatible simulation) to find students present in `student_2023` but not in `student_2024` using `EXCEPT`.
13. Write a correlated subquery to find students who scored more than the average marks of their own city.
14. Write a correlated subquery to find the second highest marks in the `student` table.
15. Explain the key difference between a regular subquery and a correlated subquery, including how execution differs.

---

**End of Part 4 — Continue to Part 5: Advanced SQL**
