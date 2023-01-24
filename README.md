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
The data is reliable, original, comprehensive, current and cited. The data is first-party data compiled from accurate real-life user trip data provided and collected by Motivate International, Inc. a subsidiary of Lyft, Inc.   

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

---
