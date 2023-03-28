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
ORDER BY 2 DESC;

-- Exacting column needed and looking at total points
SELECT c.name, SUM(r.points) AS total_points
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC;

-- Calculating average points of constructors per race
SELECT c.name, (SUM(r.points)/COUNT(DISTINCT r.raceId)) AS points_per_race
FROM results r
JOIN constructors c
ON r.constructorId = c.constructorId
GROUP BY 1
ORDER BY 2 DESC;

## Question 2: Which drivers are the most successful ##

-- Looking at drivers distribution by georgraphy
SELECT nationality, COUNT(nationality) AS number_of_drivers
FROM drivers
GROUP BY 1
ORDER BY 2 DESC;

-- Merging drivers, driver standings and race data 
SELECT *
FROM drivers d
JOIN driver_standings ds
ON d.driverId = ds.driverId
JOIN races r
ON ds.raceId = r.raceId;

-- Grouping drivers by nationality, year and surname to get the max points achieved every season
SELECT DISTINCT year
FROM races
ORDER BY 1 DESC;

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
	c.circuitId, 
    c.circuitRef, 
    c.name, 
    c.location, 
    c.country, 
    c.lat, 
    c.lng, 
    c.alt, 
    r.raceId, 
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
SELECT c.name, c.alt, COUNT(s.statusId) AS failures
FROM circuits c
JOIN races r
ON r.circuitId = c.circuitId
JOIN results re 
ON r.raceId = re.raceId
JOIN status s
ON s.statusId = re.statusId
WHERE r.year >=2015 AND s.statusId IN (5, 7)
GROUP BY 1,2
ORDER BY 3 DESC;
    
    
    




    




