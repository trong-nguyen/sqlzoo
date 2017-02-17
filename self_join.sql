-- How many stops are in the database.

SELECT count(STOP)
FROM
    (SELECT DISTINCT STOP
     FROM route) x;

-- Find the id value for the stop 'Craiglockhart'

SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id,
       name
FROM stops
JOIN route ON stops.id = route.stop
WHERE num = 4;

-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company,
       num,
       count(*)
FROM route
WHERE STOP IN (53,
               149)
GROUP BY company,
         num
HAVING count(*) = 2;

-- Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT b.company,
       b.num,
       a.stop,
       b.stop
FROM route a
JOIN route b ON a.num = b.num
AND a.company = b.company
WHERE a.stop =
        (SELECT id
         FROM stops
         WHERE name='Craiglockhart')
    AND b.stop =
        (SELECT id
         FROM stops
         WHERE name='London Road');

-- The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT b.company,
       b.num,
       s1.name,
       s2.name
FROM route a
JOIN route b ON a.num = b.num
AND a.company = b.company
JOIN stops s1 ON a.stop = s1.id
JOIN stops s2 ON b.stop = s2.id
WHERE s1.name='Craiglockhart'
    AND s2.name='London Road';

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT a.company,
       a.num
FROM route a
JOIN route b ON a.num = b.num
WHERE a.stop =
        (SELECT id
         FROM stops
         WHERE name = 'Haymarket')
    AND b.stop =
        (SELECT id
         FROM stops
         WHERE name = 'Leith')
GROUP BY a.num,
         a.company;

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT a.company,
       a.num
FROM route a
JOIN route b
JOIN stops s1
JOIN stops s2 ON a.num = b.num
AND a.company = b.company
AND a.stop = s1.id
AND b.stop = s2.id
AND s1.name = 'Craiglockhart'
AND s2.name = 'Tollcross';

-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

SELECT
    (SELECT name
     FROM stops
     WHERE id = a.stop) AS name,
       a.company,
       a.num
FROM route a
JOIN
    (SELECT DISTINCT num,
                     company
     FROM route
     WHERE company = 'LRT'
         AND STOP =
             (SELECT id
              FROM stops
              WHERE name = 'Craiglockhart')) b ON a.num = b.num
AND a.company = b.company;

-- Find the routes involving two buses that can go from Craiglockhart to Sighthill.

SELECT DISTINCT x.num,
                x.company,
                s1.name,
                y.num,
                y.company
FROM
    (SELECT a.num,
            a.company,
            a.stop
     FROM route a
     JOIN
         (SELECT *
          FROM route
          WHERE STOP =
                  (SELECT id
                   FROM stops
                   WHERE name = 'Craiglockhart')) AS b ON a.num = b.num
     AND a.company = b.company) AS x
JOIN
    (SELECT a.num,
            a.company,
            a.stop
     FROM route a
     JOIN
         (SELECT *
          FROM route
          WHERE STOP =
                  (SELECT id
                   FROM stops
                   WHERE name = 'Sighthill')) AS b ON a.num = b.num
     AND a.company = b.company) AS y
JOIN stops s1 ON s1.id = x.stop
JOIN stops s2 ON s2.id = y.stop
WHERE x.stop = y.stop
    AND x.num <> y.num;