--Creating a table to store data for all 12 months
CREATE TABLE yearly_data(
	ride_id nvarchar(max),
	rideable_type nvarchar(max),
	started_at datetime2,
	ended_at datetime2,
	start_station_name nvarchar(max),
	start_station_id nvarchar(max),
	end_station_name nvarchar(max),
	end_station_id nvarchar(max),
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar(max),
	ride_length nvarchar(max),
	day_of_week nvarchar(max)
)


--Inserting 12 months of data into yearly_data table

INSERT INTO yearly_data
SELECT *
FROM(
	SELECT *
	FROM Trip_data_202104
	UNION ALL
	SELECT *
	FROM Trip_data_202105
	UNION ALL
	SELECT *
	FROM Trip_data_202106
	UNION ALL
	SELECT *
	FROM Trip_data_202107
	UNION ALL
	SELECT *
	FROM Trip_data_202108
	UNION ALL
	SELECT *
	FROM Trip_data_202109
	UNION ALL
	SELECT *
	FROM Trip_data_202110
	UNION ALL
	SELECT *
	FROM Trip_data_202111
	UNION ALL
	SELECT *
	FROM Trip_data_202112
	UNION ALL
	SELECT *
	FROM Trip_data_202201
	UNION ALL
	SELECT *
	FROM Trip_data_202202
	UNION ALL
	SELECT *
	FROM Trip_data_202203
)t


--There are NULL values in the yearly_data table, so this deletes all the rows with NULL values

DELETE FROM yearly_data
WHERE ride_id = NULL
	OR rideable_type IS NULL
	OR started_at IS NULL
	OR ended_at IS NULL
	OR start_station_name IS NULL
	OR start_station_name = '*'
	OR start_station_name = 'Temp'
	OR start_station_name = '(LBS-WH-TEST)'
	OR end_station_name = '*'
	OR end_station_name = 'Temp'
	OR end_station_name = '(LBS-WH-TEST)'
	OR start_station_id IS NULL
	OR end_station_name IS NULL
	OR end_station_id IS NULL
	OR start_lat IS NULL
	OR start_lng IS NULL
	OR end_lat IS NULL
	OR end_lng IS NULL
	OR member_casual IS NULL
	OR ride_length IS NULL
	OR day_of_week IS NULL
;


--Creating a smaller table from yearly_data to better visualize data of interest
CREATE TABLE trips_by_riders(
	member_type nvarchar(max),
	day_of_week nvarchar(max),
	trip_date nvarchar(10)
)

INSERT INTO trips_by_riders(
	member_type, day_of_week, trip_date
)

SELECT member_casual, day_of_week, started_at
FROM yearly_data


-- Creating a table with number of casual riders for every date over a span of 12 months
CREATE TABLE trips_casual(
	casual_member nvarchar(max),
	trip_date nvarchar(max)
)

INSERT INTO trips_casual(
	casual_member, trip_date
)

SELECT COUNT(member_type), trip_date
FROM trips_by_riders
WHERE member_type = 'casual'


-- Creating a table with number of member riders for every date over a span of 12 months
CREATE TABLE trips_member(
	full_member nvarchar(max),
	trip_date nvarchar(max)
)

INSERT INTO trips_member(
	full_member, trip_date
)

SELECT COUNT(member_type), trip_date
FROM trips_by_riders
WHERE member_type = 'member'


--Joining trips_member and trips_casual table together
SELECT * 
FROM trips_member 
FULL OUTER JOIN trips_casual ON trips_member.trip_date = trips_casual.trip_date


--Creating a table with the number of casual riders every day of the week over 12 months

CREATE TABLE travel_day_casual(
	member_type nvarchar(max),
	day_week nvarchar(max),
)

INSERT INTO travel_day_casual(
	member_type, day_week
)

SELECT COUNT(member_type), day_of_week
FROM trips_by_riders
WHERE member_type = 'casual'
GROUP BY day_of_week


--Creating a table with the number of member riders every day of the week over 12 months

CREATE TABLE travel_day_member(
	member_type nvarchar(max),
	day_week nvarchar(max),
)

INSERT INTO travel_day_member(
	member_type, day_week
)

SELECT COUNT(member_type), day_of_week
FROM trips_by_riders
WHERE member_type = 'member'
GROUP BY day_of_week