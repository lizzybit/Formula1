## Question 1: Which teams are the most successful constructors ##

-- Join results table and constructors table
SELECT *
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId;

-- Exacting column needed and looking at total races entered
SELECT c.name, COUNT(DISTINCT r.raceId) AS total_races
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC;

-- Exacting column needed and looking at total points
SELECT c.name, SUM(r.points) AS total_points
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC;

-- Calculating average points per race
SELECT c.name, (SUM(r.points)/COUNT(DISTINCT r.raceId)) AS points_per_race
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC;