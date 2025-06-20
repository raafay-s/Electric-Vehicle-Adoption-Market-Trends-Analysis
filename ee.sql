-- View 1: Preview 10 Rows from the Table
-- Purpose: Basic sanity check to ensure EV_ADOPTION table is working
SELECT * FROM EV_ADOPTION FETCH FIRST 10 ROWS ONLY;

-- View 2: Top EV States by Latest Year
-- Purpose: Show the top 10 states with the highest EV share in the most recent year
CREATE OR REPLACE VIEW top_ev_states AS
SELECT state, year, ev_share_percent
FROM EV_ADOPTION
WHERE (state, year) IN (
  SELECT state, MAX(year)
  FROM EV_ADOPTION
  GROUP BY state
)
ORDER BY ev_share_percent DESC
FETCH FIRST 10 ROWS ONLY;

-- View 3: EV Registration Growth Year-over-Year
-- Purpose: Track how EV registrations are changing each year per state
CREATE OR REPLACE VIEW ev_registration_growth AS
SELECT state, 
       year, 
       ev_registrations,
       ev_registrations - LAG(ev_registrations) OVER (PARTITION BY state ORDER BY year) AS ev_growth
FROM EV_ADOPTION
ORDER BY state, year;

-- View 4: Average EV Share Growth Across All States
-- Purpose: Determine the average EV share growth across all states from 2018–2023
CREATE OR REPLACE VIEW avg_ev_share_growth AS
SELECT ROUND(AVG(share_growth), 2) AS avg_ev_share_growth
FROM (
  SELECT state, year, 
         ev_share_percent - LAG(ev_share_percent) OVER (PARTITION BY state ORDER BY year) AS share_growth
  FROM EV_ADOPTION
)
WHERE share_growth IS NOT NULL;

-- View 5: Fastest Growing Low-Adoption States
-- Purpose: Show states that started with <1% EV share and had the largest growth
CREATE OR REPLACE VIEW fast_ev_adopters AS
SELECT state, 
       MIN(year) AS start_year,
       MAX(ev_share_percent) - MIN(ev_share_percent) AS total_ev_share_growth
FROM EV_ADOPTION
GROUP BY state
HAVING MIN(ev_share_percent) < 1
ORDER BY total_ev_share_growth DESC
FETCH FIRST 10 ROWS ONLY;

-- View 6: EVs Per Charging Outlet
-- Purpose: Identify which states are most under-supported by infrastructure
CREATE OR REPLACE VIEW evs_per_outlet AS
SELECT state, 
       year,
       ev_registrations,
       total_charging_outlets,
       ROUND(ev_registrations / NULLIF(total_charging_outlets, 0), 2) AS evs_per_outlet
FROM EV_ADOPTION
ORDER BY evs_per_outlet DESC;

-- View 7: Charging Infrastructure vs. EV Share
-- Purpose: Explore correlation between charging availability and EV share
CREATE OR REPLACE VIEW outlets_vs_evshare AS
SELECT state,
       ROUND(AVG(total_charging_outlets), 0) AS avg_outlets,
       ROUND(AVG(ev_share_percent), 2) AS avg_ev_share
FROM EV_ADOPTION
GROUP BY state
ORDER BY avg_outlets DESC;

-- View 8: Incentives vs. EV Share
-- Purpose: Examine whether incentives impact EV share growth
CREATE OR REPLACE VIEW incentive_vs_evshare AS
SELECT state, 
       year, 
       incentives, 
       ev_share_percent
FROM EV_ADOPTION
WHERE incentives IS NOT NULL
ORDER BY incentives DESC;

-- View 9: States with High Incentives vs. Median
-- Purpose: Compare EV share for states with incentives above the median
CREATE OR REPLACE VIEW above_median_incentive_evshare AS
SELECT ROUND(AVG(ev_share_percent), 2) AS avg_ev_share_high_incentive
FROM EV_ADOPTION
WHERE incentives > (
  SELECT MEDIAN(incentives) FROM EV_ADOPTION WHERE incentives IS NOT NULL
);

-- View 10: Education Level vs. EV Share (Yearly)
-- Purpose: Analyze education level and EV share over time
CREATE OR REPLACE VIEW education_vs_evshare AS
SELECT state, 
       year, 
       education_bachelor,
       ev_share_percent
FROM EV_ADOPTION
ORDER BY education_bachelor DESC;

-- View 11: Education Level vs. EV Share (State Average)
-- Purpose: Get average education and EV share per state
CREATE OR REPLACE VIEW avg_education_vs_evshare AS
SELECT state,
       ROUND(AVG(education_bachelor), 2) AS avg_bachelor,
       ROUND(AVG(ev_share_percent), 2) AS avg_ev_share
FROM EV_ADOPTION
GROUP BY state
ORDER BY avg_bachelor DESC;

-- View 12: Income vs. EV Share
-- Purpose: Compare average income and EV share per state
CREATE OR REPLACE VIEW income_vs_evshare AS
SELECT state,
       ROUND(AVG(per_cap_income), 0) AS avg_income,
       ROUND(AVG(ev_share_percent), 2) AS avg_ev_share
FROM EV_ADOPTION
GROUP BY state
ORDER BY avg_income DESC;

-- View 13: Political Affiliation vs. EV Share
-- Purpose: Compare EV adoption between Democratic and Republican states
CREATE OR REPLACE VIEW party_vs_evshare AS
SELECT party,
       ROUND(AVG(ev_share_percent), 2) AS avg_ev_share
FROM EV_ADOPTION
GROUP BY party
ORDER BY avg_ev_share DESC;

-- View 14: Gasoline Price vs. EV Share Over Time
-- Purpose: See if gas prices affect EV share adoption over time
CREATE OR REPLACE VIEW gas_price_vs_evshare AS
SELECT state, 
       year, 
       gasoline_price_per_gallon,
       ev_share_percent
FROM EV_ADOPTION
ORDER BY gasoline_price_per_gallon DESC;


-- Stored Procedure: Yearly Summary Reporting
-- Purpose: Stored procedure that creates a yearly summary table with average EV share, income, and total stations

-- Step 1: Create the summary table (run once before the procedure)
CREATE TABLE EV_YEARLY_SUMMARY (
  year NUMBER,
  avg_ev_share NUMBER(5, 2),
  ev_registrations NUMBER,
  total_charging_outlets NUMBER,
  avg_income NUMBER,
  total_stations NUMBER
);

-- Step 2: Stored Procedure to populate the summary table
CREATE OR REPLACE PROCEDURE summarize_ev_by_year AS
BEGIN
  INSERT INTO EV_YEARLY_SUMMARY (year, avg_ev_share, avg_income, total_stations)
  SELECT 
    year,
    ROUND(AVG(ev_share_percent), 2),
    SUM(ev_registrations),
    SUM(charging_outlets),
    ROUND(AVG(per_cap_income), 0),
    SUM(stations)
  FROM EV_ADOPTION
  GROUP BY year;
  COMMIT;
END;
/

--Step 3: Run & Automate stored procedure
--This block creates a scheduled job named 'RUN_EV_YEARLY_SUMMARY_MONTHLY'. It executes the 'summarize_ev_by_year' stored procedure monthly on the 1st day at midnight
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'RUN_EV_YEARLY_SUMMARY_MONTHLY',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'summarize_ev_by_year',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
    enabled         => TRUE,
    auto_drop       => FALSE,
    comments        => 'Monthly job to refresh EV_YEARLY_SUMMARY table'
  );
END;
/