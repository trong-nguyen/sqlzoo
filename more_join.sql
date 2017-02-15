-- List the films where the yr is 1962 [Show id, title]

SELECT id,
       title
FROM movie
WHERE yr = 1962;

-- Give year of 'Citizen Kane'.

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id,
       title,
       yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- What are the titles of the films with id 11768, 11955, 21191

SELECT title
FROM movie
WHERE id IN (11768,
             11955,
             21191);

-- What id number does the actress 'Glenn Close' have?

SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- What is the id of the film 'Casablanca'

SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'.

SELECT name
FROM actor AS a
JOIN
    (SELECT actorid
     FROM casting
     WHERE movieid =
             (SELECT id
              FROM movie
              WHERE title = 'Casablanca')) AS com ON a.id = com.actorid;

-- Obtain the cast list for the film 'Alien'

SELECT name
FROM actor AS a
JOIN
    (SELECT actorid
     FROM casting
     WHERE movieid =
             (SELECT id
              FROM movie
              WHERE title = 'Alien')) AS com ON a.id = com.actorid;

-- List the films in which 'Harrison Ford' has appeared

SELECT title
FROM movie AS m
JOIN
    (SELECT movieid
     FROM casting AS c
     WHERE actorid =
             (SELECT id
              FROM actor
              WHERE name = 'Harrison Ford')) AS com
WHERE m.id = com.movieid;

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT title
FROM movie AS m
JOIN
    (SELECT movieid
     FROM casting
     WHERE ord <> 1
         AND actorid =
             (SELECT id
              FROM actor
              WHERE name = 'Harrison Ford')) AS com ON m.id = com.movieid;

-- List the films together with the leading star for all 1962 films.

SELECT title,
       name
FROM movie AS m
JOIN
    (SELECT movieid,
            name
     FROM actor AS a
     JOIN
         (SELECT movieid,
                 actorid
          FROM casting
          WHERE ord = 1) AS com ON a.id = com.actorid) AS com2 ON com2.movieid = m.id
WHERE m.yr = 1962;

-- Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,
       count(*) AS movies
FROM movie AS m
WHERE id IN
        (SELECT movieid
         FROM casting AS c
         WHERE actorid =
                 (SELECT id
                  FROM actor
                  WHERE name = 'John Travolta'))
GROUP BY yr
HAVING count(*) > 2;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT title,
       max(
               (SELECT name
                FROM actor
                WHERE id =
                        (SELECT actorid
                         FROM casting
                         WHERE movieid = m.id
                             AND ord=1))) AS actor
FROM movie AS m
JOIN
    (SELECT movieid
     FROM casting
     WHERE actorid =
             (SELECT id
              FROM actor
              WHERE name = 'Julie Andrews')) AS com ON m.id = com.movieid
GROUP BY title;

-- Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

SELECT name
FROM actor
WHERE id IN
        (SELECT actorid
         FROM casting
         WHERE ord = 1
         GROUP BY actorid
         HAVING count(*) >= 30)
ORDER BY name;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT title,
       ifnull(
                  (SELECT count(*)
                   FROM casting
                   WHERE movieid = m.id
                   GROUP BY movieid), 0) AS noa
FROM movie AS m
WHERE yr = 1978
ORDER BY noa DESC,
         title;

-- List all the people who have worked with 'Art Garfunkel'.

SELECT actor
FROM
    (SELECT
         (SELECT name
          FROM actor
          WHERE id = c.actorid) AS actor
     FROM casting AS c
     WHERE movieid IN
             (SELECT movieid
              FROM casting
              WHERE actorid =
                      (SELECT id
                       FROM actor
                       WHERE name = 'Art Garfunkel'))) x
WHERE actor <> 'Art Garfunkel';