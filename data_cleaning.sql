/* To begin the data cleaning process, I created a new project in BigQuery called "cyclistic-368022" and started 
adding data. Given the large size of the data, I had to create buckets for each of the 12 months of trip data 
provided by Motivate International, Inc. instead of just importing the data all at once. Once all the files 
were uploaded to BigQuery, I joined all 12 tables into a single table. The table covered the period from
October 2021 - September 2022. After merging the tables, I ran a Select All statement to make sure that the 
number of rows matched my previous count of 5,828,235 after importing the data. */

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

SELECT * 
FROM `cyclistic-368022.trip_data.year_data_202110_202209`
/* 5,828,235 rows displaying which includes nulls */

/* During the process of consolidating the 12 individual trip data tables into one cohesive table, I determined it
would be best to retain the original table, "year_data_202110_202209" as a reference point, should the need arise 
to revisit the starting point of my data cleaning process. I then created a new table, "cleaned_trips_202110_202209," 
as the basis for my data-cleaning efforts. */


/* Creates a table (cleaned_trips_202110_202209) that contains cleaned data only and retains all data within 
year_data_202110_202209 */

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


/* To populate the cleaned_trips_202110_202209 table, I wrote an "Insert Into" statement that selected all data from the 
year_data_202110_202209 table. In this statement, I included a "Where Clause" that filtered out all rows containing null 
values in the columns: start_station_id, start_station_name, end_station_id, end_station_name, start_lat, and end_lat. */

/* Given the scope of this case study project, it made the most sense to exclude rows with null or missing values. 
Unfortunately, since I was unable to contact the responsible parties for this data I would not have the ability to obtain 
further information to fill in these blank fields. In a typical scenario, I would have made an effort to reach out and 
retain as much data as possible. As a result of removing the nulls, 1,354,094 rows of ride data were removed in the process. */


/* Removes all rows with null values and inserts rows without nulls into the new cleaned_trips_202110_202209 table */

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

/* Results removed 1,354,094 rows containing nulls leaving a remaining 4,474,141 rows */


/* I wanted to do a check on my data so I decided to run a “Count Distinct” statement to ensure there were no duplicate ride_id 
within my table. The ride_id column should only contain distinct values */


/* Check for distinct ride id's to ensure no duplicates results yeilds 4,474,141 rows */
SELECT COUNT(DISTINCT ride_id)
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209` 


/* To ensure that the data is accurate, I searched for and removed all rows from the start_station_name column containing Divvy
administrative testing stations. Additionally, I decided to limit the number of characters for all ride_id to a maximum of 16 
characters. */


SELECT *
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
WHERE start_station_name="HUBBARD ST BIKE CHECKING (LBS-WH-TEST)"

SELECT *
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
WHERE start_station_name="DIVVY CASSETTE REPAIR MOBILE STATION"

SELECT ride_id, LEFT(ride_id,16)
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`


/* Two new columns were added to the table - ride_length_mins and weekday_1. The ride_length_mins column contains the total duration of each trip 
in minutes, and the weekday_1 column is populated with an abbreviated form of the day of the week, in three letters. With these new columns in 
place, the table was saved as "trip_data_clean_202110_202209" for further queries and analysis. */


/* Add columns for duration and weekday */

SELECT
  *
  DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length_mins,
  FORMAT_DATE('%a', started_at) AS weekday_1,
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`
	;

/* Results saved as new table trip_data_clean_202110_202209 for future queries */


/* The trip duration data were filtered to exclude trips that were less than one minute or longer than 1440 minutes. This step eliminated any data 
that could potentially skew the results of the analysis. Trips less than one minute were also removed, as they may have resulted from testing, 
false starts, or users attempting to re-dock a bike. */


/* Count rows with ride_length_mins <1 minute and >=1 and to ensure no data is lost with filtering out trips less than one minute. */

/* Filter rows with ride_length_mins >1 minute and <=1440 minutes retaining trips greater than 1 minute and less/equal to 24 hours */

SELECT COUNT(ride_length_mins)
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins<1 -- Shows total of 73,844 records. These records are either false starts or testing/maintenance

SELECT COUNT(ride_length_mins) 
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins >=1 -- Shows total of 4,400,297 records

SELECT COUNT(ride_length_mins)
FROM `cyclistic-368022.trip_data.trip_data_clean_202110_202209`
WHERE ride_length_mins <= 1440 -- shows a total of 4,473,842. 


/* Categorize trips into segments - The trip duration was categorized into segments in 15-minute increments. This may provide another 
data point or possible visualization for later use. */

/* To create additional data points for analysis and visualization, the trip duration was grouped into segments of 15-minute increments. 
This categorization of the data might reveal new insights and patterns. */



/* Categorize ride_length_mins into 15 minute segments of time in a new column ride_length_segment and omits trips >24 hours and <1 minute */

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
