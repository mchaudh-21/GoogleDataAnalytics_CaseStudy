# Cyclistic Bike-Share Case Study (Google Data Analytics Course)

## 📌 Overview
This case study analyzes historical ride data from Cyclistic, a fictional Chicago-based bike-share company. The goal is to explore how different consumer types use the system in order to inform a more profitable business model that attracts more long-term customers.

## 🧠 Scenario (Case Study Documentation)
Our task as a junior data analyst is to provide a concise analysis of how casual riders vs member riders use Cyclist differently. The goal is to maximize memberships to boost profits with a new marketing strategy and the help of our reccomendations. 

## 🔍 Guiding Question
**How do annual members and casual riders use Cyclistic bikes differently?**

## 🧰 Tools Used
- R / RStudio
- tidyverse (for data manipulation)
- ggplot2 (for visualizations)
- lubridate (for date/time processing)

## 📂 Data Sources
- `Divvy_Trips_2019_Q1.csv`
- `Divvy_Trips_2020_Q1.csv`
  
## 🧼 Data Cleaning
- Renamed columns in 2019 Q1 to match 2020 Q1 format
- Removed irrelevant columns (`gender`, `birthyear`, `tripduration`, etc.)
- Typecast shared columns to match data types
- Standardized user types (`Subscriber` → `member`, `Customer` → `casual`)
- Calculated ride length and extracted day of the week

## 📊 Descriptive Analysis
Key analyses performed to explore varying usage patterns:
- Ride count by user type
- Average and median ride length by user type
- Ride trends by day of the week
- Distribution of ride lengths to observe usage behavior

## 📈 Visualizations
Visual insights were generated using `ggplot2` and saved to a charts folder:
- Distribution of ride lengths
- Average ride length by rider type
- Ride counts by day of the week
- Average ride length by day of the week
- Peak usage time across the year by customer type

## 🔎 Findings
**Conclusion:**

Casual riders and annual riders show clear differences in spending behavior. 
Trends in my charts (see `divvy_analysis_charts`) show that casual riders take longer, less frequent rides, especially on weekends. This an suggest a leisure-based usage rather than out of neccesity. 
Members ride more frequently but for shorter durations, which suggests that they likely use the service for commuting or as part of a daily routine. 
Overall, these trends suggest that casual riders could be tourists or families that use the service for sightseeing or less routinely activities. 
Annual members are more than likely composed of working adults that use the service as a main mode of transportation. 
To best maximize subscription to this service, marketing should be increased on peak casual rider times, like weekends (Thursday-Sunday, see `avg_ride_by_day.png`), or peak months (March, see `frequency_by_month.png`)

**Recommendations:**
1) Increase pricing of single ride or day passes: This will incentive casual riders who frequently use the service to switch to a membership and overall save money. 
2) Promote marketing at peak timings (weekends and warmer months). 
3) Use digital campaigns focused on touristy activities and locations