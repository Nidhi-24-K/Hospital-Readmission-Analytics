SELECT datname
FROM pg_database;

create schema if not exists analytics;

--What is our overall 30-day readmission picture?
CREATE VIEW analytics.vw_readmission_overview AS

SELECT
    COUNT(*) AS total_encounters,

    COUNT(DISTINCT patient_nbr) AS unique_patients,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct,

    ROUND(
        AVG(time_in_hospital),
        2
    ) AS avg_length_of_stay,

    ROUND(
        AVG(num_medications),
        2
    ) AS avg_medications

FROM clean.diabetic_encounters;

SELECT *
FROM analytics.vw_readmission_overview;


--Which patient age groups are associated with readmission?
CREATE VIEW analytics.vw_age_readmission AS
SELECT
    age_group,
    COUNT(*) AS total_encounters,
    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct
FROM clean.diabetic_encounters
GROUP BY age_group;

select * from analytics.vw_age_readmission;

--How does the length of stay associate with readmission rate?
CREATE VIEW analytics.vw_stay_readmission AS
SELECT
    CASE
        WHEN time_in_hospital BETWEEN 1 AND 2 THEN '1-2 days'
        WHEN time_in_hospital BETWEEN 3 AND 4 THEN '3-4 days'
        WHEN time_in_hospital BETWEEN 5 AND 7 THEN '5-7 days'
        ELSE '8-14 days'
    END AS stay_group,

    COUNT(*) AS total_encounters,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM clean.diabetic_encounters
GROUP BY stay_group;

select * from analytics.vw_stay_readmission;

-- Does medication and readmission rate affect each other?
CREATE VIEW analytics.vw_medication_readmission AS
SELECT
    CASE
        WHEN num_medications BETWEEN 0 AND 10 THEN '0-10'
        WHEN num_medications BETWEEN 11 AND 20 THEN '11-20'
        WHEN num_medications BETWEEN 21 AND 30 THEN '21-30'
        ELSE '31+'
    END AS medication_group,

    COUNT(*) AS total_encounters,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM clean.diabetic_encounters
GROUP BY medication_group;

select * from analytics.vw_medication_readmission;

-- view the views
SELECT * FROM analytics.vw_age_readmission;

SELECT * FROM analytics.vw_stay_readmission;

SELECT * FROM analytics.vw_medication_readmission;

-- Inpatient view
CREATE VIEW analytics.vw_inpatient_utilization AS

SELECT
    CASE
        WHEN number_inpatient = 0 THEN '0'
        WHEN number_inpatient = 1 THEN '1'
        WHEN number_inpatient = 2 THEN '2'
        WHEN number_inpatient = 3 THEN '3'
        ELSE '4+'
    END AS prior_inpatient_visits,

    COUNT(*) AS total_encounters,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM clean.diabetic_encounters

GROUP BY prior_inpatient_visits;

--ER View
CREATE VIEW analytics.vw_er_utilization AS

SELECT
    CASE
        WHEN number_emergency = 0 THEN '0'
        WHEN number_emergency = 1 THEN '1'
        WHEN number_emergency = 2 THEN '2'
        WHEN number_emergency = 3 THEN '3'
        ELSE '4+'
    END AS prior_er_visits,

    COUNT(*) AS total_encounters,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM clean.diabetic_encounters

GROUP BY prior_er_visits;

--discharge readmission view
CREATE VIEW analytics.vw_discharge_readmission AS

SELECT
    discharge_disposition,

    COUNT(*) AS total_encounters,

    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM clean.diabetic_encounters

GROUP BY discharge_disposition;