## Question 1: Which teams are the most successful constructors ##

-- Join results table and constructors table
SELECT *
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId;

-- Exacting columns needed and looking at total races entered
SELECT c.name, COUNT(DISTINCT r.raceId) AS total_races
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Exacting column needed and looking at total points
SELECT c.name, SUM(r.points) AS total_points
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Calculating average points of the top 10 constructors with the most points per race who have entered at least 100 races
SELECT c.name, ROUND(SUM(r.points)/COUNT(DISTINCT r.raceId),2) AS points_per_race
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
HAVING COUNT(DISTINCT r.raceId) >=100
ORDER BY 2 DESC
LIMIT 10;

## Question 2: Which drivers are the most successful ##
-- Join results table and drivers table
SELECT *
FROM results r
JOIN drivers d
ON r.driverId = d.driverId;

-- Exacting columns needed and looking at total races entered
SELECT d.surname, COUNT(DISTINCT r.raceId) AS total_races
FROM results r
JOIN drivers d
ON r.driverId = d.driverId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Exacting column needed and looking at total points
SELECT d.surname, SUM(r.points) AS total_points
FROM results r
JOIN drivers d
ON r.driverId = d.driverId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Find the Highest Average Points Earned Per Case by Constructors Who Have Entered at Least 50 Races
SELECT d.surname, ROUND(SUM(r.points)/COUNT(DISTINCT r.raceId),2) AS points_per_race
FROM results r
JOIN drivers d
ON r.driverId = d.driverId
GROUP BY 1
HAVING COUNT(DISTINCT r.raceId) >=50
ORDER BY 2 DESC
LIMIT 10;


-- Merging drivers, driver standings and race data 
SELECT *
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId;

-- Grouping drivers by nationality, year and surname to get the max points achieved every season
SELECT d.surname, d.nationality, r.year, MAX(ds.points) AS total_points, MAX(ds.wins) AS total_wins
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Using the the max points achieved every season to find the champion for every year
SELECT DISTINCT r.year, d.nationality, d.surname, ds.points
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId
WHERE (r.year, ds.points) IN (
	SELECT r.year, MAX(ds.points)
	FROM drivers d
    JOIN driver_standings ds
	ON d.driverId = ds.driverId
	JOIN races r
	ON ds.raceId = r.raceId
	GROUP BY 1
)
AND ds.points <> 0 
ORDER BY 1 DESC;

-- Looking at the most world championships
SELECT d.surname, COUNT(DISTINCT r.year) AS total_championships
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId
WHERE (r.year, ds.points) IN (
	SELECT r.year, MAX(ds.points)
	FROM drivers d
    JOIN driver_standings ds
	ON d.driverId = ds.driverId
	JOIN races r
	ON ds.raceId = r.raceId
	GROUP BY 1
)
AND ds.points <> 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;




-- Looking at the number of drivers from each country
SELECT nationality, COUNT(nationality) AS number_of_drivers
FROM drivers
GROUP BY 1
ORDER BY 2 DESC;

CREATE TEMPORARY TABLE num_drivers (
	nationality varchar(255),
    number_of_drivers integer
    );
    
INSERT INTO num_drivers
SELECT nationality, COUNT(nationality) AS number_of_drivers
FROM drivers
GROUP BY 1
ORDER BY 2 DESC;

SELECT *
FROM num_drivers;

-- Looking at nationality of every driver percent
SELECT 	nationality, 
		COUNT(nationality) AS number_of_drivers, 
		ROUND(COUNT(nationality)*100.0/SUM(COUNT(nationality)) OVER(), 2) AS percentage_of_drivers
FROM drivers
GROUP BY 1
ORDER BY 3 DESC;

-- Looking at the number of world champions from each country
CREATE TEMPORARY TABLE num_champions (
	nationality varchar(255),
    number_of_champions integer
    );
    
INSERT INTO num_champions
WITH champions AS (
SELECT DISTINCT r.year, d.nationality, d.surname, ds.points
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId
WHERE (r.year, ds.points) IN (
	SELECT r.year, MAX(ds.points)
	FROM drivers d
    JOIN driver_standings ds
	ON d.driverId = ds.driverId
	JOIN races r
	ON ds.raceId = r.raceId
	GROUP BY 1
)
AND ds.points <> 0
ORDER BY 1 DESC
)
SELECT nationality, COUNT(nationality) AS number_of_champions
FROM champions
GROUP BY 1
ORDER BY 2 DESC;

SELECT *
FROM num_champions;

SELECT nc.nationality, nc.number_of_champions, nd.number_of_drivers
FROM num_champions nc
JOIN num_drivers nd
ON nc.nationality = nd.nationality;

-- Calculating the ratio of drivers and world champions for each country
SELECT DISTINCT nc.nationality, nc.number_of_champions, nd.number_of_drivers, ROUND(nc.number_of_champions/nd.number_of_drivers*100, 2) AS win_percent
FROM num_champions nc
JOIN num_drivers nd
ON nc.nationality = nd.nationality
ORDER BY 4 DESC;

## Question 3: Does higher altitude cause more engine failures?
-- Merging circuits, race, results and status data 
SELECT *
FROM circuits c
JOIN races r
ON r.circuitId = c.circuitId
JOIN results re 
ON r.raceId = re.raceId
JOIN status s
ON s.statusId = re.statusId;

-- Exacting columns needed, including rows with issues correlated with thin air in higher altitudes, setting the year to last 7 to include Mexico GP
SELECT 
    c.name, 
    c.country, 
    c.alt, 
    r.year,
    s.statusId,
    s.status
FROM circuits c
JOIN races r
ON r.circuitId = c.circuitId
JOIN results re 
ON r.raceId = re.raceId
JOIN status s
ON s.statusId = re.statusId
WHERE r.year >=2015 AND s.statusId IN (5, 7);

-- Looking at the total failures and the altitude of the track they occurred on
SELECT c.name, c.country, c.alt, COUNT(s.statusId) AS failures
FROM circuits c
JOIN races r
ON r.circuitId = c.circuitId
JOIN results re 
ON r.raceId = re.raceId
JOIN status s
ON s.statusId = re.statusId
WHERE r.year >=2015 AND s.statusId IN (5, 7)
GROUP BY 1,2,3
ORDER BY 3 DESC;

## Question 4: Who has the fastest lap time in every circuit?
-- Merging and extraction of important columns from different tables
SELECT * 
FROM circuits c
JOIN races r
ON c.circuitId = r.circuitId
JOIN results re
ON r.raceId = re.raceId
JOIN drivers d
ON re.driverId = d.driverId;

-- Looking at the track record for each track
WITH lap_records AS (
    SELECT c.circuitId, MIN(re.fastestLapTime) AS lap_record
    FROM circuits c
    JOIN races r ON c.circuitId = r.circuitId
    JOIN results re ON r.raceId = re.raceId
    WHERE re.fastestLapTime IS NOT NULL AND re.fastestLapTime <> 0 
    GROUP BY c.circuitId
)
SELECT c.name, c.country, d.surname, lr.lap_record, r.year
FROM circuits c
JOIN races r ON c.circuitId = r.circuitId
JOIN results re ON r.raceId = re.raceId
JOIN drivers d ON re.driverId = d.driverId
JOIN lap_records lr ON c.circuitId = lr.circuitId AND re.fastestLapTime = lr.lap_record
ORDER BY 2;

WITH lap_records AS (
    SELECT c.circuitId, MIN(re.fastestLapTime) AS lap_record
    FROM circuits c
    JOIN races r ON c.circuitId = r.circuitId
    JOIN results re ON r.raceId = re.raceId
    WHERE re.fastestLapTime IS NOT NULL AND re.fastestLapTime <> 0 
    GROUP BY c.circuitId)
SELECT d.surname, COUNT(d.surname) AS fastest_laps
FROM circuits c
JOIN races r ON c.circuitId = r.circuitId
JOIN results re ON r.raceId = re.raceId
JOIN drivers d ON re.driverId = d.driverId
JOIN lap_records lr ON c.circuitId = lr.circuitId AND re.fastestLapTime = lr.lap_record
GROUP BY 1
ORDER BY 2 DESC;




    




    




