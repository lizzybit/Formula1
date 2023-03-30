-- Create tables and import data

# 1: Circuits
CREATE TABLE circuits (
    circuitId integer,
    circuitRef varchar(255),
    name varchar(255),
    location varchar(255),
    country varchar(255),
    lat integer,
    lng integer,
    alt integer,
	url varchar(255)
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/circuits.csv'
INTO TABLE circuits
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM circuits;
# 2: Lap Times
CREATE TABLE lap_times (
    raceId integer,
	driverId integer,
    lap integer,
    position integer,
    time time,
    milliseconds integer
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/lap_times.csv'
INTO TABLE lap_times
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM lap_times;

# 3: Pit Stops
CREATE TABLE pit_stops (
    raceId integer,
	driverId integer,
    stop integer,
    lap integer,
    time time,
    milliseconds integer,
    duration time
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/pit_stops.csv'
INTO TABLE pit_stops
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM pit_stops;

# 4: Seasons
CREATE TABLE seasons (
    year varchar(255),
    url varchar(255)
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/seasons.csv'
INTO TABLE seasons
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM seasons;

# 5: Status
CREATE TABLE status (
    statusId integer,
    status varchar(255)
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/status.csv'
INTO TABLE status
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM status;

# 6: Constructor Standings
CREATE TABLE constructor_standings (
	constructorStandingId integer,
    raceId integer,
    constructorId integer,
    points integer,
    position integer,
    positionText varchar(255),
    wins integer
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/constructor_standings.csv'
INTO TABLE constructor_standings
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM constructor_standings;

# 7: Constructors
CREATE TABLE constructors (
	constructorId integer,
    constructorRef varchar(255),
    name varchar(255),
    nationality varchar(255),
    url varchar(255)
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/constructors.csv'
INTO TABLE constructors
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM constructors;

# 8: Driver Standings
CREATE TABLE driver_standings (
	driverStandingId integer,
    raceId integer,
    driverId integer,
    points integer,
    position integer,
    positionText varchar(255),
    wins integer
    );

LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/driver_standings.csv'
INTO TABLE driver_standings
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM driver_standings;

# 9: Drivers
CREATE TABLE drivers (
	driverId integer,
    driverRef varchar(255),
    forename varchar(255),
    surname varchar(255),
    dob date,
    nationality varchar(255),
    url varchar(255)
    );

LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/drivers.csv'
INTO TABLE drivers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM drivers;

# 10: Races
CREATE TABLE races(
	raceId integer,
    year varchar(255),
    round integer,
    circuitId integer,
    name varchar(255),
    date date,
    time time,
    url varchar(255)
    );

LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/races.csv'
INTO TABLE races
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM races;

# 11: Constructor Results
CREATE TABLE constructor_results (
	constructorResultsId integer,
    raceId integer,
    constructorId integer,
    points integer
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/constructor_results.csv'
INTO TABLE constructor_results
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM constructor_results;

# 12: Results
drop table results;
CREATE TABLE results (
	resultsId integer,
    raceId integer,
    driverId integer,
    constructorId integer,
    number integer,
    grid integer,
    position integer,
    positionText varchar(255),
    positionOrder integer,
    points integer,
    laps integer,
    time time,
    milliseconds integer,
    fastestLap integer,
    ranks integer,
    fastestLapTime varchar(255),
    fastestSpeed integer,
    statusId integer
    );
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula1/Data/Cleaned/results.csv'
INTO TABLE results
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM results;

# 13: Qualifying
CREATE TABLE qualifying (
	qualifyId integer,
    raceId integer,
    driverId integer,
    constructorId integer,
    number integer,
    position integer,
	q1 time,
    q2 time,
    q3 time
    );

LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Formula 1/Data/Cleaned/qualifying.csv'
INTO TABLE qualifying
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM qualifying;



	



