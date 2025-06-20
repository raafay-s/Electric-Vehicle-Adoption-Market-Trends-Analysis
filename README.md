# Electric Vehicle Adoption & Infrastructure Analysis
## Project Overview
This project explores the growth of electric vehicle (EV) adoption across the United States from 2018 to 2023, using a combination of cleaned state-level data and a fully interactive Power BI dashboard. The analysis covers key factors influencing EV uptake, including registration trends, charging infrastructure, financial incentives, fuel prices, income levels, and political affiliation. The main objective was to conduct a comprehensive, data-driven analysis of the key enablers and obstacles in the EV transition using Python for data prep, Oracle SQL for modeling and logic, and Power BI for interactive visualization. By transforming raw data into a structured format, this project successfully enables a multi-angle exploration of how adoption patterns differ across geography and time. The resulting dashboard empowers users to uncover state-specific insights, compare policy impacts, analyze nationwide charging infrastructures, and assess nationwide progress toward EV transition goals.

## Technologies and Libraries
* **Python (pandas)**: Used for data cleaning, preprocessing, and preparing the dataset for analysis
* **Oracle SQL**: Employed for querying, transforming, and organizing data into analytical views
* **Power BI**: Utilized to build interactive dashboards and visualize key trends and insights

## Files Included
* **EV_Data.csv**: Raw dataset containing electric vehicle adoption and infrastructure data across U.S. states
* **EV_Data_Cleaned.csv**: Cleaned and preprocessed version of the raw EV dataset
* **ev_adoption_analysis_views.sql**: SQL script that creates analytical views for exploring EV trends and metrics
* **ev_adoption_schema_setup.sql**: SQL script to define and set up the database schema
* **ev_data_cleaning_script.py**: Python script used to clean, preprocess, and export the raw data
* **EV Adoption Overview & Market Trends Analysis.pbix**: Power BI report file containing the interactive dashboards
* **EV Adoption Overview & Market Trends Analysis.pdf**: Static PDF export of the Power BI report

## Dataset Summary
I worked with a comprehensive dataset from Kaggle that compiled state-level EV adoption data from 2018 to 2023. The dataset contained economic indicators, environmental sentiment scores, charging infrastructure counts, and vehicle registration metrics across all 50 states
<details>
<summary><strong>Click to expand Variable Dictionary</strong></summary>

<br>

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
</details>

## Data Workflow Overview
This project followed a manual ETL-style process to move from raw data to interactive insights. Although not automated, the workflow mirrored the structure of a traditional ETL pipeline:
* Extract: Pulled raw EV data from Kaggle
* Transform: Cleaned and preprocessed using Python (pandas)
* Load: Imported the cleaned data into an Oracle SQL database under the EV_ADOPTION table and connected Power BI to the SQL views 


**Extract & Clean (Python)**

I began by collecting a raw CSV dataset from Kaggle (shown above) that combined multiple governmental and nonprofit sources into a yearly EV adoption panel dataset. Using Python with pandas, I cleaned the dataset by:
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

I also implemented a stored procedure called **SUMMARIZE_EV_BY_YEAR**. This procedure is designed to generate a yearly summary report that captures the most important trends in the dataset. Specifically, it looks at all the data in the EV_ADOPTION table and, for each year, calculates three key metrics: the average EV share percentage (how widespread EV usage is), the average per capita income, and the total number of public EV charging stations. The procedure then inserts one row per year with those stats into a new table called **EV_YEARLY_SUMMARY**. This makes it much easier to  analyze how these metrics have changed over time in dashboards without rerunning complex queries. The dataset I used in this project is a static snapshot, but my stored procedure is designed to calculate and update yearly EV summary statistics. If connected to a dynamic data source, such as recurring API feeds or automated CSV uploads with updated data, this procedure could be scheduled to run regularly and keep the summary table up to date without manual intervention, allowing dashboards to reflect real-time trends.

**Visualization (Power BI)**

In Power BI, I connected directly to the SQL views and imported the query results to build a comprehensive and interactive report, Using dynamic slicers for year and state, I created multiple focused report pages to cover different aspects of the analysis:
* EV Adoption Overview in the U.S.
* Charging Infrastructure Analysis
* Policy & Incentive Impact
* Demographics & Economy

I utilized a variety of visuals including card visuals for key metrics, scatter plots to reveal relationships between variables, line charts to show trends over time, and bar charts for comparisons across categories. To enhance user experience and interactivity, I incorporated tooltips for additional context, zoom sliders to allow detailed analysis of smaller data ranges, synchronized visuals that respond dynamically to each other’s selections, and slicers to filter data by relevant dimensions. This interactive Power BI dashboard enables users to easily explore the dataset, uncover patterns, and gain actionable insights into the evolving EV landscape.

## Results and Analysis
Below are a few selected insights from the many analyses conducted across the EV dataset. These findings are based on interactive visuals, measures, and page-level filters available in the Power BI dashboard. To explore the full report, including all pages, visuals, breakdowns, and slicers, please download the EV Adoption Overview & Market Trends Analysis Power BI file and view it directly.

* **National EV Adoption is Accelerating Rapidly**
   * From 2018 to 2023:
     * EV registrations grew from ~572K to ~3.56M, a 6x increase.
     * The average EV share across states rose from 0.14% to 0.90%.
     * This sharp rise reflects widespread growth, especially in progressive or urbanized states.

* **Charging Infrastructure Growth is Lagging Slightly Behind**
     * Although charging outlets expanded, from ~64K in 2018 to ~176K in 2023, the growth rate lags behind EV registration growth.
     * Some states have over 50 EVs per outlet, signaling potential strain and congestion.
     * DC fast charging stations remain limited compared to Level 2 stations, which are much more widespread.

* **Political Affiliation Highlights Stark Divide**
     * Democratic states have nearly double the EV share compared to Republican states on average.
     * This reflects not only political climate but also infrastructure policy, urban density, and environmental emphasis.

* **Gasoline Prices Show Modest Influence**
    * As gas prices rose from ~$2.56 to $3.12 per gallon (2018–2023), EV adoption rose too, but not always in a directly proportional way.
    * States with high gas prices but poor infrastructure or incentives still had lower EV shares.
    * This suggests gas prices are a somewhat contributing, but not significant, factor.

* **Education Level Does Not Strongly Predict EV Adoption**
    * While states like California had both high EV share and high numbers of bachelor’s degrees held, this pattern did not generalize.
    * Many states with high educational attainment had low EV adoption, and many states with low educational attainment still exhibited relatively high EV share.
    * This suggests that factors have a much stronger influence than education level alone.
    * In other words, higher education is not a reliable standalone predictor of EV market growth across states.

These findings reflect a very narrow portion of the full report. To explore all visuals, you can download and open the complete Power BI file to access the full dashboard experience.

## Limitations & Challenges
Despite the comprehensive nature of this project, several limitations and challenges were encountered:
* **Static Dataset**: The dataset used was a static snapshot from 2018 to 2023, which limits the ability to analyze real-time trends or sudden market changes.
* **Limited Geographic Granularity**: Analysis was performed at the state level, which can mask important regional or local variations within states.
* **External Factors Not Included**: Other external influences, such as supply chain constraints, technological advances, or cultural attitudes, were not included but could significantly impact EV adoption trends.
* **Manual ETL Process**: The ETL workflow was manual which reduces scalability and can increase the risk of human error. Automating these processes would improve reliability.
  
## Conclusion
This analysis showcases the full lifecycle of a comprehensive data-driven approach, from raw data to clear and actionable insights. By leveraging Python for  data cleaning and preprocessing, Oracle SQL for data modeling and logic implementation, and Power BI for visualization, this project successfully uncovers multifaceted trends shaping electric vehicle adoption across the United States from 2018 to 2023. 
Through the implementation of reusable SQL views and a stored procedure to summarize yearly metrics, this project lays the groundwork for future scalability and automation, enabling timely updates as new data becomes available. The Power BI dashboard’s interactivity—through slicers, zoom sliders, synchronized visuals, and contextual tooltips allows users to explore data from multiple perspectives, compare states, and evaluate the impact of policies and infrastructure investments.
While this project does face limitations such as static datasets and manual ETL processes, it nevertheless provides an analytical framework that can inform decision-makers aiming to accelerate the transition to electric mobility. Ultimately, these insights emphasize that coordinated efforts across charging infrastructure, incentive programs, and policy alignment are critical to advancing EV adoption nationwide!
