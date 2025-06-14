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
## Variable Dictionary

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
