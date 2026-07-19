# SQL Handbook — Part 5: Advanced SQL

## Sample Data Used in This Part

```sql
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employee VALUES
(1, "adam", "Sales", 50000),
(2, "bob", "Sales", 60000),
(3, "casey", "Sales", 55000),
(4, "donald", "IT", 70000),
(5, "emma", "IT", 65000),
(6, "farah", "HR", 40000),
(7, "george", "HR", 45000);
```

---

## 1. Views (MySQL Views)

A **view** is a **virtual table** based on the result-set of a stored SQL statement. A view does not store data itself — it dynamically pulls data from the underlying table(s) each time it's queried.

**Syntax — Create a view:**
```sql
CREATE VIEW view_name AS
SELECT column(s) FROM table_name
WHERE condition;
```

**Example:**
```sql
CREATE VIEW view1 AS
SELECT rollno, name FROM student;

SELECT * FROM view1;
```

**Example — View with a join:**
```sql
CREATE VIEW high_earners AS
SELECT name, department, salary
FROM employee
WHERE salary > 55000;

SELECT * FROM high_earners;
```

**Update a view:**
```sql
CREATE OR REPLACE VIEW view1 AS
SELECT rollno, name, marks FROM student;
```

**Delete a view:**
```sql
DROP VIEW view1;
```

> **Note:** A view always shows **up-to-date data**. The database engine re-executes the underlying query every time a user queries the view — it's not a snapshot/copy of data.

**Why use Views?**
- Simplify complex queries (hide joins/subqueries behind a simple `SELECT * FROM view`)
- Restrict access to specific columns/rows (security)
- Provide a consistent interface even if underlying table structure changes

---

## 2. Index

An **Index** is a special lookup structure that improves the speed of data retrieval operations on a table, at the cost of additional storage and slightly slower writes (`INSERT`/`UPDATE`/`DELETE`).

Think of an index like the index at the back of a book — instead of scanning every page, you jump directly to the relevant page.

**Syntax — Create an index:**
```sql
CREATE INDEX index_name
ON table_name (column_name);
```

**Example:**
```sql
CREATE INDEX idx_city ON student (city);
```

**Unique Index** (also enforces uniqueness):
```sql
CREATE UNIQUE INDEX idx_email ON employee (email);
```

**Composite Index (multiple columns):**
```sql
CREATE INDEX idx_dept_salary ON employee (department, salary);
```

**Drop an index:**
```sql
DROP INDEX idx_city ON student;
```

**View indexes on a table:**
```sql
SHOW INDEX FROM student;
```

> **Note:** Primary Keys and Unique constraints automatically create an index. Indexes are best added to columns frequently used in `WHERE`, `JOIN`, and `ORDER BY` clauses. Avoid over-indexing — every index slows down `INSERT`/`UPDATE`/`DELETE` operations.

---

## 3. Roles

A **Role** is a named collection of privileges that can be assigned to one or more users — useful for managing permissions for groups of users efficiently instead of granting privileges individually.

**Syntax — Create a role:**
```sql
CREATE ROLE role_name;
```

**Example:**
```sql
CREATE ROLE 'manager';
```

**Grant privileges to a role:**
```sql
GRANT SELECT, INSERT ON college.* TO 'manager';
```

**Assign the role to a user:**
```sql
GRANT 'manager' TO 'riya'@'localhost';
```

**Activate the role for a session:**
```sql
SET DEFAULT ROLE 'manager' TO 'riya'@'localhost';
```

**Drop a role:**
```sql
DROP ROLE 'manager';
```

---

## 4. GRANT

Used to give specific privileges to a user (or role) on a database or table.

**Syntax:**
```sql
GRANT privilege_type ON database_name.table_name
TO 'username'@'host';
```

**Example — Grant SELECT permission:**
```sql
GRANT SELECT ON college.student TO 'riya'@'localhost';
```

**Example — Grant multiple privileges:**
```sql
GRANT SELECT, INSERT, UPDATE ON college.* TO 'riya'@'localhost';
```

**Example — Grant ALL privileges:**
```sql
GRANT ALL PRIVILEGES ON college.* TO 'admin'@'localhost';
```

Apply changes immediately:
```sql
FLUSH PRIVILEGES;
```

---

## 5. REVOKE

Used to remove previously granted privileges from a user (or role).

**Syntax:**
```sql
REVOKE privilege_type ON database_name.table_name
FROM 'username'@'host';
```

**Example:**
```sql
REVOKE INSERT ON college.student FROM 'riya'@'localhost';
```

**Example — Revoke all privileges:**
```sql
REVOKE ALL PRIVILEGES ON college.* FROM 'riya'@'localhost';
```

### GRANT vs REVOKE

| Command | Purpose |
|---|---|
| `GRANT` | Gives a privilege to a user/role |
| `REVOKE` | Removes a previously given privilege |

---

## 6. Window Functions — Introduction

A **Window Function** performs a calculation across a **set of rows related to the current row**, without collapsing them into a single output row (unlike `GROUP BY`, which reduces multiple rows into one).

The "window" is defined using the `OVER()` clause.

**General Syntax:**
```sql
SELECT column(s),
    WINDOW_FUNCTION() OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS alias
FROM table_name;
```

### GROUP BY vs Window Functions

| Feature | GROUP BY | Window Function |
|---|---|---|
| Rows in output | Reduced (one row per group) | Same as input (all rows retained) |
| Can view individual row + aggregate together | No | Yes |
| Requires | Aggregate function | `OVER()` clause |

---

## 7. OVER()

Defines the **window** (set of rows) that a window function operates on. Used alongside window functions like `ROW_NUMBER()`, `RANK()`, `SUM()`, etc.

**Syntax:**
```sql
SELECT column(s),
    AGG_FUNC(column) OVER () AS alias
FROM table_name;
```

**Example — total company salary shown next to every row:**
```sql
SELECT name, department, salary,
    SUM(salary) OVER () AS total_company_salary
FROM employee;
```

Here, `SUM(salary) OVER()` computes the sum across **all rows** but still returns one row per employee (unlike `GROUP BY`, which would collapse everything into a single row).

---

## 8. PARTITION BY

Divides the result set into **partitions** (groups), similar to `GROUP BY`, but the window function is calculated **separately within each partition** while still returning all individual rows.

**Syntax:**
```sql
SELECT column(s),
    WINDOW_FUNCTION() OVER (
        PARTITION BY col_name
    ) AS alias
FROM table_name;
```

**Example — total salary per department, shown next to every employee:**
```sql
SELECT name, department, salary,
    SUM(salary) OVER (PARTITION BY department) AS dept_total
FROM employee;
```

**Result:**

| name | department | salary | dept_total |
|---|---|---|---|
| adam | Sales | 50000 | 165000 |
| bob | Sales | 60000 | 165000 |
| casey | Sales | 55000 | 165000 |
| donald | IT | 70000 | 135000 |
| emma | IT | 65000 | 135000 |
| farah | HR | 40000 | 85000 |
| george | HR | 45000 | 85000 |

---

## 9. ROW_NUMBER()

Assigns a **unique sequential number** to each row within a partition, starting at 1, based on the specified `ORDER BY`. No ties — every row gets a distinct number.

**Syntax:**
```sql
SELECT column(s),
    ROW_NUMBER() OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS row_num
FROM table_name;
```

**Example — Rank employees by salary within each department:**
```sql
SELECT name, department, salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS row_num
FROM employee;
```

**Result:**

| name | department | salary | row_num |
|---|---|---|---|
| bob | Sales | 60000 | 1 |
| casey | Sales | 55000 | 2 |
| adam | Sales | 50000 | 3 |
| donald | IT | 70000 | 1 |
| emma | IT | 65000 | 2 |
| george | HR | 45000 | 1 |
| farah | HR | 40000 | 2 |

**Common use case — find the top earner in each department:**
```sql
SELECT * FROM (
    SELECT name, department, salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employee
) t
WHERE rn = 1;
```

---

## 10. RANK()

Assigns a rank to each row within a partition based on `ORDER BY`. **Rows with equal values get the same rank**, and the next rank **skips** numbers accordingly (gap in ranking).

**Syntax:**
```sql
SELECT column(s),
    RANK() OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS rank_num
FROM table_name;
```

**Example — with a tie in salary (65000 appears twice):**
```sql
SELECT name, salary,
    RANK() OVER (ORDER BY salary DESC) AS rnk
FROM employee;
```

**Result (assuming donald & emma both had 65000):**

| name | salary | rnk |
|---|---|---|
| donald | 65000 | 1 |
| emma | 65000 | 1 |
| bob | 60000 | 3 |
| casey | 55000 | 4 |
| adam | 50000 | 5 |
| george | 45000 | 6 |
| farah | 40000 | 7 |

> **Note:** Notice rank `2` is **skipped** after the tie at rank 1 — this is the defining behavior of `RANK()`.

---

## 11. DENSE_RANK()

Same as `RANK()`, but **does not skip** numbers after a tie — ranks remain **consecutive**.

**Syntax:**
```sql
SELECT column(s),
    DENSE_RANK() OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS dense_rnk
FROM table_name;
```

**Example (same data as above):**
```sql
SELECT name, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employee;
```

**Result:**

| name | salary | dense_rnk |
|---|---|---|
| donald | 65000 | 1 |
| emma | 65000 | 1 |
| bob | 60000 | 2 |
| casey | 55000 | 3 |
| adam | 50000 | 4 |
| george | 45000 | 5 |
| farah | 40000 | 6 |

### ROW_NUMBER() vs RANK() vs DENSE_RANK()

| Function | Ties Handled | Gaps After Ties |
|---|---|---|
| `ROW_NUMBER()` | No — every row gets a unique number | N/A |
| `RANK()` | Yes — same rank for ties | Yes (skips numbers) |
| `DENSE_RANK()` | Yes — same rank for ties | No (consecutive numbers) |

---

## 12. LAG()

Accesses data from the **previous row** in the result set (within the same partition), without needing a self-join.

**Syntax:**
```sql
SELECT column(s),
    LAG(col_name, offset, default_value) OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS alias
FROM table_name;
```

**Example — compare each employee's salary to the previous employee's salary (ordered by salary):**
```sql
SELECT name, salary,
    LAG(salary, 1, 0) OVER (ORDER BY salary) AS prev_salary
FROM employee;
```

**Result (partial):**

| name | salary | prev_salary |
|---|---|---|
| farah | 40000 | 0 |
| george | 45000 | 40000 |
| adam | 50000 | 45000 |
| casey | 55000 | 50000 |

> **Note:** `offset` (default 1) specifies how many rows back to look; `default_value` (default `NULL`) is returned when there's no previous row.

---

## 13. LEAD()

Accesses data from the **next row** in the result set (within the same partition) — the opposite of `LAG()`.

**Syntax:**
```sql
SELECT column(s),
    LEAD(col_name, offset, default_value) OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS alias
FROM table_name;
```

**Example:**
```sql
SELECT name, salary,
    LEAD(salary, 1, 0) OVER (ORDER BY salary) AS next_salary
FROM employee;
```

**Result (partial):**

| name | salary | next_salary |
|---|---|---|
| farah | 40000 | 45000 |
| george | 45000 | 50000 |
| adam | 50000 | 55000 |
| casey | 55000 | 60000 |

> **Common use case:** `LAG()`/`LEAD()` are widely used for month-over-month or day-over-day comparisons in time-series data (e.g., comparing today's sales to yesterday's sales).

---

## 14. FIRST_VALUE()

Returns the **first value** in an ordered partition/window.

**Syntax:**
```sql
SELECT column(s),
    FIRST_VALUE(col_name) OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS alias
FROM table_name;
```

**Example — show the lowest-paid employee's salary next to every employee, per department:**
```sql
SELECT name, department, salary,
    FIRST_VALUE(salary) OVER (
        PARTITION BY department
        ORDER BY salary ASC
    ) AS lowest_in_dept
FROM employee;
```

---

## 15. LAST_VALUE()

Returns the **last value** in an ordered partition/window.

**Syntax:**
```sql
SELECT column(s),
    LAST_VALUE(col_name) OVER (
        PARTITION BY col_name
        ORDER BY col_name
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS alias
FROM table_name;
```

**Example — show the highest-paid employee's salary next to every employee, per department:**
```sql
SELECT name, department, salary,
    LAST_VALUE(salary) OVER (
        PARTITION BY department
        ORDER BY salary ASC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_in_dept
FROM employee;
```

> **Note:** By default, the window frame only looks "up to the current row." You must explicitly specify `RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` for `LAST_VALUE()` to consider the **entire** partition — otherwise it just returns the current row's own value.

---

## 16. NTILE()

Divides the ordered rows in a partition into a specified **number of roughly equal groups (buckets)**, and returns the bucket number for each row.

**Syntax:**
```sql
SELECT column(s),
    NTILE(n) OVER (
        PARTITION BY col_name
        ORDER BY col_name
    ) AS bucket
FROM table_name;
```

**Example — divide employees into 3 salary-based groups (buckets):**
```sql
SELECT name, salary,
    NTILE(3) OVER (ORDER BY salary DESC) AS salary_bucket
FROM employee;
```

**Result (7 employees split into 3 buckets):**

| name | salary | salary_bucket |
|---|---|---|
| donald | 70000 | 1 |
| emma | 65000 | 1 |
| bob | 60000 | 1 |
| casey | 55000 | 2 |
| adam | 50000 | 2 |
| george | 45000 | 3 |
| farah | 40000 | 3 |

> **Common use case:** `NTILE(4)` is often used to split data into **quartiles** for statistical analysis.

---

## 17. ROLLUP

An extension to `GROUP BY` that generates **subtotal rows** and a **grand total row**, in addition to the normal grouped rows — useful for hierarchical summaries.

**Syntax (MySQL):**
```sql
SELECT col1, col2, AGG_FUNC(col3)
FROM table_name
GROUP BY col1, col2 WITH ROLLUP;
```

**Example:**
```sql
SELECT department, SUM(salary) AS total_salary
FROM employee
GROUP BY department WITH ROLLUP;
```

**Result:**

| department | total_salary |
|---|---|
| HR | 85000 |
| IT | 135000 |
| Sales | 165000 |
| NULL | 385000 |   ← Grand total row

> **Note:** In the grand total row, MySQL displays `NULL` for the grouped column — this represents "all departments combined."

---

## 18. CUBE

Similar to `ROLLUP`, but generates subtotals for **all possible combinations** of the grouped columns (not just a hierarchical rollup).

**Syntax (standard SQL — PostgreSQL, SQL Server, Oracle):**
```sql
SELECT col1, col2, AGG_FUNC(col3)
FROM table_name
GROUP BY CUBE (col1, col2);
```

**Example:**
```sql
SELECT department, name, SUM(salary)
FROM employee
GROUP BY CUBE (department, name);
```

This produces subtotal rows for:
- every `(department, name)` combination
- every `department` alone (across all names)
- every `name` alone (across all departments)
- the grand total (all rows combined)

> **Note:** MySQL does **not** natively support `CUBE` — it must be simulated using multiple `UNION`-ed `GROUP BY` queries, or by using `GROUPING SETS` in databases that support it.

---

## 19. GROUPING

`GROUPING()` is a function used alongside `ROLLUP`/`CUBE` to identify whether a `NULL` in the result is a **real NULL from the data**, or a **placeholder NULL generated by ROLLUP/CUBE** for a subtotal/grand-total row. It returns `1` for generated NULLs, and `0` otherwise.

**Syntax:**
```sql
SELECT col1, GROUPING(col1) AS is_subtotal, AGG_FUNC(col2)
FROM table_name
GROUP BY col1 WITH ROLLUP;
```

**Example:**
```sql
SELECT department, GROUPING(department) AS is_total, SUM(salary)
FROM employee
GROUP BY department WITH ROLLUP;
```

**Result:**

| department | is_total | SUM(salary) |
|---|---|---|
| HR | 0 | 85000 |
| IT | 0 | 135000 |
| Sales | 0 | 165000 |
| NULL | 1 | 385000 |  ← `is_total = 1` confirms this NULL is the grand-total row, not real data

---

## 20. GROUPING SETS

Allows you to specify **multiple, custom groupings** in a single query — more flexible than `ROLLUP`/`CUBE`, since you control exactly which combinations to compute.

**Syntax (standard SQL):**
```sql
SELECT col1, col2, AGG_FUNC(col3)
FROM table_name
GROUP BY GROUPING SETS (
    (col1, col2),
    (col1),
    (col2),
    ()
);
```

**Example:**
```sql
SELECT department, name, SUM(salary)
FROM employee
GROUP BY GROUPING SETS (
    (department, name),  -- subtotal per employee within department
    (department),        -- subtotal per department
    ()                    -- grand total
);
```

> **Note:** `GROUPING SETS` is supported in PostgreSQL, SQL Server, and Oracle. In MySQL, it's typically simulated using separate `GROUP BY` queries combined with `UNION ALL`.

### ROLLUP vs CUBE vs GROUPING SETS

| Feature | Generates | Flexibility |
|---|---|---|
| `ROLLUP` | Hierarchical subtotals (left-to-right) + grand total | Low — fixed hierarchy |
| `CUBE` | All possible combinations of grouped columns | High — but can be excessive |
| `GROUPING SETS` | Only the specific combinations you list | Highest — fully customizable |

---

## Practice Questions — Part 5

1. Create a view `high_earners` that shows employees with salary above 55000.
2. Write a query to create an index on the `department` column of the `employee` table.
3. Explain the difference between `GRANT` and `REVOKE` with one example each.
4. Create a role `analyst` and grant it `SELECT` privileges on the `college` database.
5. Write a query using `ROW_NUMBER()` to number employees within each department, ordered by salary descending.
6. Write a query using `RANK()` and `DENSE_RANK()` on the same dataset, and explain the difference in output when there's a tie.
7. Write a query using `PARTITION BY` to show the total salary of each department next to every employee row.
8. Write a query using `LAG()` to compare each employee's salary to the previous employee's salary (ordered by salary).
9. Write a query using `LEAD()` to show the next higher salary for each employee.
10. Write a query using `FIRST_VALUE()` and `LAST_VALUE()` to show the lowest and highest salary in each department, next to every row.
11. Write a query using `NTILE(4)` to split employees into 4 salary-based quartiles.
12. Write a query using `GROUP BY ... WITH ROLLUP` to get department-wise salary totals along with a grand total.
13. Write a query using `GROUPING()` to distinguish real NULLs from ROLLUP-generated NULLs.
14. Explain, with an example, the difference between `ROLLUP`, `CUBE`, and `GROUPING SETS`.
15. Write a query that uses a window function to find the top 2 highest-paid employees in each department (Hint: use `ROW_NUMBER()` inside a subquery).

---

**End of Part 5 — End of SQL Handbook**

*This concludes the 5-part SQL Handbook: Basics → Filtering & Grouping → Joins → Subqueries & Set Operations → Advanced SQL.*
