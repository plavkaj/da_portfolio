# Cyclistic Bike-Share Analysis

**Google Data Analytics Capstone Project** *Analysis of usage patterns between Casual Riders and Annual Members to drive membership growth.*

## Project Overview
**Cyclistic**, a bike-share company in Chicago, aims to maximize the number of annual memberships. The Director of Marketing believes the company’s future success depends on maximizing the number of annual memberships. 

**The Goal:** Design marketing strategies aimed at converting casual riders into annual members.

**The Business Question:** *How do annual members and casual riders use Cyclistic bikes differently?*

## Tech Stack
* **Data Cleaning & Analysis:** R (Tidyverse, Lubridate, Arrow)
* **Data Visualization:** Tableau Public
* **Report:** RMarkdown

## Data Source
**Source:** [Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)  
**Date Range:** August 2024 – July 2025  
**Data Provider:** Motivate International Inc. (under [this license](https://divvybikes.com/data-license-agreement))

* **Files used:** 12 monthly CSV files (`202408-divvy-tripdata.csv` to `202507-divvy-tripdata.csv`)
* **Volume:** Approx. 5 million+ rows of data.
* *Note: Due to GitHub file size limits, raw data files are not uploaded to this repository.*

## Data Cleaning (R)
The original dataset contained 12 separate CSV files. The following steps were taken in R to clean and prepare the data:

1.  **Merged** all 12 months of data into a single dataframe.
2.  **Standardized** columns: Trimmed whitespace and converted categorical data (like `rideable_type`) to lowercase.
3.  **Feature Engineering:**
    * Created `trip_duration` (ended_at - started_at).
    * Extracted `day_of_week` and `hour_of_day`.
4.  **Data Quality Check:**
    * Removed trips shorter than 60 seconds (potential false starts).
    * Removed trips longer than 24 hours (outliers/stolen bikes).
    * Handled missing values in station names.

*(See `scripts/analysis.Rmd` for the detailed code)*

## Key Findings
* **Finding 1:** Casual riders take significantly longer trips, peaking on weekends, suggesting a focus on leisure and tourism.
* **Finding 2:** Members are consistent weekday commuters, taking shorter, more direct trips that peak during rush hour.
* **Bike Preference:** Casual riders have a stronger preference for electric bikes compared to members.

## Dashboard
An interactive dashboard was created in Tableau to visualize these trends.

[![Dashboard Preview](images/dashboard_screenshot.png)](https://public.tableau.com/views/CyclisticBike-ShareAnAnalysisofMemberandCasualRiders_17562803507210/Dashboard-HowdoannualmembersandcasualridersuseCyclisticbikesdifferently?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

> **[Click here to view the interactive dashboard on Tableau Public](https://public.tableau.com/views/CyclisticBike-ShareAnAnalysisofMemberandCasualRiders_17562803507210/Dashboard-HowdoannualmembersandcasualridersuseCyclisticbikesdifferently?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

## Recommendations
To convert casual riders into members, focus marketing efforts on the benefits of subscription services for leisure riding:
1.  **"Weekend Warrior" Membership:** Create a weekend-only membership tier.
2.  **Duration-Based Incentives:** Offer benefits that reward longer rides (e.g., "First 45 mins free").
3.  **Leisure Campaigns:** Target ad spend on weekends and near tourist hotspots (as seen in the map visualization).

---
*Author: Juraj Plavka* *Date: December 11, 2025*

