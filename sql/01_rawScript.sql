CREATE DATABASE diabetes_readmission;
CREATE SCHEMA raw;

SELECT datname
FROM pg_database;

CREATE SCHEMA IF NOT EXISTS raw;

select COUNT(*)
from raw.diabetic_data;

select COUNT(*)
from raw.ids_mapping;

select *
from raw.diabetic_data
limit 10;

select 
COUNT(*) as total_rows, COUNT(distinct encounter_id) as unique_encounters
from raw.diabetic_data;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'diabetic_data'
ORDER BY ordinal_position;

SELECT *
FROM raw.diabetic_data
LIMIT 5;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE race = '?') AS race_unknown,
    COUNT(*) FILTER (WHERE weight = '?') AS weight_unknown,
    COUNT(*) FILTER (WHERE payer_code = '?') AS payer_unknown,
    COUNT(*) FILTER (WHERE medical_specialty = '?') AS specialty_unknown
from raw.diabetic_data;

SELECT age, COUNT(*) AS encounters
FROM raw.diabetic_data
GROUP BY age
ORDER BY age;

SELECT readmitted, COUNT(*) AS encounters
FROM raw.diabetic_data
GROUP BY readmitted
ORDER BY readmitted;

SELECT *
FROM raw.ids_mapping

SELECT
    COUNT(DISTINCT admission_type_id) AS admission_types,
    COUNT(DISTINCT discharge_disposition_id) AS discharge_types,
    COUNT(DISTINCT admission_source_id) AS admission_sources
FROM raw.diabetic_data;

SELECT DISTINCT readmitted
FROM raw.diabetic_data;


SELECT
    COUNT(*) FILTER (WHERE race = '?') AS race,
    COUNT(*) FILTER (WHERE weight = '?') AS weight,
    COUNT(*) FILTER (WHERE payer_code = '?') AS payer_code,
    COUNT(*) FILTER (WHERE medical_specialty = '?') AS medical_specialty,
    COUNT(*) FILTER (WHERE diag_1 = '?') AS diag_1,
    COUNT(*) FILTER (WHERE diag_2 = '?') AS diag_2,
    COUNT(*) FILTER (WHERE diag_3 = '?') AS diag_3
from raw.diabetic_data;

SELECT
    COUNT(DISTINCT patient_nbr) AS unique_patients,
    COUNT(*) AS total_encounters
FROM raw.diabetic_data;
