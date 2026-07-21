# SQL Handbook — Part 9: SQL Theory (Normalization & ER Diagrams)

*This part is conceptual/theory-focused — it explains **why** databases are designed the way they are, which is common in interviews and academic exams.*

---

## SECTION A — Entity-Relationship (ER) Model

## 1. What is an ER Diagram?

An **ER (Entity-Relationship) Diagram** is a visual blueprint used to design a database **before** creating actual tables. It shows what data needs to be stored (entities), what properties that data has (attributes), and how different pieces of data relate to each other (relationships).

**Core building blocks:**

| Component | Symbol (typical) | Meaning |
|---|---|---|
| **Entity** | Rectangle | A real-world object/concept (e.g., Student, Course) |
| **Attribute** | Oval | A property of an entity (e.g., name, marks) |
| **Relationship** | Diamond | An association between two entities (e.g., "enrolls in") |
| **Primary Key attribute** | Underlined oval | Uniquely identifies an entity instance |

---

## 2. Entity and Entity Set

An **Entity** is a single real-world object (e.g., one specific student, "Anil"). An **Entity Set** is a collection of similar entities (e.g., all students) — this typically becomes a **table** in the database.

**Example:**
- Entity: the specific student "Anil, Roll No. 101"
- Entity Set: `Student` (the table that stores all such students)

### Strong Entity vs Weak Entity

| Type | Description | Example |
|---|---|---|
| **Strong Entity** | Has its own Primary Key, exists independently | `Student(rollno, name)` |
| **Weak Entity** | Cannot be uniquely identified by its own attributes alone; depends on a strong entity | `Dependent(dependent_name)` — depends on `Employee` |

---

## 3. Attributes

Properties that describe an entity.

| Attribute Type | Description | Example |
|---|---|---|
| **Simple** | Cannot be divided further | `age` |
| **Composite** | Can be divided into sub-parts | `address` → street, city, pin |
| **Single-valued** | Holds only one value | `dob` |
| **Multi-valued** | Can hold multiple values | `phone_numbers` |
| **Derived** | Calculated from another attribute | `age` derived from `dob` |
| **Key attribute** | Uniquely identifies the entity | `rollno` |

---

## 4. Relationships & Cardinality

A **Relationship** describes how two entities are connected. **Cardinality** defines the numeric nature of that relationship.

| Cardinality | Meaning | Example |
|---|---|---|
| **One-to-One (1:1)** | One entity instance relates to exactly one instance of another | One `Person` has one `Passport` |
| **One-to-Many (1:N)** | One entity instance relates to many instances of another | One `Department` has many `Employees` |
| **Many-to-One (N:1)** | Many instances relate to one instance | Many `Employees` belong to one `Department` |
| **Many-to-Many (M:N)** | Many instances relate to many instances | Many `Students` enroll in many `Courses` |

> **Note:** Many-to-Many relationships are implemented in SQL using a **junction/bridge table** (e.g., a `student_course` table with `student_id` and `course_id` as foreign keys).

**Example — Many-to-Many implementation:**
```sql
CREATE TABLE student_course (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(rollno),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);
```

---

## SECTION B — Normalization

## 5. What is Normalization?

**Normalization** is the process of organizing data in a database to:
- **Reduce data redundancy** (avoid storing the same data multiple times)
- **Improve data integrity** (avoid inconsistent/contradictory data)

It's done by splitting large tables into smaller, related tables and defining relationships between them using keys.

### Problems Normalization Solves — Anomalies

| Anomaly Type | Description | Example |
|---|---|---|
| **Insertion Anomaly** | Can't insert data without unrelated data being present | Can't add a new course unless a student enrolls in it |
| **Update Anomaly** | Same data stored in multiple places must be updated everywhere | Updating a teacher's phone number in every row they appear in |
| **Deletion Anomaly** | Deleting one piece of data unintentionally deletes another | Deleting the last student in a course also deletes the course info |

---

## 6. First Normal Form (1NF)

A table is in **1NF** if:
- Each column contains only **atomic (indivisible)** values
- Each column contains values of a **single type**
- There are no **repeating groups** or arrays in a single cell

**Example — NOT in 1NF (multiple values in one cell):**

| student_id | name | phone_numbers |
|---|---|---|
| 101 | Anil | 9876543210, 9123456789 |

**Fixed — in 1NF:**

| student_id | name | phone_number |
|---|---|---|
| 101 | Anil | 9876543210 |
| 101 | Anil | 9123456789 |

---

## 7. Second Normal Form (2NF)

A table is in **2NF** if:
- It is already in **1NF**
- Every **non-key column** depends on the **entire** Primary Key (no **partial dependency** — relevant only when the Primary Key is composite/made of multiple columns)

**Example — NOT in 2NF (composite key: student_id + course_id):**

| student_id | course_id | student_name | course_name |
|---|---|---|---|
| 101 | C1 | Anil | Math |
| 101 | C2 | Anil | Science |

Here, `student_name` depends only on `student_id` (not on the full composite key) — this is a **partial dependency**, which violates 2NF.

**Fixed — split into 3 tables:**

*student*

| student_id | student_name |
|---|---|
| 101 | Anil |

*course*

| course_id | course_name |
|---|---|
| C1 | Math |
| C2 | Science |

*student_course*

| student_id | course_id |
|---|---|
| 101 | C1 |
| 101 | C2 |

---

## 8. Third Normal Form (3NF)

A table is in **3NF** if:
- It is already in **2NF**
- There is no **transitive dependency** — a non-key column should not depend on another non-key column

**Example — NOT in 3NF:**

| student_id | student_name | city | city_std_code |
|---|---|---|---|
| 101 | Anil | Pune | 020 |

Here, `city_std_code` depends on `city`, not directly on `student_id` — this is a transitive dependency.

**Fixed — split into 2 tables:**

*student*

| student_id | student_name | city |
|---|---|---|
| 101 | Anil | Pune |

*city*

| city | city_std_code |
|---|---|
| Pune | 020 |

---

## 9. Boyce-Codd Normal Form (BCNF)

A stricter version of 3NF. A table is in **BCNF** if, for every functional dependency `X → Y`, `X` must be a **super key** (a column or set of columns that can uniquely identify a row).

BCNF handles rare edge cases where a table satisfies 3NF but still has redundancy due to overlapping candidate keys.

> **Note:** In most practical database design, achieving **3NF** is considered sufficient. BCNF is mostly discussed in academic/interview contexts for edge cases.

---

## 10. Normalization Summary Table

| Normal Form | Requirement |
|---|---|
| **1NF** | Atomic values only, no repeating groups |
| **2NF** | 1NF + no partial dependency (relevant with composite keys) |
| **3NF** | 2NF + no transitive dependency |
| **BCNF** | 3NF + every determinant is a super key |

---

## 11. Denormalization

**Denormalization** is the intentional process of combining normalized tables back together (adding some redundancy) to **improve read performance** — often used in reporting/analytics systems where fast reads matter more than storage efficiency or write-side data integrity.

**Trade-off:**

| Normalization | Denormalization |
|---|---|
| Less redundancy | More redundancy |
| Better for writes (INSERT/UPDATE/DELETE) | Better for reads (SELECT-heavy workloads) |
| More joins needed for queries | Fewer joins needed |
| Used in transactional systems (OLTP) | Used in reporting/analytics systems (OLAP) |

---

## Practice Questions — Part 9

1. Draw (in words) an ER diagram for a `Library` system with entities `Book`, `Member`, and a relationship `Borrows`.
2. Identify the cardinality (1:1, 1:N, M:N) for: (a) Person – Passport, (b) Author – Book, (c) Employee – Department.
3. Given a table with a multi-valued `phone_numbers` column, convert it into 1NF.
4. Given a table with a composite key `(order_id, product_id)` and a column `customer_name` that depends only on `order_id`, identify the 2NF violation and fix it.
5. Given a table with `emp_id`, `emp_name`, `dept_id`, `dept_name` — identify the transitive dependency and normalize it into 3NF.
6. Explain, with an example, the difference between an Insertion Anomaly, an Update Anomaly, and a Deletion Anomaly.
7. Explain why a Many-to-Many relationship requires a separate junction table, with an example.
8. Explain the difference between Normalization and Denormalization, and give one real-world scenario where denormalization is preferred.
9. What is the difference between a Strong Entity and a Weak Entity? Give one example of each.
10. List all Normal Forms in order and state, in one line each, what additional rule each one enforces over the previous.

---

**End of Part 9 — This completes the full SQL Handbook (Parts 1–9).**

*Full Handbook Structure:*
1. SQL Basics
2. Filtering & Grouping
3. All Joins
4. Subqueries & Set Operations
5. Advanced SQL (Views, Index, Window Functions, ROLLUP/CUBE)
6. String Functions
7. Conditional, Date/Time & Numeric Functions
8. CTEs, Stored Procedures, Triggers & Transactions
9. SQL Theory (Normalization & ER Diagrams)
