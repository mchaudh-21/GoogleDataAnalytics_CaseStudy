library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)

# Load CSV
q1_2019 <- read_csv("/Users/a19199/google-data-analytics/divvy-datasets/Divvy_Trips_2019_Q1.csv")
q1_2020 <- read_csv("/Users/a19199/google-data-analytics/divvy-datasets/Divvy_Trips_2020_Q1.csv")

# Check column names and rename to make it easier to combine into df
colnames(q1_2019)
colnames(q1_2020)

# Clean column structure
q1_2019_clean <- q1_2019 %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_name = from_station_name,
    start_station_id = from_station_id,
    end_station_name = to_station_name,
    end_station_id = to_station_id,
    member_casual = usertype,
    day_of_week = days_of_week
  ) %>%
  # Select only the columns that exist in q1_2020
  select(
    ride_id, started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual, ride_length, day_of_week
  )

# Standardize member_casual values
q1_2019_clean <- q1_2019_clean %>%
  mutate(member_casual = case_when(
    member_casual == "Subscriber" ~ "member",
    member_casual == "Customer" ~ "casual",
    TRUE ~ member_casual
  ))

# Convert ride_id to character in both datasets
q1_2019_clean <- q1_2019_clean %>%
  mutate(ride_id = as.character(ride_id))

q1_2020 <- q1_2020 %>%
  mutate(ride_id = as.character(ride_id))

divvy_df <- bind_rows(q1_2019_clean, q1_2020)

# Convert timestamps to datetime
divvy_df <- divvy_df %>%
  mutate(started_at = ymd_hms(started_at),
         ended_at = ymd_hms(ended_at),
         ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
         day_of_week = wday(started_at, label = TRUE),
         member_casual = tolower(member_casual))  

# Create file to save charts to 
output <- "/Users/a19199/google-data-analytics/divvy_analysis_charts"

# Summary stats of ride lengths by user type
summary_stats <- divvy_df %>%
  group_by(member_casual) %>%
  summarize(avg_ride = mean(ride_length, na.rm = TRUE),
            median_ride = median(ride_length, na.rm = TRUE),
            max_ride = max(ride_length, na.rm = TRUE),
            total_rides = n())

# Bar chart of avg ride length by user type
ggplot(summary_stats, aes(x = member_casual, y = avg_ride, fill = member_casual)) +
  geom_col() +
  labs(title = "Average Ride Length by User Type", y = "Average Ride Length (min)", x = "") +
  theme_minimal()
ggsave(file.path(output, "avg_ride_length_by_user.png"))

# Ride length by day of week
day_analysis <- divvy_df %>%
  group_by(member_casual, day_of_week) %>%
  summarize(avg_ride = mean(ride_length, na.rm = TRUE),
            count = n())

ggplot(day_analysis, aes(x = day_of_week, y = avg_ride, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Avg Ride Length by Day of Week", x = "Day of Week", y = "Avg Ride Length (min)") +
  theme_minimal()
ggsave(file.path(output, "avg_ride_by_day.png"))

# Rides by day by rider type
rides_by_day <- divvy_df %>%
  group_by(member_casual, day_of_week) %>%
  summarize(num_rides = n())

ggplot(rides_by_day, aes(x = day_of_week, y = num_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Number of Rides by Day", x = "Day of Week", y = "Total Rides") +
  theme_minimal()
ggsave(file.path(output, "rides_by_day.png"))

# Distribution of ride lengths 
ggplot(divvy_df, aes(x = ride_length, fill = member_casual)) +
  geom_histogram(bins = 100) +
  xlim(0, 60) +
  labs(title = "Distribution of Ride Lengths", x = "Ride Length (mins)") +
  theme_minimal()
ggsave(file.path(output, "ride_length_distribution.png"))

# Peak times by month 
# Create month column in df
divvy_df <- divvy_df %>%
  mutate(month = format(as.Date(started_at), "%Y-%m"))

# Group by month and user type to count rides
monthly_rides <- divvy_df %>%
  group_by(member_casual, month) %>%
  summarize(num_rides = n(), .groups = "drop")

# Plot the trends
ggplot(monthly_rides, aes(x = month, y = num_rides, color = member_casual, group = member_casual)) +
  geom_line(size = 1.2) +
  geom_point() +
  labs(
    title = "Monthly Ride Volume by User Type",
    x = "Month",
    y = "Number of Rides",
    color = "User Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(file.path(output, "frequency_by_month.png"))
