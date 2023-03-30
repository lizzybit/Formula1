WITH fast AS (
	SELECT c.name, c.country, d.surname, d.nationality, re.fastestLapTime, r.year
	FROM circuits c
	JOIN races r
	ON c.circuitId = r.circuitId
	JOIN results re
	ON r.raceId = re.raceId
	JOIN drivers d
	ON re.driverId = d.driverId
),
fast_cleaned AS (
	SELECT name, country, surname, nationality, fastestLapTime, year
	FROM fast f
	WHERE fastestLapTime IS NOT NULL
),
fastest_laps AS (
	SELECT name, MIN(fastestLapTime) AS lap_record
    FROM fast_cleaned fc
    GROUP BY 1
)
SELECT fc.name, fc.country, fc.surname, fl.lap_record, fc.nationality, fc.year
FROM fast_cleaned fc
INNER JOIN fastest_laps fl
ON fc.name = fl.name AND fc.fastestLapTime = fl.lap_record
ORDER BY fc.country;

SELECT DISTINCT c.name, c.country, d.surname, d.nationality, MIN(re.fastestLapTime), r.year
	FROM circuits c
	JOIN races r
	ON c.circuitId = r.circuitId
	JOIN results re
	ON r.raceId = re.raceId
	JOIN drivers d
	ON re.driverId = d.driverId
WHERE re.fastestLapTime IS NOT NULL AND c.name like "Albert Park%"
GROUP BY 1,2,3,4,6
ORDER BY 5;

SELECT circuit_name, MIN(fastestLapTime) as lap_record
FROM (
    SELECT circuits.name AS circuit_name, results.fastestLapTime, 
           drivers.surname, drivers.nationality, races.year
    FROM circuits
    JOIN races ON circuits.circuitId = races.circuitId
    JOIN results ON races.raceId = results.raceId
    JOIN drivers ON results.driverId = drivers.driverId
    WHERE fastestLapTime IS NOT NULL AND fastestLapTime <> 0
) AS fastest_lap_times
GROUP BY 1
ORDER BY 1;


SELECT c.name AS circuit_name, c.country, re.fastestLapTime, d.surname, d.nationality, r.year
FROM circuits c
JOIN races r
ON c.circuitId = r.circuitId
JOIN results re
ON r.raceId = re.raceId
JOIN drivers d
ON re.driverId = d.driverId
WHERE re.fastestLapTime IS NOT NULL AND re.fastestLapTime <> 0 AND re.fastestLapTime = ( SELECT MIN(re.fastestLapTime) FROM results )
ORDER BY 1;







