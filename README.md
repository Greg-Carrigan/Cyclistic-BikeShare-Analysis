# Cyclistic-BikeShare-Analysis
### Google data analytics professional certificate case study: Converting casual bikeshare riders to members

###### Greg Carrigan 11/21/2022 
<hr/>

### Case Study Scenario

Cyclistic is a Chicago-based bike-share company that features a network of 5,824 geotracked bicycles and 692 docking stations spread throughout the city as an alternative transportation option. Bikes can be unlocked and returned to any of the available docking stations at any time. Cyclistic offers a variety of bike options for its riders which includes bikes for riders with disabilities. Customers are classified into two categories, members and casual riders. Customers who purchase a single-ride or day pass are referred to as casual riders and those who purchase an annual membership are members. Cyclistic’s customers generally ride more for leisure, however approximately 30% of riders use the bike-share service for their daily commute. Cyclistic’s finance analysts conclude that although a smaller portion of riders makes up annual members, memberships are much more profitable than single-ride and day-pass casual riders.

---
### ASK
#### The Business Task

Cyclistic’s marketing analytics team would like to understand how casual riders and members utilize the service differently so that they can devise a marketing campaign to convert casual riders to annual memberships. By analyzing the rider trip data to answer the following questions, Cyclistic’s executive team will consider the recommendations made to strategize the best plan of action to increase profitability through memberships and ensure the future success of the company.
 
+ How do members and casual riders use the service differently?
+ Why would casual riders purchase Cyclistic annual memberships?
+ How can Cyclistic use digital marketing to influence casual riders to convert to annual members? 

#### Key Stakeholders

+ Cyclistic executive team - The executive team will decide whether to proceed with the recommendations of the marketing analytics team. 
+ Lily Moreno - The director of marketing and my manager. Lily is responsible for developing campaigns and initiatives that promote the bike-share program.
+ Cyclistic marketing anylytics team

---
### Prepare

#### Data Sources

For the purpose of this case study, 12 months of real bike-share trip data have been provided by Motivate International, Inc. under [this license.](https://www.divvybikes.com/data-license-agreement) The data will be used as if it belonged to the fictional bike-share company, Cyclistic. This public data source will allow for an exploration of real-life data and the creation of an analysis for the project. To protect rider privacy, no personally identifiable information is included in the provided data. The data is housed in 12 separate CSV files, which can be [downloaded here.](https://divvy-tripdata.s3.amazonaws.com/index.html) 

The files were downloaded and saved in two formats: CSV and XLSX. The original data is structured data, with rows representing records and columns representing fields. Each table has an identical primary key field, "ride_id," which serves as a unique identifier for each trip. Each file has a total of 13 fields. 

##### Files
![cyclistic_file_table](https://user-images.githubusercontent.com/118931271/214158329-ea91ac7a-869b-4b9c-a81d-e070b061d284.PNG)
##### Schema
![cyclistic_original_schema](https://user-images.githubusercontent.com/118931271/214159035-aa1492f8-4d1d-4d54-ad02-f612eaf395ba.PNG)


##### Does the data ROCCC?
The data is reliable, original, comprehensive, current and cited. The data was compiled from accurate real-life trip data provided by Motivate International, Inc., the company that originally collected the data about its user’s activities.

---

### Process
#### Data Cleaning - Excel Processes/Power Query

I began processing the data by reviewing the contents of each excel file to identify any major issues. Notes were taken of common nulls and general observations were made. Due to the overall size of the data (5,828,235 rows), it was determined that continuing the data cleaning sheet by sheet would not be efficient. To address this, Excel Power Query was utilized to transform the larger data sets all at once. The data was imported and the cleaning process began.

+ Count Rows to ensure that data is complete after importing the data 
	- Transform Data > Count Rows
		- Total Rows = 5,828,235

+ Create a new column "ride_length" as a calculated column to obtain the ride duration
	- Add Column > Custom Column > Custom Column Formula
		- = [ended_at] - [started_at]
		- Transformed data type to duration to get the format D:HH:MM:SS

+ Filtered and counted rows for nulls & blanks

	![powerquery_null_blank_counts](https://user-images.githubusercontent.com/118931271/214161555-9fe0199d-ea2b-4e95-bc6c-a55967e0454e.PNG)

+ Filtered and counted ride_length 
	- ride_length <1 minute = 115,280
		- According to the owner of the source data, trips <1 minute are due to false starts or users trying to re-dock a bike to ensure it was secure
	- ride_length >23:59 hours = 5,411

+ Add day_of_week column
	- Copy started at column>Format Date > Day > Day of Week>Update formula to make 1 = Sunday, 7 = Saturday
		- = Table.AddColumn(#"Removed Columns", "Day of Week", each Date.DayOfWeek([#"started_at - Copy"]), Int64.Type)
 		- =Table.AddColumn(#"Removed Columns", "Day of Week", each Date.DayOfWeek([#"started_at - Copy"], Day.Sunday)+1, Int64.Type)

After making all the necessary changes to the file, I closed Power Query and loaded it to a connection only. This allowed me to proceed to analyze the data. As I was already familiar with how to do this in Excel, I decided to focus my efforts on improving and practicing my SQL and BigQuery skills. I also knew I would include some charts and summary tables in this write-up later. 

---

#### Data Cleaning - Using SQL in BigQuery

To begin the data cleaning process, I created a new project in BigQuery called "cyclistic-368022" and started adding data. Given the large size of the data, I had to create buckets for each of the 12 months of trip data provided by Motivate International, Inc. instead of just importing the data all at once. Once all the files were uploaded to BigQuery, I joined all 12 tables into a single table. The table covered the time period of October 2021 - September 2022. After merging the tables, I ran a Select All statement to make sure that the number of rows matched my previous count of 5,828,235 after importing the data.



'CREATE TABLE cyclistic-368022.trip_data.year_data_202110_202209 
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
# 5,828,235 rows displaying which includes nulls'

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

SELECT * 
FROM `cyclistic-368022.trip_data.cleaned_trips_202110_202209`

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
