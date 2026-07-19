# SQL Handbook — Part 1: SQL Basics

---

## 1. Introduction to Database

A **database** is a collection of data stored in a digital format that can be easily accessed, managed, and updated.

Instead of storing information in loose files (like spreadsheets or text files), a database organizes data in a structured way so that it can be searched, filtered, updated, and related to other data efficiently.

**Real-world example:** A college storing information about students, courses, and marks. Instead of keeping this in separate Excel sheets, a database stores it in an organized, connected way.

**Why we need databases:**
- Fast retrieval of data
- Avoids data duplication
- Ensures data consistency
- Supports multiple users at once
- Provides security and access control

---

## 2. DBMS (Database Management System)

A **DBMS** is software used to create, manage, and interact with databases.

It sits between the user/application and the actual data, and handles operations like storing, retrieving, updating, and deleting data.

**Examples of DBMS software:** MySQL, PostgreSQL, Oracle, Microsoft SQL Server, MongoDB.

**Functions of a DBMS:**
- Data storage management
- Data security and access control
- Backup and recovery
- Enforcing data integrity rules
- Handling concurrent access by multiple users

**Types of Databases:**

| Type | Description | Examples |
|---|---|---|
| Relational (SQL) | Data stored in tables (rows & columns) | MySQL, SQL Server, Oracle, PostgreSQL |
| Non-Relational (NoSQL) | Data not stored in tables (documents, key-value, graphs) | MongoDB, Redis, Cassandra |

> **Note:** We use SQL specifically to interact with **relational** databases.

---

## 3. RDBMS (Relational Database Management System)

An **RDBMS** is a type of DBMS that stores data in the form of **tables** (also called relations), where:
- Each table has **rows** (records/tuples) and **columns** (fields/attributes)
- Tables can be **related** to each other using keys (Primary Key & Foreign Key)

**Database Structure:**

```
Database
 ├── Table 1
 │     └── Data (rows & columns)
 └── Table 2
       └── Data (rows & columns)
```

**Example — Student Table:**

| RollNo | Name | Class | DOB | Gender | City | Marks |
|---|---|---|---|---|---|---|
| 1 | Nanda | X | 1995-06-06 | M | Agra | 551 |
| 2 | Saurabh | XII | 1993-05-07 | M | Mumbai | 462 |
| 3 | Sonal | XI | 1994-05-06 | F | Delhi | 400 |
| 4 | Trisla | XII | 1995-08-08 | F | Mumbai | 450 |

Popular RDBMS software: **MySQL, PostgreSQL, Oracle Database, Microsoft SQL Server**.

---

## 4. Introduction to SQL

**SQL** stands for **Structured Query Language**.

SQL is a **programming language** used to interact with **relational databases**. It allows us to create databases/tables, insert data, retrieve data, update data, delete data, and control access to data.

SQL is used to perform **CRUD** operations:

| Letter | Operation | SQL Command |
|---|---|---|
| C | Create | `INSERT` |
| R | Read | `SELECT` |
| U | Update | `UPDATE` |
| D | Delete | `DELETE` |

### Types of SQL Commands

| Category | Full Form | Commands | Purpose |
|---|---|---|---|
| **DDL** | Data Definition Language | `CREATE`, `ALTER`, `RENAME`, `TRUNCATE`, `DROP` | Defines/modifies structure of database objects |
| **DQL** | Data Query Language | `SELECT` | Used to query/retrieve data |
| **DML** | Data Manipulation Language | `SELECT`, `INSERT`, `UPDATE`, `DELETE` | Used to manipulate data inside tables |
| **DCL** | Data Control Language | `GRANT`, `REVOKE` | Grants/revokes permissions to users |
| **TCL** | Transaction Control Language | `START TRANSACTION`, `COMMIT`, `ROLLBACK` | Manages transactions |

> **Note:** SQL keywords are **not case-sensitive** (`SELECT` and `select` work the same), but it's a best practice to write keywords in UPPERCASE for readability.

---

## 5. SQL Datatypes

Datatypes define the **type of values** that can be stored in a column.

| Datatype | Description | Usage Example |
|---|---|---|
| `CHAR` | Fixed-length string (0–255 chars) | `CHAR(50)` |
| `VARCHAR` | Variable-length string (0–255 chars) | `VARCHAR(50)` |
| `BLOB` | Binary Large Object (0–65535 bytes) | `BLOB(1000)` |
| `INT` | Integer (-2,147,483,648 to 2,147,483,647) | `INT` |
| `TINYINT` | Small integer (-128 to 127) | `TINYINT` |
| `BIGINT` | Large integer (-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807) | `BIGINT` |
| `BIT` | x-bit values, x from 1 to 64 | `BIT(2)` |
| `FLOAT` | Decimal number, precision up to 23 digits | `FLOAT` |
| `DOUBLE` | Decimal number, precision 24–53 digits | `DOUBLE` |
| `BOOLEAN` | Boolean value: 0 or 1 | `BOOLEAN` |
| `DATE` | Date in format `YYYY-MM-DD` (1000-01-01 to 9999-12-31) | `DATE` |
| `YEAR` | 4-digit year (1901 to 2155) | `YEAR` |

### Signed vs Unsigned

Numeric types can be **signed** (allow negative numbers) or **unsigned** (only positive numbers, but with a higher upper limit).

```sql
TINYINT           -- range: -128 to 127
TINYINT UNSIGNED  -- range: 0 to 255
```

> **Note:** Choosing the right datatype and size matters for storage efficiency. Don't use `BIGINT` for a column that will only ever store small numbers like age.

---

## 6. CREATE DATABASE

Used to create a new database.

**Syntax:**
```sql
CREATE DATABASE db_name;
```

**Example:**
```sql
CREATE DATABASE college;
```

To avoid an error if the database already exists:
```sql
CREATE DATABASE IF NOT EXISTS college;
```

> **Note:** Database names should not contain spaces; use underscores instead (e.g., `student_db`).

---

## 7. DROP DATABASE

Used to permanently delete an existing database along with all its tables and data.

**Syntax:**
```sql
DROP DATABASE db_name;
```

**Example:**
```sql
DROP DATABASE college;
```

To avoid an error if the database does not exist:
```sql
DROP DATABASE IF EXISTS college;
```

> **Warning:** `DROP DATABASE` is irreversible. All tables and data inside it will be lost permanently. Always take a backup before running this in production.

---

## 8. SHOW DATABASES

Lists all databases present on the current MySQL server.

**Syntax:**
```sql
SHOW DATABASES;
```

**Example Output:**
```
+--------------------+
| Database           |
+--------------------+
| college             |
| information_schema  |
| mysql               |
| test                |
+--------------------+
```

---

## 9. USE DATABASE

Selects a specific database to work with. All subsequent queries will run against this database until changed.

**Syntax:**
```sql
USE db_name;
```

**Example:**
```sql
USE college;
```

You can also view all tables inside the currently selected database:
```sql
SHOW TABLES;
```

---

## 10. CREATE TABLE

Used to create a new table inside a database.

**Syntax:**
```sql
CREATE TABLE table_name (
    column_name1 datatype constraint,
    column_name2 datatype constraint,
    column_name3 datatype constraint
);
```

**Example:**
```sql
CREATE TABLE student (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT NOT NULL
);
```

**Full working example (used throughout this handbook):**
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

> **Note:** Always select the database using `USE` before creating tables in it.

---

## 11. ALTER TABLE

Used to change the structure (schema) of an existing table — add, drop, rename, or modify columns.

### 11.1 ADD Column
```sql
ALTER TABLE table_name
ADD COLUMN column_name datatype constraint;
```
**Example:**
```sql
ALTER TABLE student
ADD COLUMN age INT NOT NULL DEFAULT 19;
```

### 11.2 DROP Column
```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```
**Example:**
```sql
ALTER TABLE student
DROP COLUMN stu_age;
```

### 11.3 RENAME Table
```sql
ALTER TABLE table_name
RENAME TO new_table_name;
```
**Example:**
```sql
ALTER TABLE student
RENAME TO stu;
```

### 11.4 MODIFY Column (change datatype/constraint)
```sql
ALTER TABLE table_name
MODIFY col_name new_datatype new_constraint;
```
**Example:**
```sql
ALTER TABLE student
MODIFY age VARCHAR(2);
```

### 11.5 CHANGE Column (rename + change datatype)
```sql
ALTER TABLE table_name
CHANGE COLUMN old_name new_name new_datatype new_constraint;
```
**Example:**
```sql
ALTER TABLE student
CHANGE age stu_age INT;
```

> **Note:** `MODIFY` changes datatype/constraint but keeps the same column name. `CHANGE` allows renaming the column **along with** changing its datatype.

---

## 12. TRUNCATE

Deletes **all rows/data** from a table, but keeps the table structure intact. It's faster than `DELETE` (without WHERE) because it doesn't log individual row deletions.

**Syntax:**
```sql
TRUNCATE TABLE table_name;
```

**Example:**
```sql
TRUNCATE TABLE student;
```

> **Note:** `TRUNCATE` cannot be used with a `WHERE` clause — it always removes **all** rows. It also resets `AUTO_INCREMENT` counters in most RDBMS.

---

## 13. DROP TABLE

Permanently deletes a table along with its structure and all data.

**Syntax:**
```sql
DROP TABLE table_name;
```

**Example:**
```sql
DROP TABLE student;
```

To avoid errors if the table doesn't exist:
```sql
DROP TABLE IF EXISTS student;
```

### DROP vs TRUNCATE vs DELETE — Comparison

| Feature | DROP | TRUNCATE | DELETE |
|---|---|---|---|
| Removes table structure | Yes | No | No |
| Removes all data | Yes | Yes | Optional (with WHERE) |
| Can use WHERE clause | No | No | Yes |
| Type of command | DDL | DDL | DML |
| Rollback possible (with transaction) | Usually no | Usually no | Yes |

---

## 14. Constraints

SQL **constraints** are rules applied to columns in a table to maintain accuracy and reliability of data.

### 14.1 PRIMARY KEY
A column (or set of columns) that **uniquely identifies each row** in a table.
- Only **one** Primary Key allowed per table
- Must be **NOT NULL** and **unique**

```sql
CREATE TABLE temp (
    id INT NOT NULL,
    PRIMARY KEY (id)
);
```
Or inline:
```sql
id INT PRIMARY KEY
```

### 14.2 FOREIGN KEY
A column (or set of columns) that refers to the **Primary Key** of another table — used to link two tables together.
- A table can have **multiple** Foreign Keys
- Foreign Keys **can** have duplicate and NULL values

```sql
CREATE TABLE temp (
    cust_id INT,
    FOREIGN KEY (cust_id) REFERENCES customer(id)
);
```

**Example (Student & City tables):**

*table1 - Student*

| id | name | cityId | city |
|---|---|---|---|
| 101 | karan | 1 | Pune |
| 102 | arjun | 2 | Mumbai |

*table2 - City*

| id | city_name |
|---|---|
| 1 | Pune |
| 2 | Mumbai |

Here, `cityId` in `Student` is a Foreign Key referencing `id` in `City`.

### 14.3 UNIQUE
Ensures all values in a column are different from each other (but unlike Primary Key, NULLs are allowed, and multiple UNIQUE columns can exist).

```sql
col2 INT UNIQUE
```

### 14.4 NOT NULL
Ensures a column cannot have a NULL (empty) value.

```sql
col1 INT NOT NULL
```

### 14.5 CHECK
Limits the values that can be inserted into a column based on a condition.

```sql
CREATE TABLE city (
    id INT PRIMARY KEY,
    city VARCHAR(50),
    age INT,
    CONSTRAINT age_check CHECK (age >= 18 AND city = "Delhi")
);
```

Simple single-column version:
```sql
CREATE TABLE newTab (
    age INT CHECK (age >= 18)
);
```

### 14.6 DEFAULT
Sets a default value for a column when no value is provided during `INSERT`.

```sql
salary INT DEFAULT 25000
```

### 14.7 AUTO_INCREMENT
Automatically generates a unique number each time a new row is inserted — commonly used with Primary Key columns.

**Syntax:**
```sql
CREATE TABLE table_name (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);
```

**Example:**
```sql
CREATE TABLE employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50)
);

INSERT INTO employee (emp_name) VALUES ("Riya");
INSERT INTO employee (emp_name) VALUES ("Karan");
-- emp_id will automatically become 1, 2, ...
```

### Cascading for Foreign Keys

**ON DELETE CASCADE:** When the referenced row in the parent table is deleted, all matching rows in the child table are automatically deleted too.

**ON UPDATE CASCADE:** When the referenced value in the parent table is updated, matching rows in the child table are automatically updated too.

```sql
CREATE TABLE student (
    id INT PRIMARY KEY,
    courseID INT,
    FOREIGN KEY (courseID) REFERENCES course(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
```

---

## 15. INSERT

Used to add new rows of data into a table.

**Syntax:**
```sql
INSERT INTO table_name (colname1, colname2)
VALUES
(col1_v1, col2_v1),
(col1_v2, col2_v2);
```

**Example — single row:**
```sql
INSERT INTO student (rollno, name)
VALUES (101, "karan");
```

**Example — multiple rows in one statement:**
```sql
INSERT INTO student (rollno, name)
VALUES
(101, "karan"),
(102, "arjun");
```

> **Note:** If inserting values for **all** columns in the exact order they were created, you can skip listing column names:
> ```sql
> INSERT INTO student VALUES (101, "karan", 78, "C", "Pune");
> ```
> But it's best practice to always specify column names explicitly.

---

## 16. UPDATE

Used to modify existing rows in a table.

**Syntax:**
```sql
UPDATE table_name
SET col1 = val1, col2 = val2
WHERE condition;
```

**Example:**
```sql
UPDATE student
SET grade = "O"
WHERE grade = "A";
```

> **Warning:** If you omit the `WHERE` clause, **every row** in the table will be updated!
> ```sql
> UPDATE student SET grade = "O";  -- updates ALL rows
> ```

---

## 17. DELETE

Used to remove existing rows from a table.

**Syntax:**
```sql
DELETE FROM table_name
WHERE condition;
```

**Example:**
```sql
DELETE FROM student
WHERE marks < 33;
```

> **Warning:** If you omit `WHERE`, **all rows** will be deleted (but the table structure remains, unlike `DROP`).
> ```sql
> DELETE FROM student;  -- deletes ALL rows
> ```

---

## 18. SELECT

Used to retrieve/query data from the database. This is the most frequently used SQL command.

**Basic Syntax:**
```sql
SELECT col1, col2 FROM table_name;
```

**Select ALL columns:**
```sql
SELECT * FROM table_name;
```

**Example:**
```sql
SELECT * FROM student;
```

**Select specific columns:**
```sql
SELECT name, marks FROM student;
```

---

## 19. DISTINCT

Used with `SELECT` to return only **unique (non-duplicate)** values from a column.

**Syntax:**
```sql
SELECT DISTINCT col_name FROM table_name;
```

**Example:**
```sql
SELECT DISTINCT city FROM student;
```

**Output (based on our student table):**
```
+--------+
| city   |
+--------+
| Pune   |
| Mumbai |
| Delhi  |
+--------+
```

> **Note:** `DISTINCT` applies to the **combination** of all selected columns, not just one, when multiple columns are selected.
> ```sql
> SELECT DISTINCT city, grade FROM student;
> -- returns unique (city, grade) pairs
> ```

---

## 20. WHERE Clause

Used to filter rows based on a specified condition.

**Syntax:**
```sql
SELECT col1, col2 FROM table_name
WHERE conditions;
```

**Example:**
```sql
SELECT * FROM student WHERE marks > 80;
SELECT * FROM student WHERE city = "Mumbai";
```

### Operators used inside WHERE

**Arithmetic Operators:** `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division), `%` (modulus)

**Comparison Operators:** `=` (equal to), `!=` (not equal to), `>`, `>=`, `<`, `<=`

**Logical Operators:** `AND`, `OR`, `NOT`, `IN`, `BETWEEN`, `ALL`, `LIKE`, `ANY`

**Bitwise Operators:** `&` (Bitwise AND), `|` (Bitwise OR)

### AND / OR

```sql
-- AND: both conditions must be true
SELECT * FROM student WHERE marks > 80 AND city = "Mumbai";

-- OR: at least one condition must be true
SELECT * FROM student WHERE marks > 90 OR city = "Mumbai";
```

### BETWEEN, IN, NOT

```sql
-- BETWEEN: selects values within a given range (inclusive)
SELECT * FROM student WHERE marks BETWEEN 80 AND 90;

-- IN: matches any value in a given list
SELECT * FROM student WHERE city IN ("Delhi", "Mumbai");

-- NOT: negates a condition
SELECT * FROM student WHERE city NOT IN ("Delhi", "Mumbai");
```

> **Note:** More filtering operators (`LIKE`, `IS NULL`) are covered in detail in **Part 2**.

---

## 21. AS (Alias)

Used to give a temporary name (alias) to a column or table — useful for readability or when working with joins.

**Syntax:**
```sql
SELECT col_name AS alias_name FROM table_name;
```

**Example — column alias:**
```sql
SELECT name AS student_name, marks AS score FROM student;
```

**Example — table alias:**
```sql
SELECT s.name FROM student AS s;
```

> **Note:** The `AS` keyword is optional in most RDBMS:
> ```sql
> SELECT name student_name FROM student;  -- also works
> ```

---

## 22. Arithmetic Expressions in SELECT

SQL allows performing calculations directly inside a `SELECT` statement.

**Example:**
```sql
SELECT name, marks, marks + 10 AS bonus_marks
FROM student;
```

**Example — percentage calculation:**
```sql
SELECT name, (marks / 100) * 100 AS percentage
FROM student;
```

**Example — combining arithmetic with WHERE:**
```sql
SELECT name FROM student WHERE marks * 2 > 150;
```

---

## 23. General Query Order (Basics Recap)

A basic SELECT query, using clauses covered so far, generally follows this order:

```sql
SELECT column(s)
FROM table_name
WHERE condition;
```

> **Note:** `ORDER BY`, `GROUP BY`, `HAVING`, and `LIMIT` — covered in Part 2 — extend this basic structure.

---

## Practice Questions — Part 1

1. Write a query to create a database named `school`.
2. Write a query to create a table `teacher` with columns: `id` (Primary Key, Auto Increment), `name` (VARCHAR, NOT NULL), `subject` (VARCHAR), `salary` (INT, DEFAULT 30000).
3. Insert 5 rows of sample data into the `teacher` table.
4. Write a query to display all columns of the `teacher` table.
5. Write a query to display only `name` and `subject` of teachers earning more than 40000.
6. Write a query to add a new column `email` to the `teacher` table.
7. Write a query to rename the column `subject` to `department`.
8. Write a query to delete teachers whose salary is less than 25000.
9. Write a query to update the salary of all teachers in the "Math" department to 50000.
10. Write a query to fetch all distinct subjects taught in the school.
11. Write a query to fetch teacher names whose salary is between 30000 and 60000.
12. Write a query to delete all data from `teacher` table without dropping its structure.
13. Explain the difference between `DELETE`, `TRUNCATE`, and `DROP` with one example each.
14. Create a `course` table with a Foreign Key referencing `teacher(id)`, using `ON DELETE CASCADE`.
15. Write a query using an arithmetic expression to display each teacher's salary after a 10% raise, aliased as `new_salary`.

---

**End of Part 1 — Continue to Part 2: Filtering & Grouping**
