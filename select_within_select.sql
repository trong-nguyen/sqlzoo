-- List each country name where the population is larger than that of 'Russia'.

SELECT name
FROM world
WHERE population >
        (SELECT population
         FROM world
         WHERE name='Russia') ;

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name
FROM world
WHERE continent = 'Europe'
    AND (gdp / population) >
        (SELECT gdp / population
         FROM world
         WHERE name = 'United Kingdom') ;

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

SELECT name,
       continent
FROM world
WHERE continent IN
        (SELECT continent
         FROM world
         WHERE name IN ('Argentina',
                        'Australia'))
ORDER BY name ;

-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.

SELECT name,
       population
FROM world
WHERE population BETWEEN
        (SELECT population+1
         FROM world
         WHERE name = 'Canada') AND
        (SELECT population-1
         FROM world
         WHERE name = 'Poland') ;

-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

SELECT name,
       concat(round(population /
                        (SELECT population
                         FROM world
                         WHERE name = 'Germany') * 100, 0), '%')
FROM world
WHERE continent = 'Europe' ;

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

SELECT name
FROM world
WHERE gdp > ALL
        (SELECT gdp
         FROM world
         WHERE continent = 'Europe'
             AND gdp != 'NULL') ;

-- Find the largest country (by area) in each continent, show the continent, the name and the area:

SELECT x.continent,
       x.name,
       x.area
FROM world x
INNER JOIN
    (SELECT max(area) AS area,
            continent
     FROM world
     GROUP BY continent) y ON x.continent = y.continent
AND x.area = y.area ;

-- List each continent and the name of the country that comes first alphabetically.

SELECT x.continent,
       x.name
FROM world x
INNER JOIN
    (SELECT min(name) AS name,
            continent
     FROM world
     GROUP BY continent) y ON x.continent = y.continent
AND x.name = y.name ;

-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.

SELECT name,
       continent,
       population
FROM world AS o
WHERE o.continent IN
        (SELECT continent
         FROM
             (SELECT continent,
                     max(population) AS population
              FROM world
              GROUP BY continent) AS c
         WHERE c.population <= 25000000) ;

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.

SELECT x.name,
       x.continent
FROM world AS x
WHERE x.population / 3 > ALL
        (SELECT population
         FROM world
         WHERE continent = x.continent
             AND name != x.name) ;