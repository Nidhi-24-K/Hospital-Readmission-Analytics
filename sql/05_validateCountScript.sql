-- Verify the total number of encounters in each view matches the total number of encounters in the readmission overview view

SELECT SUM(total_encounters)
FROM analytics.vw_age_readmission;

SELECT SUM(total_encounters)
FROM analytics.vw_stay_readmission;

SELECT SUM(total_encounters)
FROM analytics.vw_medication_readmission;

SELECT SUM(total_encounters)
FROM analytics.vw_inpatient_utilization;

SELECT SUM(total_encounters)
FROM analytics.vw_er_utilization;

SELECT SUM(total_encounters)
FROM analytics.vw_discharge_readmission;