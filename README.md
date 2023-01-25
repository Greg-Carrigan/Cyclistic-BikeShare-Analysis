# Cyclistic-BikeShare-Analysis
### Google data analytics professional certificate case study: Converting casual bikeshare riders to members

###### Greg Carrigan 
###### 11/21/2022 
<hr/>

### Case Study Scenario

Cyclistic is a Chicago-based bike-share company that features a network of 5,824 geo-tracked bicycles and 692 docking stations spread throughout the city as an alternative transportation option. Bikes can be unlocked and returned to any of the available docking stations at any time. Cyclistic offers a variety of bike options for its riders which includes bikes for riders with disabilities. Customers are classified into two categories, members and casual riders. Customers who purchase a single-ride or day pass are referred to as casual riders and those who purchase an annual membership are members. Cyclistic customers generally ride more for leisure, however, approximately 30% of riders use the bike-share service for their daily commute. Cyclistic’s finance analysts conclude that although a smaller portion of riders makes up annual members, memberships are much more profitable than single-ride and day-pass casual riders.


---


### Ask
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

For this case study, 12 months of real bike-share trip data have been provided by Motivate International, Inc. under [this license.](https://www.divvybikes.com/data-license-agreement) The data will be used as if it belonged to the fictional bike-share company, Cyclistic. This public data source will allow for an exploration of real-life data and the creation of an analysis for the project. To protect rider privacy, no personally identifiable information is included in the provided data. The data is housed in 12 separate CSV files, which can be [downloaded here.](https://divvy-tripdata.s3.amazonaws.com/index.html) 

The files were downloaded and saved in two formats: CSV and XLSX. The original data is structured data, with rows representing records and columns representing fields. Each table has an identical primary key field, "ride_id," which serves as a unique identifier for each trip. Each file has a total of 13 fields. 

#### Files
![cyclistic_file_table](https://user-images.githubusercontent.com/118931271/214158329-ea91ac7a-869b-4b9c-a81d-e070b061d284.PNG)
#### Schema
![cyclistic_original_schema](https://user-images.githubusercontent.com/118931271/214159035-aa1492f8-4d1d-4d54-ad02-f612eaf395ba.PNG)


#### Does the data ROCCC?
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


### Data Cleaning - Using SQL in BigQuery

[SQL Code - Data Cleaning File](https://github.com/Greg-Carrigan/Cyclistic-BikeShare-Analysis/blob/320d55fbd3ef39dfe04a21d0b9f303e1401632b9/data_cleaning.sql)


---


### Analyze & Share

[SQL Code - Analysis File](https://github.com/Greg-Carrigan/Cyclistic-BikeShare-Analysis/blob/11b62ae461d3298bd4dec8acc4506c2d5959d234/analysis.sql)


#### Tableau Dashboard - [Cyclistic User Behavior](https://public.tableau.com/views/CyclisticUserBehavior/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

![tableau_dashboard](https://user-images.githubusercontent.com/118931271/214441477-48b3e0ec-ab0e-4185-b984-7c9458262043.PNG)

Using 12 months of Cyclistic customer trip data spanning the months of October 2021-September 2022, I was able to make some determinations about the user behavior of both classifications of customers, casual users, and annual members: 

Of the total 4,474,141 trips taken by Cyclistic customers, annual members made up the majority of trips at 59.64% or 2,668,166 trips compared to casual users at 40.36% completing a total of 1,805,975 trips.  Although casual users took fewer trips they utilized Cyclistic’s service for extended periods of travel time with an average ride duration of 24.44 minutes compared to the annual member average ride duration of 11.99 minutes. 

When comparing trips taken by casual users and annual members it became evident that annual members are utilizing the service as more of a means of commute, and casual users are riding Cyclistic's bikes for everyday travel and leisure. A larger proportion of casual user trips occur on Saturdays (388,184 rides) and Sundays (313,937 rides). Annual members took more trips on weekdays than weekends. Annual member average ridership times reveal a peak occurring twice in the graph during the approximate commute hours at 8 AM and 4 PM. Casual users showed a more gradual increase in trips as the day progressed, with a single peak occurring later in the day at approximately 4 PM. 

In a future analysis of ridership behavior, it may be worthwhile to investigate what percentage of causal users are utilizing the service to commute home after work. There appears to be a correlation in the peak ride times during the 4 PM hour. 

The seasonal changes had an overall impact on the number of rides taken by both classifications of users, with users taking a larger amount of trips during the warmer months. Rides declined during the winter and fall months in Q1 & Q4. During Q1(2022), a total of 385,289 trips were taken. Of that, 94,905 were by casual users, and 290,384 were by annual members. In Q4(2021), a combined 910,247 casual user and annual member trips were taken. Of that, 304,171 trips were completed by casual users and 606,076 by annual members. Q3(2022) presented as the busiest quarter, with a combined 1,783,150 trips,  802,688 casual users, and 980,462 annual members. Although the total utilization fell during the cooler seasons, annual members still completed a larger share of the trips taken.


##### Ride totals by customer type and day of the week

![ride_totals_by_customertype_weekday_sql](https://user-images.githubusercontent.com/118931271/214700361-cd7fb5b1-1e06-419f-a7ef-81ee5241fd99.PNG)

![ride_totals_by_customertype_weekday](https://user-images.githubusercontent.com/118931271/214695602-3c5edb0f-b977-4af8-8549-44ad7c71b49c.PNG)

![ride_totals_by_customertype_weekday_chart](https://user-images.githubusercontent.com/118931271/214695865-e76a6085-77f9-465e-84ca-a796f7e80ed5.PNG)


##### Average ride duration by customer type

![avg_ride_duration_customertype_sql](https://user-images.githubusercontent.com/118931271/214700818-3fc16c39-e45e-4ff2-b96c-cccb3fff792f.PNG)

![avg_ride_duration_customertype_tbl](https://user-images.githubusercontent.com/118931271/214700913-24294d20-8208-4203-baf4-de96e48a4c77.PNG)


##### Ride totals by day of week - Days categorized as weekday or weekend

![ride_totals_by_dow_weekdayname_sql](https://user-images.githubusercontent.com/118931271/214701520-95a0c654-c9d5-4afa-8818-4ef28898203c.PNG)

![ride_totals_by_dow_weekdayname_tbl](https://user-images.githubusercontent.com/118931271/214701702-41284696-c9e9-44a9-9187-066f0fbb4f07.PNG)


##### Total rides by customer type and hour
![total_rides_customertype_hour_sql](https://user-images.githubusercontent.com/118931271/214701941-e8826354-29ed-42db-8ce5-b56b2a460b90.PNG)

![total_rides_customertype_hour_tbl](https://user-images.githubusercontent.com/118931271/214702058-e41dfab6-0f7e-46e9-9684-ff8c0fb93e78.PNG)

![total_rides_customertype_hour_crt](https://user-images.githubusercontent.com/118931271/214702182-0d620707-8715-4574-b473-e70198e4c633.PNG)


##### Total rides by month and customer type
![image](https://user-images.githubusercontent.com/118931271/214702359-249642c5-2405-4e1d-93b6-2e34a8689e6b.png)

![image](https://user-images.githubusercontent.com/118931271/214702893-fc437992-eccb-4d3f-80a4-4d81a6c01502.png)


##### Rideable type percent by customer type
![image](https://user-images.githubusercontent.com/118931271/214703119-1dc281c7-7cc2-4c99-a4f1-ab7c0e41a2be.png)

![image](https://user-images.githubusercontent.com/118931271/214703178-a78887b1-4fa4-4c95-be79-70de4b064e7e.png)


##### Average ride duration by rideable type
![image](https://user-images.githubusercontent.com/118931271/214703443-df14dec3-39ea-4a13-aa79-7f51f43a63e5.png)

![image](https://user-images.githubusercontent.com/118931271/214703525-ad1fe7e1-8036-4d2b-a058-6a9b48d08b58.png)


##### Total rides by customer type and rideable type
![image](https://user-images.githubusercontent.com/118931271/214703812-2190281a-0c23-436f-94bf-5596be840e24.png)

![image](https://user-images.githubusercontent.com/118931271/214703858-4102734c-5065-413c-9b5f-8efaaf0f0b63.png)


##### Top 10 start stations
![image](https://user-images.githubusercontent.com/118931271/214703985-53a84f0a-5fca-4e3b-9ac8-0a974765063e.png)

![image](https://user-images.githubusercontent.com/118931271/214704022-095364b0-af7a-492f-b200-a408a0c34478.png)


##### Top 10 end stations
![image](https://user-images.githubusercontent.com/118931271/214704135-38b637f4-a1c9-45bc-b4fa-3f6541197383.png)


##### Total rides by quarter and customer type
	- New column added for quarter/year as Quarter
	- New view created that includes the quater column
	
![image](https://user-images.githubusercontent.com/118931271/214704491-790a621d-36cd-4e01-a8d2-0eb4d24a7bdc.png)

![image](https://user-images.githubusercontent.com/118931271/214704568-e90852d0-ac19-47c8-8cf6-3644961ab105.png)

![image](https://user-images.githubusercontent.com/118931271/214704638-2510f40e-d2b1-4881-ab03-2c6577741eac.png)


---


### Act

#### Recommendations
Annual members are likely regular commuters whereas casual users may be those with alternative means to commute or visitors to the city. Casual customers make up a large number of Cyclistic's user base and with those numbers, there is a strong probability that a lot more casual users can be converted to loyal Cyclistic annual members. 

Cyclistic should implement a marketing campaign that targets casual users to convert them into members. Targeting the advertisement campaign towards casual users will help to drive more traffic to the service. The offering of membership incentives may have the greatest impact on swaying casual users to join the membership program.  

+ Discount programs - A discount can be applied to service charges during peak commute hours for new members. Advertisements targeting new members should be placed on buses and trains in high-visibility areas where commuters are utilizing other means to commute to work. This would help to enforce brand recognition and its membership program.  

+ Tailoring Membership Categories - Annual memberships can be split up to help create a more tailored membership approach. The memberships could be split up into different categories to offer users a category of membership that best suits their needs such as weekday, weekend, and seasonal memberships. Pricing could be staggered to give those who utilize the service most, the highest discount. 

+ Loyalty Bonus - An additional incentive that can be offered by Cyclistic could be to offer a loyalty bonus such as offering free or steeply discounted rides after a certain number of trips are completed. 

---
