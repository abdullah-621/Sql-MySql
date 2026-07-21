# SQL Handbook — Part 8: CTEs, Stored Procedures, Triggers & Transactions

*This part uses the `employee` table from Part 5.*

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

## SECTION A — Common Table Expressions (CTE)

## 1. WITH Clause (CTE)

A **CTE (Common Table Expression)** is a temporary, named result set defined using the `WITH` keyword. It exists only for the duration of the query and makes complex subqueries far more readable.

**Syntax:**
```sql
WITH cte_name AS (
    SELECT column(s) FROM table_name WHERE condition
)
SELECT * FROM cte_name;
```

**Example — rewriting a subquery as a CTE:**
```sql
WITH high_earners AS (
    SELECT * FROM employee WHERE salary > 55000
)
SELECT name, department FROM high_earners;
```

**Example — CTE with aggregation:**
```sql
WITH dept_totals AS (
    SELECT department, SUM(salary) AS total_salary
    FROM employee
    GROUP BY department
)
SELECT * FROM dept_totals
WHERE total_salary > 100000;
```

### Subquery vs CTE

| Feature | Subquery | CTE (`WITH`) |
|---|---|---|
| Readability | Harder for complex/nested queries | Easier — named, top-down structure |
| Reusability in same query | No (must repeat) | Yes (can reference multiple times) |
| Supports recursion | No | Yes (`WITH RECURSIVE`) |

---

## 2. Multiple CTEs

You can define **more than one CTE** in a single query, separated by commas.

**Syntax:**
```sql
WITH cte1 AS (...),
     cte2 AS (...)
SELECT * FROM cte1
JOIN cte2 ON ...;
```

**Example:**
```sql
WITH sales_dept AS (
    SELECT * FROM employee WHERE department = "Sales"
),
it_dept AS (
    SELECT * FROM employee WHERE department = "IT"
)
SELECT s.name AS sales_emp, i.name AS it_emp
FROM sales_dept s, it_dept i;
```

---

## 3. Recursive CTE

A **Recursive CTE** references itself, and is commonly used for hierarchical data (e.g., org charts, category trees).

**Syntax:**
```sql
WITH RECURSIVE cte_name AS (
    -- anchor member (base case)
    SELECT ...
    UNION ALL
    -- recursive member
    SELECT ...
    FROM cte_name
    WHERE ...
)
SELECT * FROM cte_name;
```

**Example — Generate numbers from 1 to 5:**
```sql
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 5
)
SELECT * FROM numbers;
```

**Output:**
```
1
2
3
4
5
```

**Example — Employee-manager hierarchy (using an `employee` table with a `manager_id` column):**
```sql
WITH RECURSIVE org_chart AS (
    SELECT emp_id, name, manager_id, 1 AS level
    FROM employee WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.name, e.manager_id, o.level + 1
    FROM employee e
    JOIN org_chart o ON e.manager_id = o.emp_id
)
SELECT * FROM org_chart;
```

---

## SECTION B — Stored Procedures & Functions

## 4. Stored Procedure

A **Stored Procedure** is a saved block of SQL code that can be executed (called) repeatedly, optionally accepting parameters. Useful for reusable business logic.

**Syntax:**
```sql
DELIMITER //
CREATE PROCEDURE procedure_name (parameters)
BEGIN
    -- SQL statements
END //
DELIMITER ;
```

**Example — simple procedure with no parameters:**
```sql
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM employee;
END //
DELIMITER ;

CALL GetAllEmployees();
```

**Example — procedure with an input parameter:**
```sql
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
    SELECT * FROM employee WHERE department = dept_name;
END //
DELIMITER ;

CALL GetEmployeesByDept("Sales");
```

**Example — procedure with IN and OUT parameters:**
```sql
DELIMITER //
CREATE PROCEDURE GetAvgSalary(IN dept_name VARCHAR(50), OUT avg_sal DECIMAL(10,2))
BEGIN
    SELECT AVG(salary) INTO avg_sal
    FROM employee WHERE department = dept_name;
END //
DELIMITER ;

CALL GetAvgSalary("IT", @result);
SELECT @result;
```

**Drop a procedure:**
```sql
DROP PROCEDURE GetAllEmployees;
```

> **Note:** `DELIMITER //` temporarily changes the statement terminator from `;` to `//`, so the semicolons inside the procedure body don't end the `CREATE PROCEDURE` statement early.

---

## 5. Stored Function

A **Stored Function** is similar to a procedure, but it **must return a single value**, and can be used directly inside a `SELECT` statement (unlike a procedure, which is called with `CALL`).

**Syntax:**
```sql
DELIMITER //
CREATE FUNCTION function_name (parameters)
RETURNS datatype
DETERMINISTIC
BEGIN
    -- logic
    RETURN value;
END //
DELIMITER ;
```

**Example:**
```sql
DELIMITER //
CREATE FUNCTION GetBonus(salary INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN salary * 0.10;
END //
DELIMITER ;

SELECT name, salary, GetBonus(salary) AS bonus
FROM employee;
```

**Drop a function:**
```sql
DROP FUNCTION GetBonus;
```

### Procedure vs Function

| Feature | Stored Procedure | Stored Function |
|---|---|---|
| Return value | Optional (0, 1, or via OUT params) | Must return exactly one value |
| Called using | `CALL procedure_name()` | Used inside `SELECT` like a normal function |
| Can modify data | Yes | Generally restricted (best used for calculations) |

---

## SECTION C — Triggers

## 6. Trigger

A **Trigger** is a block of SQL code that automatically executes in response to a specific event (`INSERT`, `UPDATE`, or `DELETE`) on a table.

**Syntax:**
```sql
DELIMITER //
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
FOR EACH ROW
BEGIN
    -- logic
END //
DELIMITER ;
```

**Example — log every new employee insert into an audit table:**
```sql
CREATE TABLE employee_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    action VARCHAR(20),
    log_time DATETIME
);

DELIMITER //
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action, log_time)
    VALUES (NEW.emp_id, "INSERTED", NOW());
END //
DELIMITER ;
```

Now, whenever a row is inserted into `employee`, a matching log row is automatically created in `employee_log`.

**Example — prevent negative salary using a BEFORE INSERT trigger:**
```sql
DELIMITER //
CREATE TRIGGER before_salary_check
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SET NEW.salary = 0;
    END IF;
END //
DELIMITER ;
```

**Drop a trigger:**
```sql
DROP TRIGGER after_employee_insert;
```

> **Note:** Inside a trigger, `NEW` refers to the row **after** the change (available in `INSERT`/`UPDATE` triggers), and `OLD` refers to the row **before** the change (available in `UPDATE`/`DELETE` triggers).

---

## SECTION D — Transactions (TCL in Detail)

## 7. Transaction Basics

A **Transaction** is a group of SQL statements executed as a single logical unit of work — either **all** statements succeed, or **none** of them do (this is called atomicity).

**The four ACID properties of a transaction:**

| Property | Meaning |
|---|---|
| **Atomicity** | All statements succeed, or none do |
| **Consistency** | Database moves from one valid state to another |
| **Isolation** | Concurrent transactions don't interfere with each other |
| **Durability** | Once committed, changes are permanent (survive crashes) |

---

## 8. START TRANSACTION

Marks the beginning of a transaction.

**Syntax:**
```sql
START TRANSACTION;
-- or
BEGIN;
```

---

## 9. COMMIT

Saves all changes made during the current transaction **permanently** to the database.

**Syntax:**
```sql
COMMIT;
```

**Example — bank transfer (classic transaction example):**
```sql
START TRANSACTION;

UPDATE account SET balance = balance - 1000 WHERE acc_id = 1;
UPDATE account SET balance = balance + 1000 WHERE acc_id = 2;

COMMIT;
```

Both `UPDATE` statements succeed together — money is deducted from one account and added to another as a single atomic operation.

---

## 10. ROLLBACK

Undoes all changes made during the current transaction (since the last `START TRANSACTION` or `COMMIT`).

**Syntax:**
```sql
ROLLBACK;
```

**Example — cancel a transaction if something goes wrong:**
```sql
START TRANSACTION;

UPDATE account SET balance = balance - 1000 WHERE acc_id = 1;
UPDATE account SET balance = balance + 1000 WHERE acc_id = 2;

-- if an error is detected here:
ROLLBACK;   -- both updates above are undone
```

---

## 11. SAVEPOINT

Creates a named checkpoint **within** a transaction, allowing partial rollback to that specific point instead of rolling back the entire transaction.

**Syntax:**
```sql
SAVEPOINT savepoint_name;
ROLLBACK TO savepoint_name;
```

**Example:**
```sql
START TRANSACTION;

UPDATE employee SET salary = salary + 5000 WHERE emp_id = 1;
SAVEPOINT sp1;

UPDATE employee SET salary = salary + 5000 WHERE emp_id = 2;
SAVEPOINT sp2;

UPDATE employee SET salary = salary - 100000 WHERE emp_id = 3;  -- mistake!

ROLLBACK TO sp2;   -- undoes only the mistaken update, keeps emp_id=1 and emp_id=2 changes

COMMIT;
```

---

## 12. AUTOCOMMIT

By default, MySQL runs in **autocommit mode**, meaning every individual statement is automatically committed as its own transaction. `START TRANSACTION` temporarily disables this until `COMMIT` or `ROLLBACK` is called.

**Check/toggle autocommit:**
```sql
SELECT @@autocommit;

SET autocommit = 0;   -- disable autocommit (manual transaction mode)
SET autocommit = 1;   -- re-enable autocommit
```

### TCL Commands Summary

| Command | Purpose |
|---|---|
| `START TRANSACTION` | Begin a new transaction |
| `COMMIT` | Save all changes permanently |
| `ROLLBACK` | Undo all changes in the current transaction |
| `SAVEPOINT` | Set a checkpoint within a transaction |
| `ROLLBACK TO savepoint` | Undo changes back to a specific savepoint |

---

## Practice Questions — Part 8

1. Rewrite a subquery that finds employees earning above the company average salary, using a CTE instead.
2. Write a query using multiple CTEs to compare `Sales` and `IT` department employees side by side.
3. Write a Recursive CTE to generate numbers from 1 to 10.
4. Write a Stored Procedure `GetEmployeesByDept` that accepts a department name and returns matching employees.
5. Write a Stored Function `CalculateBonus(salary)` that returns 15% of the input salary.
6. Write a Trigger that automatically logs every `DELETE` operation on the `employee` table into an `employee_log` table.
7. Write a Trigger that prevents inserting an employee with a salary below 10000 (set it to 10000 instead).
8. Explain, with a bank-transfer example, why `COMMIT` and `ROLLBACK` are important for data integrity.
9. Write a transaction that updates two rows, uses a `SAVEPOINT` after the first update, and rolls back only to that savepoint after an error in the second update.
10. Explain the four ACID properties with a one-line example each.
11. What is the difference between a Stored Procedure and a Stored Function? Give one example of each.
12. What is the difference between `DROP`, `ROLLBACK`, and `TRUNCATE` in terms of undoing data changes?

---

**End of Part 8 — Continue to Part 9: SQL Theory (Normalization & ER Diagrams)**
