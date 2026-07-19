# SQL Handbook — Part 3: All Joins

## Introduction to Joins

A **JOIN** is used to combine rows from two or more tables, based on a **related column** between them.

Joins are essential in relational databases because data is normalized into multiple related tables (to avoid duplication), and we use joins to bring that related data back together for querying.

**Sample tables used throughout this part:**

*student*

| student_id | name |
|---|---|
| 101 | adam |
| 102 | bob |
| 103 | casey |

*course*

| student_id | course |
|---|---|
| 102 | english |
| 105 | math |
| 103 | science |
| 107 | computer science |

```sql
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE course (
    student_id INT,
    course VARCHAR(50)
);

INSERT INTO student VALUES (101, "adam"), (102, "bob"), (103, "casey");
INSERT INTO course VALUES (102, "english"), (105, "math"), (103, "science"), (107, "computer science");
```

### Types of Joins — Overview

```
Inner Join   Left Join   Right Join   Full Join
    ∩            ⊃            ⊂           ∪
             \_____ Outer Joins ______/
```

- **Inner Join:** only matching rows from both tables
- **Left Join:** all rows from left table + matched rows from right
- **Right Join:** all rows from right table + matched rows from left
- **Full Join:** all rows from both tables (matched + unmatched)

---

## 1. Cartesian Product (CROSS JOIN)

A **Cartesian Product** combines **every row** of the first table with **every row** of the second table — with no matching condition. If table A has `m` rows and table B has `n` rows, the result has `m x n` rows.

**Syntax:**
```sql
SELECT * FROM tableA, tableB;
-- or
SELECT * FROM tableA CROSS JOIN tableB;
```

**Example:**
```sql
SELECT * FROM student CROSS JOIN course;
```

With 3 rows in `student` and 4 rows in `course`, this returns **12 rows** (3 × 4), most of which are meaningless combinations.

> **Note:** A Cartesian Product is rarely useful on its own. It usually happens **by accident** when you forget to add an `ON` or `WHERE` condition while joining tables — always double-check your join conditions!

---

## 2. INNER JOIN

Returns only the records that have **matching values in both tables**.

**Syntax:**
```sql
SELECT column(s)
FROM tableA
INNER JOIN tableB
ON tableA.col_name = tableB.col_name;
```

**Example:**
```sql
SELECT *
FROM student
INNER JOIN course
ON student.student_id = course.student_id;
```

**Result:**

| student_id | name | course |
|---|---|---|
| 102 | bob | english |
| 103 | casey | science |

> **Note:** `student_id 101` (no matching course) and `student_id 105, 107` (no matching student) are excluded — only the intersection (matching rows) is returned.

> `JOIN` (without a keyword) defaults to `INNER JOIN` in most RDBMS:
> ```sql
> SELECT * FROM student JOIN course ON student.student_id = course.student_id;
> ```

---

## 3. LEFT JOIN (LEFT OUTER JOIN)

Returns **all records from the left table**, and the matched records from the right table. If there's no match, `NULL` is returned for right table columns.

**Syntax:**
```sql
SELECT column(s)
FROM tableA
LEFT JOIN tableB
ON tableA.col_name = tableB.col_name;
```

**Example:**
```sql
SELECT *
FROM student AS s
LEFT JOIN course AS c
ON s.student_id = c.student_id;
```

**Result:**

| student_id | name | course |
|---|---|---|
| 101 | adam | NULL |
| 102 | bob | english |
| 103 | casey | science |

> **Note:** All 3 students from the left table (`student`) appear, even `adam`, who has no course — his `course` value is `NULL`.

---

## 4. RIGHT JOIN (RIGHT OUTER JOIN)

Returns **all records from the right table**, and the matched records from the left table. If there's no match, `NULL` is returned for left table columns.

**Syntax:**
```sql
SELECT column(s)
FROM tableA
RIGHT JOIN tableB
ON tableA.col_name = tableB.col_name;
```

**Example:**
```sql
SELECT *
FROM student AS s
RIGHT JOIN course AS c
ON s.student_id = c.student_id;
```

**Result:**

| student_id | course | name |
|---|---|---|
| 102 | english | bob |
| 105 | math | NULL |
| 103 | science | casey |
| 107 | computer science | NULL |

> **Note:** All 4 rows from `course` appear, even those without a matching student (`105`, `107`) — their `name` is `NULL`.

---

## 5. FULL OUTER JOIN (FULL JOIN)

Returns **all records** when there is a match in **either** the left or the right table (i.e., the union of Left Join and Right Join).

**Syntax (standard SQL — supported in PostgreSQL, SQL Server, Oracle):**
```sql
SELECT column(s)
FROM tableA
FULL OUTER JOIN tableB
ON tableA.col_name = tableB.col_name;
```

**MySQL does NOT support `FULL OUTER JOIN` directly.** It's simulated using `LEFT JOIN UNION RIGHT JOIN`:

```sql
SELECT * FROM student AS a
LEFT JOIN course AS b
ON a.student_id = b.student_id
UNION
SELECT * FROM student AS a
RIGHT JOIN course AS b
ON a.student_id = b.student_id;
```

**Result:**

| student_id | name | course |
|---|---|---|
| 101 | adam | NULL |
| 102 | bob | english |
| 103 | casey | science |
| 105 | NULL | math |
| 107 | NULL | computer science |

---

## 6. SELF JOIN

A **regular join**, but the table is joined **with itself**. Useful for hierarchical data (e.g., employees and their managers, both in the same table).

**Syntax:**
```sql
SELECT column(s)
FROM table AS a
JOIN table AS b
ON a.col_name = b.col_name;
```

**Example — Employee table:**

| id | name | manager_id |
|---|---|---|
| 101 | adam | 103 |
| 102 | bob | 104 |
| 103 | casey | NULL |
| 104 | donald | 103 |

```sql
SELECT a.name AS manager_name, b.name
FROM employee AS a
JOIN employee AS b
ON a.id = b.manager_id;
```

**Result:**

| manager_name | name |
|---|---|
| casey | adam |
| donald | bob |
| casey | donald |

> **Note:** Self joins **always require table aliases** (e.g., `a` and `b`), since you're referencing the same table twice.

---

## 7. NATURAL JOIN

Automatically joins two tables based on **all columns with the same name and datatype** in both tables — no `ON` clause is needed.

**Syntax:**
```sql
SELECT column(s)
FROM tableA
NATURAL JOIN tableB;
```

**Example:**
```sql
SELECT *
FROM student
NATURAL JOIN course;
```
Since both `student` and `course` have a `student_id` column, MySQL automatically joins on it — equivalent to:
```sql
SELECT * FROM student INNER JOIN course USING (student_id);
```

> **Warning:** `NATURAL JOIN` can be risky — if the tables unexpectedly share another same-named column, the join condition silently changes. It's usually safer to use explicit `ON` or `USING` clauses in production code.

---

## 8. USING Clause

A shorthand for `ON` when the join column has the **exact same name** in both tables.

**Syntax:**
```sql
SELECT column(s)
FROM tableA
JOIN tableB
USING (col_name);
```

**Example:**
```sql
SELECT *
FROM student
INNER JOIN course
USING (student_id);
```

This is equivalent to:
```sql
SELECT *
FROM student
INNER JOIN course
ON student.student_id = course.student_id;
```

> **Note:** With `USING`, the shared column appears only **once** in the result set (unlike `ON`, where it may appear twice if you `SELECT *`).

---

## 9. LEFT Exclusive Join

Returns only the rows that exist **in the left table but NOT in the right table** (i.e., the left-only portion, excluding the overlap).

**Syntax:**
```sql
SELECT *
FROM tableA AS a
LEFT JOIN tableB AS b
ON a.id = b.id
WHERE b.id IS NULL;
```

**Example:**
```sql
SELECT *
FROM student AS a
LEFT JOIN course AS b
ON a.student_id = b.student_id
WHERE b.student_id IS NULL;
```

**Result:** Only `adam (101)`, since he is the only student with no matching course.

---

## 10. RIGHT Exclusive Join

Returns only the rows that exist **in the right table but NOT in the left table**.

**Syntax:**
```sql
SELECT *
FROM tableA AS a
RIGHT JOIN tableB AS b
ON a.id = b.id
WHERE a.id IS NULL;
```

**Example:**
```sql
SELECT *
FROM student AS a
RIGHT JOIN course AS b
ON a.student_id = b.student_id
WHERE a.student_id IS NULL;
```

**Result:** `math (105)` and `computer science (107)`, since these courses have no matching student.

---

## 11. Join Comparison Table

| Join Type | Returns | Unmatched Rows Included? |
|---|---|---|
| **INNER JOIN** | Only matching rows from both tables | No |
| **LEFT JOIN** | All rows from left + matched from right | Yes (from left only) |
| **RIGHT JOIN** | All rows from right + matched from left | Yes (from right only) |
| **FULL JOIN** | All rows from both tables | Yes (from both) |
| **SELF JOIN** | Table joined with itself | Depends on join type used |
| **NATURAL JOIN** | Auto-joined on same-named columns | No (acts like INNER JOIN) |
| **CROSS JOIN** | Cartesian product of both tables | N/A (no matching condition) |
| **LEFT EXCLUSIVE** | Only unmatched rows from left table | Only unmatched (left) |
| **RIGHT EXCLUSIVE** | Only unmatched rows from right table | Only unmatched (right) |

**Visual summary:**

```
INNER JOIN        →   A ∩ B
LEFT JOIN          →   A ∪ (A ∩ B)
RIGHT JOIN         →   B ∪ (A ∩ B)
FULL JOIN           →   A ∪ B
LEFT EXCLUSIVE   →   A - B
RIGHT EXCLUSIVE  →   B - A
```

---

## Practice Questions — Part 3

1. Create `student` and `course` tables as shown above and populate them with the sample data.
2. Write an `INNER JOIN` query to display each student along with their enrolled course.
3. Write a `LEFT JOIN` query to display all students, including those without a course.
4. Write a `RIGHT JOIN` query to display all courses, including those without an enrolled student.
5. Write a query to simulate a `FULL OUTER JOIN` in MySQL using `UNION`.
6. Write a query to find students who are **not enrolled** in any course (Left Exclusive Join).
7. Write a query to find courses that have **no students enrolled** (Right Exclusive Join).
8. Write a `SELF JOIN` query on an `employee` table to display each employee along with their manager's name.
9. Write a query using `NATURAL JOIN` between `student` and `course`.
10. Write the same query as Q9, but using the `USING` clause instead.
11. What is the result-set size of `SELECT * FROM student CROSS JOIN course;` if `student` has 3 rows and `course` has 4 rows?
12. Explain the difference between `NATURAL JOIN` and `INNER JOIN ... ON`.
13. Write a query to find the number of students enrolled in each course using `INNER JOIN` + `GROUP BY`.
14. Explain, with an example, why `NATURAL JOIN` can be risky in real-world tables with many columns.
15. Draw (in words) the Venn diagram logic behind `LEFT JOIN`, `RIGHT JOIN`, and `FULL JOIN`.

---

**End of Part 3 — Continue to Part 4: Subqueries & Set Operations**
