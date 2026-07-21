# SQL Handbook — Bonus Part: String Functions

*This part assumes the `student` table used earlier:*

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

## 1. CONCAT()

Joins two or more strings together into one.

**Syntax:**
```sql
SELECT CONCAT(str1, str2, ...) FROM table_name;
```

**Example:**
```sql
SELECT CONCAT(name, " from ", city) AS full_info
FROM student;
```

**Output (sample row):**
```
anil from Pune
```

---

## 2. CONCAT_WS()

Joins strings together using a **specified separator** ("WS" = With Separator).

**Syntax:**
```sql
SELECT CONCAT_WS(separator, str1, str2, ...) FROM table_name;
```

**Example:**
```sql
SELECT CONCAT_WS("-", rollno, name, city) AS record
FROM student;
```

**Output (sample row):**
```
101-anil-Pune
```

---

## 3. UPPER() / UCASE()

Converts a string to **uppercase**.

**Syntax:**
```sql
SELECT UPPER(col_name) FROM table_name;
```

**Example:**
```sql
SELECT UPPER(name) AS name_upper FROM student;
```

**Output (sample row):**
```
ANIL
```

---

## 4. LOWER() / LCASE()

Converts a string to **lowercase**.

**Syntax:**
```sql
SELECT LOWER(col_name) FROM table_name;
```

**Example:**
```sql
SELECT LOWER(city) AS city_lower FROM student;
```

**Output (sample row):**
```
pune
```

---

## 5. LENGTH() / CHAR_LENGTH()

Returns the length of a string.

- `LENGTH()` → returns length in **bytes**
- `CHAR_LENGTH()` → returns length in **characters**

(For plain ASCII text like English names, both give the same result.)

**Syntax:**
```sql
SELECT LENGTH(col_name) FROM table_name;
SELECT CHAR_LENGTH(col_name) FROM table_name;
```

**Example:**
```sql
SELECT name, LENGTH(name) AS name_length
FROM student;
```

**Output (sample row):**
```
anil | 4
```

---

## 6. SUBSTRING() / SUBSTR()

Extracts a part (substring) of a string, starting at a given position, for a given length.

**Syntax:**
```sql
SELECT SUBSTRING(col_name, start, length) FROM table_name;
```

**Example:**
```sql
SELECT name, SUBSTRING(name, 1, 3) AS short_name
FROM student;
```

**Output (sample row):**
```
anil | ani
```

> **Note:** In MySQL, string position starts at **1**, not 0.

---

## 7. LEFT()

Returns the specified number of characters from the **start (left side)** of a string.

**Syntax:**
```sql
SELECT LEFT(col_name, n) FROM table_name;
```

**Example:**
```sql
SELECT name, LEFT(name, 3) AS first3
FROM student;
```

**Output (sample row):**
```
bhumika | bhu
```

---

## 8. RIGHT()

Returns the specified number of characters from the **end (right side)** of a string.

**Syntax:**
```sql
SELECT RIGHT(col_name, n) FROM table_name;
```

**Example:**
```sql
SELECT name, RIGHT(name, 3) AS last3
FROM student;
```

**Output (sample row):**
```
bhumika | ika
```

---

## 9. TRIM()

Removes leading and trailing spaces (or a specified character) from a string.

**Syntax:**
```sql
SELECT TRIM(col_name) FROM table_name;
```

**Example:**
```sql
SELECT TRIM("   hello world   ") AS trimmed;
```

**Output:**
```
hello world
```

**Remove a specific character:**
```sql
SELECT TRIM(BOTH "*" FROM "**hello**") AS trimmed;
```

**Output:**
```
hello
```

---

## 10. LTRIM() / RTRIM()

Removes spaces from only the **left** side (`LTRIM`) or only the **right** side (`RTRIM`) of a string.

**Syntax:**
```sql
SELECT LTRIM(col_name) FROM table_name;
SELECT RTRIM(col_name) FROM table_name;
```

**Example:**
```sql
SELECT LTRIM("   hello") AS left_trimmed;
SELECT RTRIM("hello   ") AS right_trimmed;
```

---

## 11. REPLACE()

Replaces all occurrences of a substring within a string with another substring.

**Syntax:**
```sql
SELECT REPLACE(col_name, old_str, new_str) FROM table_name;
```

**Example:**
```sql
SELECT REPLACE(city, "Mumbai", "Bombay") AS updated_city
FROM student;
```

**Output (sample row):**
```
Bombay
```

---

## 12. INSTR() / LOCATE()

Returns the **position** (1-based index) of the first occurrence of a substring within a string. Returns `0` if not found.

**Syntax:**
```sql
SELECT INSTR(col_name, substring) FROM table_name;
-- or
SELECT LOCATE(substring, col_name) FROM table_name;
```

**Example:**
```sql
SELECT name, INSTR(name, "an") AS position
FROM student;
```

**Output (sample row):**
```
emanuel | 2
```

---

## 13. REVERSE()

Reverses the characters of a string.

**Syntax:**
```sql
SELECT REVERSE(col_name) FROM table_name;
```

**Example:**
```sql
SELECT name, REVERSE(name) AS reversed_name
FROM student;
```

**Output (sample row):**
```
anil | lina
```

---

## 14. REPEAT()

Repeats a string a specified number of times.

**Syntax:**
```sql
SELECT REPEAT(str, n);
```

**Example:**
```sql
SELECT REPEAT("ab", 3) AS repeated;
```

**Output:**
```
ababab
```

---

## 15. LPAD() / RPAD()

Pads a string on the **left** (`LPAD`) or **right** (`RPAD`) with another string, up to a specified total length.

**Syntax:**
```sql
SELECT LPAD(str, total_length, pad_str);
SELECT RPAD(str, total_length, pad_str);
```

**Example:**
```sql
SELECT LPAD(rollno, 5, "0") AS padded_rollno
FROM student;
```

**Output (sample row, rollno = 101):**
```
00101
```

---

## Quick Reference Table

| Function | Purpose |
|---|---|
| `CONCAT()` | Join strings together |
| `CONCAT_WS()` | Join strings with a separator |
| `UPPER()` | Convert to uppercase |
| `LOWER()` | Convert to lowercase |
| `LENGTH()` / `CHAR_LENGTH()` | Get string length |
| `SUBSTRING()` | Extract part of a string |
| `LEFT()` | Get characters from the start |
| `RIGHT()` | Get characters from the end |
| `TRIM()` | Remove leading/trailing spaces or chars |
| `LTRIM()` / `RTRIM()` | Remove spaces from one side |
| `REPLACE()` | Replace substring with another |
| `INSTR()` / `LOCATE()` | Find position of a substring |
| `REVERSE()` | Reverse a string |
| `REPEAT()` | Repeat a string n times |
| `LPAD()` / `RPAD()` | Pad a string to a fixed length |

---

## Practice Questions — String Functions

1. Write a query to display each student's name in uppercase.
2. Write a query to display the first 3 letters of each student's name.
3. Write a query to concatenate `name` and `city` into one column, separated by a comma.
4. Write a query to find the length of each student's name.
5. Write a query to replace "Mumbai" with "Bombay" in the `city` column.
6. Write a query to reverse each student's name.
7. Write a query to pad `rollno` with leading zeros to make it 5 digits long.
8. Write a query to find the position of the letter "e" in each student's name.
9. Write a query to remove extra spaces from a string `"   hello sql   "`.
10. Write a query combining `CONCAT()` and `UPPER()` to display `"NAME: ANIL"` style output for each student.

---

**End of Bonus Part — String Functions**
