# SQL Handbook — Part 7: Conditional, Date/Time & Numeric Functions

*This part uses the `student` and `employee` tables from earlier parts.*

```sql
CREATE TABLE student (
    rollno INT PRIMARY KEY,
    name VARCHAR(50),
    marks INT,
    city VARCHAR(20),
    dob DATE
);

INSERT INTO student (rollno, name, marks, city, dob) VALUES
(101, "anil", 78, "Pune", "2003-06-15"),
(102, "bhumika", 93, "Mumbai", "2002-11-02"),
(103, "chetan", 85, "Mumbai", "2003-01-20"),
(104, "dhruv", 96, "Delhi", "2002-08-09"),
(105, "emanuel", 32, "Delhi", "2003-03-30"),
(106, "farah", 82, "Delhi", "2002-12-25");
```

---

## SECTION A — Conditional Logic

## 1. CASE WHEN

Used to write **if-else style logic** directly inside a SQL query. Evaluates conditions in order and returns a value for the first condition that is `TRUE`.

**Syntax:**
```sql
SELECT column(s),
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END AS alias
FROM table_name;
```

**Example — Assign grade based on marks:**
```sql
SELECT name, marks,
CASE
    WHEN marks >= 90 THEN "A"
    WHEN marks >= 75 THEN "B"
    WHEN marks >= 50 THEN "C"
    ELSE "F"
END AS grade
FROM student;
```

**Output (sample rows):**
```
name    | marks | grade
--------|-------|------
anil    | 78    | B
bhumika | 93    | A
emanuel | 32    | F
```

**Example — CASE inside WHERE:**
```sql
SELECT name, marks FROM student
WHERE
CASE
    WHEN city = "Delhi" THEN marks > 80
    ELSE marks > 70
END;
```

**Example — CASE inside ORDER BY (custom sort order):**
```sql
SELECT name, city FROM student
ORDER BY
CASE city
    WHEN "Delhi" THEN 1
    WHEN "Mumbai" THEN 2
    ELSE 3
END;
```

**Example — Simple CASE (matching exact values, shorthand form):**
```sql
SELECT name,
CASE city
    WHEN "Delhi" THEN "North Zone"
    WHEN "Mumbai" THEN "West Zone"
    ELSE "Other Zone"
END AS zone
FROM student;
```

> **Note:** `CASE WHEN` can be used almost anywhere a value is expected — `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, even inside aggregate functions.

**Example — Conditional aggregation using CASE:**
```sql
SELECT
    SUM(CASE WHEN marks >= 75 THEN 1 ELSE 0 END) AS pass_count,
    SUM(CASE WHEN marks < 75 THEN 1 ELSE 0 END) AS fail_count
FROM student;
```

---

## 2. IFNULL() / COALESCE()

Used to substitute a default value when a column value is `NULL`.

**`IFNULL()`** — MySQL specific, checks only one value:
```sql
SELECT IFNULL(col_name, default_value) FROM table_name;
```

**`COALESCE()`** — standard SQL, checks a list and returns the **first non-NULL** value:
```sql
SELECT COALESCE(col1, col2, default_value) FROM table_name;
```

**Example:**
```sql
SELECT name, IFNULL(grade, "Not Assigned") AS grade
FROM student;
```

**Example — COALESCE with multiple fallbacks:**
```sql
SELECT COALESCE(phone, email, "No Contact Info") AS contact
FROM student;
```

---

## 3. NULLIF()

Returns `NULL` if two expressions are equal; otherwise returns the first expression. Useful to avoid divide-by-zero errors.

**Syntax:**
```sql
SELECT NULLIF(expr1, expr2);
```

**Example — avoid division by zero:**
```sql
SELECT marks / NULLIF(total_marks, 0) AS percentage
FROM student;
```

---

## SECTION B — Date & Time Functions

## 4. NOW() / CURDATE() / CURTIME()

Returns the current date and time.

**Syntax:**
```sql
SELECT NOW();       -- current date + time
SELECT CURDATE();   -- current date only
SELECT CURTIME();   -- current time only
```

**Example:**
```sql
SELECT NOW() AS current_datetime;
```

**Output:**
```
2026-07-21 14:32:10
```

---

## 5. DATE()

Extracts just the date part from a datetime value.

**Syntax:**
```sql
SELECT DATE(col_name) FROM table_name;
```

**Example:**
```sql
SELECT DATE(NOW()) AS today;
```

---

## 6. YEAR() / MONTH() / DAY()

Extracts the year, month, or day from a date.

**Syntax:**
```sql
SELECT YEAR(col_name), MONTH(col_name), DAY(col_name) FROM table_name;
```

**Example:**
```sql
SELECT name, dob, YEAR(dob) AS birth_year
FROM student;
```

**Output (sample row):**
```
anil | 2003-06-15 | 2003
```

---

## 7. DATEDIFF()

Returns the number of days between two dates.

**Syntax:**
```sql
SELECT DATEDIFF(date1, date2);
```

**Example:**
```sql
SELECT name, DATEDIFF(CURDATE(), dob) AS days_alive
FROM student;
```

---

## 8. DATE_ADD() / DATE_SUB()

Adds or subtracts a time interval to/from a date.

**Syntax:**
```sql
SELECT DATE_ADD(date, INTERVAL value unit);
SELECT DATE_SUB(date, INTERVAL value unit);
```

**Example:**
```sql
SELECT dob, DATE_ADD(dob, INTERVAL 18 YEAR) AS turns_18
FROM student;
```

**Example — subtract 7 days:**
```sql
SELECT DATE_SUB(CURDATE(), INTERVAL 7 DAY) AS last_week;
```

> **Note:** Common `unit` values: `DAY`, `MONTH`, `YEAR`, `HOUR`, `MINUTE`, `SECOND`.

---

## 9. TIMESTAMPDIFF()

Returns the difference between two dates/times in a specified unit (years, months, days, etc.) — useful for calculating age.

**Syntax:**
```sql
SELECT TIMESTAMPDIFF(unit, date1, date2);
```

**Example — calculate age in years:**
```sql
SELECT name, dob, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age
FROM student;
```

**Output (sample row):**
```
anil | 2003-06-15 | 23
```

---

## 10. DATE_FORMAT()

Formats a date into a custom string format.

**Syntax:**
```sql
SELECT DATE_FORMAT(col_name, format);
```

**Example:**
```sql
SELECT name, DATE_FORMAT(dob, "%d-%m-%Y") AS formatted_dob
FROM student;
```

**Output (sample row):**
```
anil | 15-06-2003
```

**Common format specifiers:**

| Specifier | Meaning |
|---|---|
| `%Y` | 4-digit year |
| `%y` | 2-digit year |
| `%m` | Month (numeric, 01–12) |
| `%M` | Month name (January, February...) |
| `%d` | Day of month (01–31) |
| `%W` | Weekday name (Monday, Tuesday...) |
| `%H` | Hour (24-hour format) |

---

## SECTION C — Numeric Functions

## 11. ROUND()

Rounds a number to a specified number of decimal places.

**Syntax:**
```sql
SELECT ROUND(number, decimal_places);
```

**Example:**
```sql
SELECT ROUND(87.6789, 2) AS rounded;
```

**Output:**
```
87.68
```

---

## 12. CEIL() / CEILING()

Rounds a number **up** to the nearest integer.

**Syntax:**
```sql
SELECT CEIL(number);
```

**Example:**
```sql
SELECT CEIL(87.2) AS ceiling_value;
```

**Output:**
```
88
```

---

## 13. FLOOR()

Rounds a number **down** to the nearest integer.

**Syntax:**
```sql
SELECT FLOOR(number);
```

**Example:**
```sql
SELECT FLOOR(87.9) AS floor_value;
```

**Output:**
```
87
```

---

## 14. ABS()

Returns the absolute (non-negative) value of a number.

**Syntax:**
```sql
SELECT ABS(number);
```

**Example:**
```sql
SELECT ABS(-45) AS absolute_value;
```

**Output:**
```
45
```

---

## 15. POWER() / SQRT()

`POWER()` raises a number to a given exponent. `SQRT()` returns the square root.

**Syntax:**
```sql
SELECT POWER(base, exponent);
SELECT SQRT(number);
```

**Example:**
```sql
SELECT POWER(2, 3) AS cube;   -- 8
SELECT SQRT(81) AS root;      -- 9
```

---

## 16. MOD()

Returns the remainder of a division (same as the `%` operator).

**Syntax:**
```sql
SELECT MOD(number, divisor);
```

**Example:**
```sql
SELECT rollno, MOD(rollno, 2) AS is_even
FROM student;
```

> **Note:** `MOD(rollno, 2) = 0` means the roll number is even.

---

## Quick Reference Table

| Function | Purpose |
|---|---|
| `CASE WHEN` | If-else conditional logic |
| `IFNULL()` / `COALESCE()` | Replace NULL with default value |
| `NULLIF()` | Return NULL if two values are equal |
| `NOW()` / `CURDATE()` / `CURTIME()` | Current date/time |
| `DATE()` | Extract date part |
| `YEAR()` / `MONTH()` / `DAY()` | Extract year/month/day |
| `DATEDIFF()` | Difference in days between two dates |
| `DATE_ADD()` / `DATE_SUB()` | Add/subtract time interval |
| `TIMESTAMPDIFF()` | Difference in custom units (age calc) |
| `DATE_FORMAT()` | Custom date formatting |
| `ROUND()` | Round to n decimal places |
| `CEIL()` | Round up |
| `FLOOR()` | Round down |
| `ABS()` | Absolute value |
| `POWER()` / `SQRT()` | Exponent / square root |
| `MOD()` | Remainder of division |

---

## Practice Questions — Part 7

1. Write a query using `CASE WHEN` to label students as "Pass" (marks >= 40) or "Fail".
2. Write a query using `CASE WHEN` to categorize students into "Topper" (>90), "Average" (60–90), and "Weak" (<60).
3. Write a query to replace NULL grades with "Pending" using `IFNULL()`.
4. Write a query to display today's date and time.
5. Write a query to extract only the year of birth from the `dob` column.
6. Write a query to calculate each student's age in years using `TIMESTAMPDIFF()`.
7. Write a query to display `dob` in the format `DD-Month-YYYY` (e.g., `15-June-2003`).
8. Write a query to find the date exactly 30 days from today using `DATE_ADD()`.
9. Write a query to round each student's percentage to 1 decimal place.
10. Write a query to find which students have even roll numbers using `MOD()`.
11. Write a query combining `CASE WHEN` and `COUNT()` to count how many students passed vs failed.
12. Write a query to calculate `CEIL()` and `FLOOR()` of the average marks of the class.

---

**End of Part 7 — Continue to Part 8: CTEs, Procedures, Triggers & Transactions**
