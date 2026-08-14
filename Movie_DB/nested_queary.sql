USE movie_info;

SHOW TABLES;

SELECT * FROM movie;

-- ======= 1 no ==========
SELECT Movie_ID, Movie_Name, Genre, Year FROM movie
WHERE genre IN ('Drama','Thriller');

-- ======= 2 no ==========

SELECT Person_ID, Director_Name
FROM director
WHERE Person_ID IN(
  SELECT director_id
  FROM movie
  WHERE imdb_rating > 8
);

-- ======= 3 no ==========

SELECT * FROM director
WHERE Person_id NOT IN(
  SELECT director_id
  FROM movie
  WHERE year > 2010
)

-- ======= 4 no ==========

SELECT person_id,Director_Name
FROM director
WHERE Person_ID IN(
  SELECT Person_ID
  FROM Actor
);

-- ======= 5 no ==========

SELECT Movie_Name, Year, IMDB_Rating
FROM Movie
WHERE director_id IN(
  SELECT Person_id
  FROM Director
  WHERE no_of_awards >= 15
);

SELECT * FROM DIRECTOR;
SELECT * FROM Movie;

SHOW Tables;

-- ======= 6 no ==========

SELECT character_id, character_name, age 
FROM MOVIE_CHARACTERS
WHERE age NOT IN (18,20,22,24,25,26);


-- ======= 7 no ==========

SELECT character_id, character_name, age 
FROM Movie_Characters
WHERE Character_ID IN( 
  SELECT Character_ID 
  FROM Movie_Character_Relationship
  WHERE GROUP BY Character_ID 
  HAVING COUNT(*) > 1
);

SELECT Character_ID, Character_Name, Age
FROM Movie_Characters
WHERE Character_ID IN (
    SELECT Character_ID
    FROM Movie_Character_Relationship
    GROUP BY Character_ID
    HAVING COUNT(*) > 1
);


-- ======= 8 no ==========

SELECT movie_id, movie_name, year
FROM movie
WHERE movie_id IN(
  SELECT movie_id
  FROM movie_character_relationship
  WHERE character_id IN ( 
    SELECT character_id 
    FROM movie_characters
    WHERE character_name = "Byomkesh Bakshi"
  )
);






