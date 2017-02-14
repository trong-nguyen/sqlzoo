-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid,
       player
FROM goal
WHERE teamid = 'GER' ;

-- Show id, stadium, team1, team2 for just game 1012

SELECT id,
       stadium,
       team1,
       team2
FROM game x
WHERE x.id = 1012 ;

-- Modify it to show the player, teamid, stadium and mdate and for every German goal.

SELECT player,
       teamid,
       stadium,
       mdate player
FROM game
JOIN
    (SELECT matchid,
            player,
            teamid
     FROM goal
     WHERE teamid='GER') AS m ON m.matchid=id ;

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT team1,
       team2,
       player
FROM game AS g
JOIN
    (SELECT player,
            matchid
     FROM goal
     WHERE player LIKE 'Mario%') AS l ON l.matchid = g.id ;

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player,
       teamid,
       coach,
       gtime
FROM goal AS g
JOIN
    (SELECT coach,
            id
     FROM eteam) AS e ON e.id = g.teamid
WHERE gtime <= 10 ;

-- List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT mdate,
       teamname
FROM game AS g
JOIN eteam AS e ON e.id = g.team1
WHERE e.coach = 'Fernando Santos' ;

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player
FROM goal AS g
JOIN game AS e ON e.id = g.matchid
WHERE stadium = 'National Stadium, Warsaw' ;

-- Instead show the name of all players who scored a goal against Germany.

SELECT player
FROM goal AS g
JOIN
    (SELECT id
     FROM game
     WHERE team1 = 'GER'
         OR team2 = 'GER') AS e ON g.matchid = e.id
AND g.teamid <> 'GER'
GROUP BY player ;

-- Show teamname and the total number of goals scored.

SELECT teamname,
       total_goals
FROM eteam AS e
JOIN
    (SELECT count(*) AS total_goals,
            teamid
     FROM goal
     GROUP BY teamid) AS g ON g.teamid = e.id ;

-- Show the stadium and the number of goals scored in each stadium.

SELECT stadium,
       count(*) AS total_goals
FROM game AS e
JOIN
    (SELECT matchid
     FROM goal) AS g ON g.matchid = e.id
GROUP BY stadium ;

-- For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT id,
       mdate,
       total_goals
FROM game AS e
JOIN
    (SELECT count(*) AS total_goals,
            matchid
     FROM goal
     GROUP BY matchid) AS g ON g.matchid = e.id
WHERE e.team1 = 'POL'
    OR e.team2 = 'POL' ;

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid,
       mdate,
       tg
FROM game AS e
JOIN
    (SELECT count(*) AS tg,
            matchid
     FROM goal
     WHERE teamid = 'GER'
     GROUP BY matchid) AS g ON e.id = g.matchid ;

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.

SELECT mdate,
       team1,
       ifnull(score1, 0),
       team2,
       ifnull(score2, 0)
FROM game AS g
LEFT JOIN
    (SELECT matchid,
            sum(score1) score1,
            sum(score2) score2
     FROM
         (SELECT matchid,
                 CASE
                     WHEN teamid = team1 THEN 1
                     ELSE 0
                 END score1,
                 CASE
                     WHEN teamid = team2 THEN 1
                     ELSE 0
                 END score2
          FROM game
          JOIN goal ON matchid = id) AS m
     GROUP BY m.matchid) AS sm ON g.id = sm.matchid
ORDER BY mdate,
         matchid,
         team1,
         team2 ;