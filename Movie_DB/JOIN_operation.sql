USE movie_info;


SELECT m.movie_name,m.genre, m.year, d.director_name
FROM movie AS m 
JOIN director AS d
ON m.director_id = d.person_id;


SELECT m.movie_name, m.imdb_rating, d.director_name
FROM movie as m
JOIN director as d 
ON m.director_id = d.person_id
WHERE m.imdb_rating > 8


SELECT d.director_name, COUNT(m.movie_id) as Total_Movies
FROM movie AS m
JOIN director as d 
ON m.director_id = d.person_id
GROUP BY d.director_name


SELECT m.movie_name, c.character_id
FROM movie AS m 
JOIN movie_character_relationship as r 
ON m.movie_id = r.movie_id
JOIN movie_characters AS c
ON r.character_id = c.character_id
ORDER BY m.movie_name, c.character_id



SELECT m.movie_name, COUNT(*) AS Character_Count
FROM movie AS m 
JOIN movie_character_relationship as r 
ON m.movie_id = r.movie_id
JOIN movie_characters AS c
ON r.character_id = c.character_id
GROUP BY m.movie_name
ORDER BY Character_Count DESC;


SELECT movie_name, COUNT(*)
FROM
movie JOIN movie_character_relationship on movie.movie_id = movie_character_relationship.movie_id GROUP BY movie_character_relationship.movie_id ORDER by COUNT(*) DESC;

SELECT d.director_name
FROM director as d
LEFT JOIN movie as m
ON d.person_id = m.director_id
WHERE m.movie_id IS NULL;



SELECT d.person_id , a.actor_name, d.director_name
FROM director as d
JOIN actor as a
WHERE d.person_id = a.person_id;


SELECT c.Character_Name,
       m.Genre
FROM Movie_Characters AS c
JOIN Movie_Character_Relationship AS r
  ON c.Character_ID = r.Character_ID
JOIN Movie AS m
  ON r.Movie_ID = m.Movie_ID;


SELECT c.character_name, m.genre
FROM movie_character_relationship as r
JOIN movie_characters as c
ON r.character_id = c.character_id
JOIN movie as m
ON m.movie_id = r.movie_id;


SELECT m.movie_name, d.director_name, m.imdb_rating
FROM movie AS m
JOIN director as d
ON m.director_id = d.person_id
WHERE m.genre = "Thriller"

SELECT character_name
FROM movie_characters
WHERE character_id IN(
  SELECT character_id
  FROM movie_character_relationship
  WHERE movie_id IN(
    SELECT movie_id
    FROM movie
    WHERE director_id IN(
      SELECT person_id 
      FROM director
      WHERE director_name = 'Saytajit Ray'
    )
  )
)

SELECT c.character_name, m.movie_name, d.director_name
FROM movie_characters AS c
JOIN movie_character_relationship as r
ON c.character_id = r.character_id
JOIN movie AS m
ON r.movie_id = m.movie_id
JOIN director AS d
ON m.director_id = d.person_id
WHERE d.director_name = "Saytajit Ray";


SELECT m.movie_name, d.director_name
FROM movie AS m
RIGHT JOIN director AS d
ON d.person_id = m.director_id
ORDER BY movie_name ASC


SELECT m.movie_name, COUNT(*) AS number_of_char
FROM movie_character_relationship AS mcr
JOIN movie AS m
ON mcr.movie_id = m.movie_id
GROUP BY mcr.movie_id;


SELECT m.movie_name, MAX(mc.age)
FROM movie AS m
JOIN movie_character_relationship AS mcr
ON mcr.movie_id = m.movie_id
JOIN movie_characters AS mc
ON mcr.character_id = mc.character_id
GROUP BY mcr.movie_id
;

SELECT d.director_name, AVG(m.imdb_rating) AS avg_imdb_rate
FROM director as d
JOIN movie as m
ON d.person_id = m.director_id
GROUP BY director_name
HAVING AVG(imdb_rating) > 8;


SELECT a.actor_name, d.director_name
FROM actor as a
JOIN director as d
ON a.person_id = d.person_id
WHERE a.person_id IN(
  SELECT director_id
  FROM movie
  WHERE imdb_rating > 8
)

SELECT mc.character_name, m.movie_name, d.director_name
FROM movie_characters as mc
JOIN movie_character_relationship as mcr
ON mc.character_id = mcr.character_id
JOIN movie as m
ON mcr.movie_id = m.movie_id
JOIN director AS d
ON m.director_id = d.person_id
WHERE d.birth_year < 1950;














