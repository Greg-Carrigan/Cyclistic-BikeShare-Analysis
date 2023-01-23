# Cyclistic-BikeShare-Analysis
Google data analytics professional certificate case study: Converting casual bikeshare riders to members 

CREATE TABLE cyclistic-368022.trip_data.year_data_202110_202209 
(
	ride_id	STRING,
	rideable_type	STRING,
	started_at	TIMESTAMP,
	ended_at	TIMESTAMP,
	start_station_name	STRING,
  start_station_id	STRING,
	end_station_name	STRING,
	end_station_id	STRING,
	start_lat	FLOAT64,
	start_lng	FLOAT64,
	end_lat	FLOAT64,
	end_lng FLOAT64,
	member_casual	STRING
);

INSERT INTO `cyclistic-368022.trip_data.year_data_202110_202209`
( 
SELECT * FROM `cyclistic-368022.trip_data.202110_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202111_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202112_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202201_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202202_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202203_trips`
UNION ALL
SELECT * FROM  `cyclistic-368022.trip_data.202204_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202205_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202206_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202207_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202208_trips`
UNION ALL
SELECT * FROM `cyclistic-368022.trip_data.202209_trips`
);

SELECT * FROM `cyclistic-368022.trip_data.year_data_202110_202209`
# 5,828,235 rows displaying which includes nulls

# Creates a table (cleaned_trips_202110_202209) that contains cleaned data only and retains all data within year_data_202110_202209 

CREATE TABLE `cyclistic-368022.trip_data.cleaned_trips_202110_202209` 
(
	ride_id	STRING,
	rideable_type	STRING,
	started_at	TIMESTAMP,
	ended_at	TIMESTAMP,
	start_station_name	STRING,
  start_station_id	STRING,
	end_station_name	STRING,
	end_station_id	STRING,
	start_lat	FLOAT64,
	start_lng	FLOAT64,
	end_lat	FLOAT64,
	end_lng FLOAT64,
	member_casual	STRING
);

# Removes all rows with null values and inserts rows without nulls into the new cleaned_trips_202110_202209 table


INSERT INTO `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
(
SELECT * 
FROM `cyclistic-368022.trip_data.year_data_202110_202209`
WHERE 
	start_station_id IS NOT NULL
	AND start_station_name IS NOT NULL
	and end_station_id IS NOT NULL
	and end_station_name IS NOT NULL
	and start_lat IS NOT NULL
	and start_lat IS NOT NULL
	and end_lng IS NOT NULL
);

SELECT * FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`

# Results removed 1,354,094 rows containing nulls leaving a remaining 4,474,141 rows

# Check for distinct ride id's to ensure no duplicates results yeilds 4,474,141 rows
SELECT COUNT(DISTINCT ride_id)
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209` 

# Check for any DIVVY Administrative testing stations. No results were present or required cleaning. Restrict ride_id string to 16 characters 
SELECT *
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
WHERE start_station_name="HUBBARD ST BIKE CHECKING (LBS-WH-TEST)"

SELECT *
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
WHERE start_station_name="DIVVY CASSETTE REPAIR MOBILE STATION"

SELECT ride_id, LEFT(ride_id,16)
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`



# Add columns for duration and weekday  

SELECT
  *
  DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length_mins,
  FORMAT_DATE('%a', started_at) AS weekday_1,
FROM
  `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
	;

# Results saved as new table trip_data_clean_202110_202209 for future queries

# Count rows with ride_length_mins <1 minute and >=1 and to ensure no data is lost with filtering out trips less than one minute.

# Filter rows with ride_length_mins >1 minute and <=1440 minutes retaining trips greater than 1 minute and less/equal to 24 hours

SELECT COUNT(ride_length_mins)
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins<1 -- Shows total of 73,844 records. These records are either false starts or testing/maintenance

SELECT COUNT(ride_length_mins) 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins >=1 -- Shows total of 4,400,297 records

SELECT COUNT(ride_length_mins)
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins <= 1440 -- shows a total of 4,473,842. 

# Categorize ride_length_mins into 15 minute segments of time in a new column ride_length_segment and omits trips >24 hours and <1 minute

SELECT *,
	CASE
		WHEN ride_length_mins < 15 THEN 'Under 15 mins'
		WHEN ride_length_mins < 30 THEN 'Under 30 mins'
		WHEN ride_length_mins < 45 THEN 'Under 45 mins'
		WHEN ride_length_mins < 60 THEN 'Under 60 mins'
		ELSE 'Over 1 hour'
		END
	as ride_length_segment
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins >=1 AND ride_length_mins <= 1440 -- Shows total of 4,399,998 records. 



## Sum of trips by user type and day of week. Exported results to google sheets.

SELECT
	weekday_1,
	COUNT(CASE WHEN member_casual = 'member' then 1 else NULL END) AS total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' then 1 else NULL END) AS total_casual_riders,
	COUNT(*) AS total_users, 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY weekday_1;

# Calculate average ride duration by member type. Export results to google sheets
SELECT
	member_casual as member_type,
	AVG(ride_length_mins) AS avg_ride_duration
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;

# Calculate total rides by day of week and categorize by either weekday or weekend based on member type. Ran two queries to get counts for both member and casual riders (Exported to Google sheets)
SELECT
	weekday_1, 
	COUNT(weekday_1) as total_rides,
	case when weekday_1 in ('Mon','Tue','Wed','Thu','Fri') then 'Weekday'
	ELSE 'Weekend'
	end as weekdays_category
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE member_casual= 'member'
GROUP BY Weekday_1,
	CASE WHEN Weekday_1 in ('Sat','Sun') then 'Weekend'END
ORDER BY 1;

SELECT
	weekday_1, 
	COUNT(weekday_1) as total_rides,
	case when weekday_1 in ('Mon','Tue','Wed','Thu','Fri') then 'Weekday'
	ELSE 'Weekend'
	end as weekdays_category,
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE member_casual= 'casual'
GROUP BY Weekday_1,CASE WHEN Weekday_1 in ('Sat','Sun') then 'Weekend'END
ORDER BY 1;

# Time of day to ride by member type (Exported results to Google sheets )
SELECT
	EXTRACT(HOUR FROM started_at) as hour_of_day,
	COUNT(CASE WHEN member_casual = 'member' THEN 1 ELSE NULL END) as total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' THEN 1 ElSE NULL END) as total_casual_riders,
	COUNT(*) AS number_of_riders
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY hour_of_day
ORDER BY hour_of_day;

# Total riders by month and member_casual (exported to Google sheets)
SELECT
	EXTRACT(MONTH FROM started_at) as month,
	COUNT(CASE WHEN member_casual = 'member' THEN 1 ELSE NULL END) as total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' THEN 1 ElSE NULL END) as total_casual_riders,
	COUNT(*) AS number_of_riders
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY month
ORDER BY month;

# Calculate percentage of rideable_type by casual_member type
SELECT 
	member_casual,
	COUNTIF(rideable_type = "classic_bike") / COUNT(member_casual) * 100 AS 		 total_classic_bike, 		
	COUNTIF(rideable_type = "docked_bike") / COUNT(member_casual) * 100 AS 
total_docked_bike,
	COUNTIF(rideable_type = "electric_bike") / COUNT(member_casual) * 100 AS 		 total_electric_bike,
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;

# Average ride duration by bike type
SELECT
	rideable_type,
	AVG(ride_length_mins) AS avg_ride_duration
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY rideable_type;

# Count of rides by member type and bike type
SELECT
	member_casual,
	COUNTIF(rideable_type = "classic_bike") AS total_classic_bike,
	COUNTIF(rideable_type = "docked_bike") AS total_docked_bike,
	COUNTIF(rideable_type = "electric_bike") AS total_electric_bike
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;

# Top 10 start stations
SELECT 
	start_station_name, 
	COUNT(start_station_name) AS count_start_station_name
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY start_station_name
ORDER BY count_start_station_name DESC LIMIT 10;

# Top 10 end stations
SELECT 
	end_station_name, 
	COUNT(end_station_name) AS count_end_station_name
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY end_station_name
ORDER BY count_end_station_name DESC LIMIT 10;

# Quarter column added and a new table was created for further analysis
SELECT 
	*,
	started_at,
	FORMAT_DATE('%Q(%Y)', date(started_at)) as Quarter 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
ORDER BY Quarter;

# Calculate ridership by member type and quarter
SELECT
	Quarter,
	COUNT(CASE WHEN member_casual = 'member' then 1 else NULL END) AS total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' then 1 else NULL END) AS total_casual_riders,
	COUNT(*) AS total_users
FROM `cyclistic-368022.trip_data.final_trips_202110_202209`
GROUP BY Quarter
ORDER BY Quarter;

# Create a new view containing columns that might allow for good visualizing in Tableau. The original tables extracted weren't loading properly. 


SELECT 
	ride_id,
	member_casual,
	ride_length_mins,
	weekday_1,
	Quarter,
	rideable_type,
	start_station_name,
	end_station_name,
	started_at,
	EXTRACT(YEAR from started_at) as year,
  EXTRACT(MONTH from started_at) as month,
	EXTRACT(DAY from started_at) as day,
	EXTRACT(HOUR from started_at) as hour
FROM `cyclistic-368022.trip_data.final_trips_202110_202209`

# Ended up separating the date and hour instead of returning separate columns for date, month, year. This change made visualization in Tableau much easier.

SELECT 
	ride_id,
	member_casual,
	ride_length_mins,
	weekday_1,
	Quarter,
	rideable_type,
	start_station_name,
	end_station_name,
	started_at,
	EXTRACT(DATE from started_at) as date,
	EXTRACT(HOUR from started_at) as hour
FROM `cyclistic-368022.trip_data.final_trips_202110_202209`

# Exported results to new table final_trip_data_202110_202209 & CSV for import into tableau
