USE collage;

CREATE TABLE IF NOT EXISTS dept(
  id INT PRIMARY KEY,
  name VARCHAR(50)
);

INSERT INTO dept VALUES
(101, "CSE"),
(102, "EEE"),
(103, "MC"),
(104, "BBA");

UPDATE dept 
SET id = 100
WHERE id = 101

CREATE TABLE IF NOT EXISTS teache(
  id INT PRIMARY KEY,
  name VARCHAR(50),
  detp_id INT,
  FOREIGN KEY (detp_id) REFERENCES dept(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

-- DROP TABLE teache;

INSERT INTO teache VALUES
(600, "Noman Amin", 101),
(601, "Milkon", 102),
(602, "Rifat", 103),
(603, "Noman Amin", 104),
(604, "Sifat", 101);

SELECT * FROM dept;
SELECT * FROM teache;