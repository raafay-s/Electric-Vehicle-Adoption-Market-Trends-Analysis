# Title
## Project Overview
This project focuses on analyzing the landscape of Electric Vehicle (EV) adoption across the United States from 2018 to 2023. By leveraging data related to EV registrations, infrastructure availability, economic indicators, education levels, and political affiliation, I aimed to uncover meaningful insights about what drives EV growth and where the adoption gaps lie. I also analyzed how different socioeconomic and policy-based factors influence EV adoption and growth across states. The main objective was to conduct a comprehensive, data-driven analysis of the key enablers and obstacles in the EV transition using SQL and Power BI for analysis and visualization.

## Technologies and Libraries
* **Python (pandas)**: Used for data cleaning, preprocessing, and preparing the dataset for analysis
* **Oracle SQL**: Employed for querying, transforming, and organizing data into analytical views
* **Power BI for**: Utilized to build interactive dashboards and visualize key trends and insights

## Files Included
* **EV_Data.csv**: Raw dataset containing electric vehicle adoption and infrastructure data across U.S. states
* **EV_Data_Cleaned.csv**: Cleaned and preprocessed version of the raw EV dataset
* **ev_adoption_analysis_views.sql**: SQL script that creates analytical views for exploring EV trends and metrics
* **ev_adoption_schema_setup.sql**: SQL script to define and set up the database schema
* **ev_data_cleaning_script.py**: Python script used to clean, preprocess, and export the raw data

# Dataset Summary
I worked with a comprehensive dataset that compiled state-level EV adoption data from 2018 to 2023. The dataset contained economic indicators, environmental sentiment scores, charging infrastructure counts, and vehicle registration metrics across all 50 states
| Variable                             | Description                                                                 |
|--------------------------------------|-----------------------------------------------------------------------------|
| `state`                              | US state                                                                   |
| `year`                               | Year of observation                                                        |
| `ev_registrations`                  | Number of Electric Vehicles registered                                     |
| `total_vehicles`                    | Total number of all vehicle registrations in the state                     |
| `ev_share_percent`                  | Percentage of total vehicles that are electric vehicles                    |
| `stations`                          | Number of public EV charging stations                                      |
| `total_charging_outlets`           | Total number of individual charging plugs available at public stations     |
| `level_1`                           | Number of Level 1 charging outlets                                         |
| `level_2`                           | Number of Level 2 charging outlets                                         |
| `dc_fast`                           | Number of DC Fast charging outlets                                         |
| `fuel_economy`                      | Average fuel economy of all vehicles in the state (e.g., MPG)              |
| `incentives`                        | Presence and/or details of state-level EV incentives                       |
| `number_of_metro_organizing_committees` | Number of metropolitan planning organizations in the state           |
| `population_20_64`                  | Working-age population (ages 20–64)                                        |
| `education_bachelor`               | Number of people with a Bachelor's degree or higher                        |
| `labour_force_participation_rate`  | Percentage of the working-age population in the labor force                |
| `unemployment_rate`                | Percentage of the labor force that is unemployed                           |
| `bachelor_attainment`             | Percentage of the total population with a Bachelor's degree or higher      |
| `per_cap_income`                   | Average income per person in the state                                     |
| `affectweather`                    | Concern about climate change impacts                                       |
| `devharm`                          | Concern about potential harm from development                              |
| `discuss`                          | Frequency of discussing environmental issues                               |
| `exp`                              | Environmental experience or exposure                                       |
| `localofficials`                   | Trust in local environmental officials                                     |
| `personal`                         | Sense of personal responsibility toward environment                        |
| `reducetax`                        | Support for reducing taxes for environmental policies                      |
| `regulate`                         | Support for environmental regulation                                       |
| `worried`                          | Worry about environmental problems                                         |
| `price_cents_per_kwh`              | Average electricity price per kilowatt-hour (cents)                        |
| `gasoline_price_per_gallon`        | Average gasoline price per gallon                                          |
| `total`                            | Total number of registered vehicles                                        |
| `trucks`                           | Number of registered trucks                                                |
| `trucks_share`                     | Percentage of total vehicles that are trucks                               |
| `party`                            | Predominant political party of the state                                   |

# Data Workflow Overview
**Extract & Clean (Python)**
I began by collecting a raw CSV dataset from Kaggle that combined multiple governmental and nonprofit sources into a yearly EV adoption panel dataset. Using Python with pandas, I cleaned the dataset by:
* Removing null and irrelevant rows
* Fixing data types
* Converting all column headers to lowercase and consistent naming
* Handling special cases such as dividing by zero where charging outlets were 0
* Replacing or imputing missing values where needed using median or forward fill strategies

**Data Modeling and Analysis (Oracle SQL)**
Once cleaned, the data was loaded into Oracle SQL. I created a master table **EV_ADOPTION**, into which I inserted the entire dataset. Then I wrote a collection of CREATE VIEW statements to build logic layers that answered specific questions including (but not limited to):
* EV registration growth by year using LAG() window functions
* Average EV share growth across years and states
* Identifying under-supported states by computing EVs per charging station
* Comparing EV share with income, education, political party, and incentives
* Ranking top 10 states by recent EV share

I also implemented a stored procedure called **SUMMARIZE_EV_BY_YEAR**. This procedure is designed to generate a yearly summary report that captures the most important trends in the dataset. Specifically, it looks at all the data in the EV_ADOPTION table and, for each year, calculates three key metrics: the average EV share percentage (how widespread EV usage is), the average per capita income, and the total number of public EV charging stations. The procedure then inserts one row per year with those stats into a new table called **EV_YEARLY_SUMMARY**. This makes it much easier to  analyze how these metrics have changed over time in dashboards without rerunning complex queries.

Furthermore, the dataset I used in this project is a static snapshot, but my stored procedure is designed to calculate and update yearly EV summary statistics. If connected to a dynamic data source, such as recurring API feeds or automated CSV uploads with updated data, this procedure could be scheduled to run regularly and keep the summary table up to date without manual intervention, allowing dashboards to reflect real-time trends.

**Visualization (Power BI)**
In Power BI, I connected to the SQL views and imported results. Using interactive slicers for year and state, I built multiple report pages highlighting:
* EV Adoption Overview
* Charging Infrastructure Analysis
* Policy Impact
* Socioeconomic Influences

# Conclusion
This EV Adoption project demonstrates a complete data pipeline. It started from messy raw data to a polished interactive dashboard. I explored electric vehicle adoption trends across the U.S. by correlating socioeconomic, environmental, and infrastructural factors. Using Python, SQL, and Power BI, I was able answer many complex questions and discover new trends. My findings show that states with strong incentives, higher income, and better charging infrastructure tend to have significantly higher EV adoption. This kind of insight can inform real-world policy and investment decisions in clean transportation infrastructure.

