/* Sum of trips by user type and day of week. Exported results to google sheets. */

SELECT
	weekday_1,
	COUNT(CASE WHEN member_casual = 'member' then 1 else NULL END) AS total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' then 1 else NULL END) AS total_casual_riders,
	COUNT(*) AS total_users, 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY weekday_1;

/* Calculate average ride duration by member type. Export results to google sheets */
SELECT
	member_casual as member_type,
	AVG(ride_length_mins) AS avg_ride_duration
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;

/* Calculate total rides by day of week and categorize by either weekday or weekend based on member type. Ran two
queries to get counts for both member and casual riders (Exported to Google sheets)*/

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

/* Time of day to ride by member type (Exported results to Google sheets) */

SELECT
	EXTRACT(HOUR FROM started_at) as hour_of_day,
	COUNT(CASE WHEN member_casual = 'member' THEN 1 ELSE NULL END) as total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' THEN 1 ElSE NULL END) as total_casual_riders,
	COUNT(*) AS number_of_riders
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY hour_of_day
ORDER BY hour_of_day;

/* Total riders by month and member_casual (exported to Google sheets) /*

SELECT
	EXTRACT(MONTH FROM started_at) as month,
	COUNT(CASE WHEN member_casual = 'member' THEN 1 ELSE NULL END) as total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' THEN 1 ElSE NULL END) as total_casual_riders,
	COUNT(*) AS number_of_riders
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY month
ORDER BY month;


/* Calculate percentage of rideable_type by casual_member type */

SELECT 
	member_casual,
	COUNTIF(rideable_type = "classic_bike") / COUNT(member_casual) * 100 AS 		 total_classic_bike, 		
	COUNTIF(rideable_type = "docked_bike") / COUNT(member_casual) * 100 AS 
total_docked_bike,
	COUNTIF(rideable_type = "electric_bike") / COUNT(member_casual) * 100 AS 		 total_electric_bike,
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;


/* Average ride duration by bike type */

SELECT
	rideable_type,
	AVG(ride_length_mins) AS avg_ride_duration
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY rideable_type;


/* Count of rides by member type and bike type */

SELECT
	member_casual,
	COUNTIF(rideable_type = "classic_bike") AS total_classic_bike,
	COUNTIF(rideable_type = "docked_bike") AS total_docked_bike,
	COUNTIF(rideable_type = "electric_bike") AS total_electric_bike
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY member_casual;


/* Top 10 start stations */

SELECT 
	start_station_name, 
	COUNT(start_station_name) AS count_start_station_name
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY start_station_name
ORDER BY count_start_station_name DESC LIMIT 10;


/* Top 10 end stations */

SELECT 
	end_station_name, 
	COUNT(end_station_name) AS count_end_station_name
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
GROUP BY end_station_name
ORDER BY count_end_station_name DESC LIMIT 10;


/* Quarter column added and a new table was created for further analysis */

SELECT 
	*,
	started_at,
	FORMAT_DATE('%Q(%Y)', date(started_at)) as Quarter 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
ORDER BY Quarter;


/* Calculate ridership by member type and quarter */

SELECT
	Quarter,
	COUNT(CASE WHEN member_casual = 'member' then 1 else NULL END) AS total_member_riders,
	COUNT(CASE WHEN member_casual = 'casual' then 1 else NULL END) AS total_casual_riders,
	COUNT(*) AS total_users
FROM `cyclistic-368022.trip_data.final_trips_202110_202209`
GROUP BY Quarter
ORDER BY Quarter;


/* Create a new view containing columns that might allow for good visualizing in Tableau. The original tables 
extracted weren't loading properly. */ 


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


/* Ended up separating the date and hour instead of returning separate columns for date, month, year. This change made visualization in Tableau much easier. */

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

/* Exported results to new table final_trip_data_202110_202209 & CSV for import into tableau */
