-- ============================================================
-- DATABASE: MOVIE INFO
-- ============================================================

CREATE DATABASE IF NOT EXISTS movie_info;

USE movie_info;


-- ============================================================
-- TABLE 1: ACTOR
-- ============================================================

CREATE TABLE actor (
    person_id INT NOT NULL,
    actor_name VARCHAR(40),
    birth_year YEAR,
    no_of_films INT,
    no_of_awards INT,

    PRIMARY KEY (person_id)
);

SHOW DATABASES;
SHOW TABLES;


-- ============================================================
-- INSERT DATA INTO ACTOR
-- ============================================================

INSERT INTO actor
    (person_id, actor_name, birth_year, no_of_films, no_of_awards)
VALUES
    (4, 'Anjan Dutt', 1953, 39, 10),
    (6, 'Goutam Ghose', 1950, 3, 1),
    (7, 'Aparna Sen', 1945, 73, 43),
    (8, 'Kaushik Ganguly', 1968, 22, 7),
    (10, 'Soumitra Chatterjee', 1935, 250, 220),
    (11, 'UTtam Kumar', 1926, 190, 150),
    (12, 'Razzak', 1942, 120, 100);


SELECT * FROM actor;

-- ============================================================
-- TABLE 2: DIRECTOR
-- ============================================================

CREATE TABLE director (
    person_id INT NOT NULL,
    director_name VARCHAR(40),
    birth_year YEAR,
    no_of_films INT,
    no_of_awards INT,

    PRIMARY KEY (person_id)
);


-- ============================================================
-- INSERT DATA INTO DIRECTOR
-- ============================================================

INSERT INTO director
    (person_id, director_name, birth_year, no_of_films, no_of_awards)
VALUES
    (1, 'Zahir Raihan', 1935, 5, 5),
    (2, 'Rajkumar Hirani', 1962, 5, 9),
    (3, 'Saytajit Ray', 1921, 45, 55),
    (4, 'Anjan Dutt', 1953, 23, 17),
    (5, 'Rituparno Ghosh', 1963, 20, 15),
    (6, 'Goutam Ghose', 1950, 12, 8),
    (7, 'Aparna Sen', 1945, 12, 7),
    (8, 'Kaushik Ganguly', 1968, 23, 30);

SELECT * FROM director;
-- ============================================================
-- TABLE 3: MOVIE
-- ============================================================

CREATE TABLE movie (
    movie_id INT NOT NULL,
    movie_name VARCHAR(50),
    genre VARCHAR(50),
    year YEAR,
    imdb_rating FLOAT(2,1),
    director_id INT,

    PRIMARY KEY (movie_id),

    CONSTRAINT fk_movie_director
        FOREIGN KEY (director_id)
        REFERENCES director(person_id)
);


-- ============================================================
-- INSERT DATA INTO MOVIE
-- ============================================================

INSERT INTO movie
    (movie_id, movie_name, genre, year, imdb_rating, director_id)
VALUES
    (1, 'Pather Panchali', 'Drama', 1955, 8.5, 3),
    (2, 'Noukadubi', 'Drama', 2011, 7.6, 5),
    (3, 'Abohomaan', 'Drama', 2009, 7.3, 5),
    (4, 'Joi Baba Felunath', 'Thriller', 1979, 8.0, 3),
    (5, 'Jibon Theke Neya', 'Drama', 1970, 9.4, 1),
    (6, 'Moner Manush', 'Biography', 2010, 8.0, 6),
    (7, 'Apur Panchali', 'Biography', 2013, 8.2, 8),
    (8, 'Goynar Baksho', 'Comdey', 2013, 7.1, 7),
    (9, 'Byomkesh O Agnibaan', 'Thriller', 2017, 7.4, 4),
    (10, 'Byomkesh Bakshi', 'Thriller', 2010, 7.4, 4),
    (11, 'PK', 'Fiction', 2014, 8.2, 2);

SELECT * FROM movie;
-- ============================================================
-- TABLE 4: MOVIE_CHARACTERS
-- ============================================================

CREATE TABLE movie_characters (
    character_id INT NOT NULL,
    character_name VARCHAR(50),
    age INT,

    PRIMARY KEY (character_id)
);


-- ============================================================
-- INSERT DATA INTO MOVIE_CHARACTERS
-- ============================================================

INSERT INTO movie_characters
    (character_id, character_name, age)
VALUES
    (1, 'Apu', 7),
    (2, 'Durga', 10),
    (3, 'Harihar', 42),
    (4, 'Sarbajaya', 35),
    (5, 'Ramesh', 28),
    (6, 'Hemnalini', 25),
    (7, 'Nalinaksha', 30),
    (8, 'Kamala', 20),
    (9, 'Shikha', 21),
    (10, 'Apratim', 26),
    (11, 'Feluda', 25),
    (12, 'Maganlal Meghraj', 35),
    (13, 'Jatayu', 45),
    (14, 'Topshe', 18),
    (15, 'Ruku', 6),
    (16, 'Faruk', 22),
    (17, 'Bithi', 19),
    (18, 'Sathi', 24),
    (19, 'Lalon', NULL),
    (20, 'Kaluah', 25),
    (21, 'Siraj Saain', 45),
    (22, 'Komli', 25),
    (23, 'Subir Banerjee', NULL),
    (24, 'Ashima', 24),
    (25, 'Rashmoni', NULL),
    (26, 'Somalata', 24),
    (27, 'Chaitali', 18),
    (28, 'Byomkesh Bakshi', 26),
    (29, 'Ajit', 27),
    (30, 'Malati', 16),
    (31, 'Debkumar', 50),
    (32, 'Doctor Anukul', 45),
    (33, 'Prabhat', 27),
    (34, 'Satyabati', 22),
    (35, 'Anadi Babu', 55),
    (36, 'PK', NULL),
    (37, 'Jaggu', 26),
    (38, 'Sarfaraz', 29),
    (39, 'Tapasvi Maharaj', 50);


SELECT * FROM movie_characters;


-- ============================================================
-- TABLE 5: MOVIE_CHARACTER_RELATIONSHIP
-- ============================================================

CREATE TABLE movie_character_relationship (
    character_id INT NOT NULL,
    movie_id INT NOT NULL,

    PRIMARY KEY (character_id, movie_id),

    CONSTRAINT fk_relationship_character
        FOREIGN KEY (character_id)
        REFERENCES movie_characters(character_id),

    CONSTRAINT fk_relationship_movie
        FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
);


-- ============================================================
-- INSERT DATA INTO MOVIE_CHARACTER_RELATIONSHIP
-- ============================================================

INSERT INTO movie_character_relationship
    (character_id, movie_id)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),

    (5, 2),
    (6, 2),
    (7, 2),
    (8, 2),

    (9, 3),
    (10, 3),

    (11, 4),
    (12, 4),
    (13, 4),
    (14, 4),
    (15, 4),

    (16, 5),
    (17, 5),
    (18, 5),

    (19, 6),
    (20, 6),
    (21, 6),
    (22, 6),

    (23, 7),
    (24, 7),

    (25, 8),
    (26, 8),
    (27, 8),

    (28, 9),
    (28, 10),

    (29, 9),
    (29, 10),

    (30, 9),

    (31, 9),

    (32, 9),

    (33, 10),

    (34, 9),
    (34, 10),

    (35, 10),

    (36, 11),
    (37, 11),
    (38, 11),
    (39, 11);

SELECT * FROM movie_character_relationship;


-- ============================================================
-- END OF DATABASE
-- ============================================================

SHOW DATABASES;
SHOW TABLES;

-- ============ Tables =============
-- actor
-- director
-- movie
-- movie_character_relationship
-- movie_characters
-- ============ Tables =============