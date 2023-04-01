## Question 5: Which drivers has the most wins in a single season?
-- Merging driver data, their standings and race data
SELECT *
FROM drivers d
JOIN driver_standings ds 
	ON d.driverId = ds.driverId
JOIN races r
	ON ds.raceId = r.raceId;
    
-- Exacting columns needed and filtering the dataset to include the max wins every year
SELECT DISTINCT d.surname, r.year, ds.wins
FROM drivers d
JOIN driver_standings ds 
	ON d.driverId = ds.driverId
JOIN races r
	ON ds.raceId = r.raceId
WHERE (r.year, ds.wins) IN (
	SELECT r.year, MAX(ds.wins)
	FROM drivers d
    JOIN driver_standings ds
	ON d.driverId = ds.driverId
	JOIN races r
	ON ds.raceId = r.raceId
	GROUP BY 1) AND ds.wins <> 0
ORDER BY 3 DESC;



## Question 6: What was the most competitive season by points difference?

