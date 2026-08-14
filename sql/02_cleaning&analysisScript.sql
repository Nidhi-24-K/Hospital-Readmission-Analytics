SELECT datname
FROM pg_database;

create schema if not exists clean;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'ids_mapping'
ORDER BY ordinal_position;

select *
from raw.ids_mapping;

CREATE TABLE clean.admission_type_map (
    admission_type_id INTEGER PRIMARY KEY,
    admission_type VARCHAR(50)
);

INSERT INTO clean.admission_type_map
(admission_type_id, admission_type)
VALUES
(1, 'Emergency'),
(2, 'Urgent'),
(3, 'Elective'),
(4, 'Newborn'),
(5, 'Not Available'),
(6, NULL),
(7, 'Trauma Center'),
(8, 'Not Mapped');

SELECT *
FROM clean.admission_type_map
ORDER BY admission_type_id;

SELECT
    d.encounter_id,
    d.admission_type_id,
    m.admission_type
FROM raw.diabetic_data AS d
LEFT JOIN clean.admission_type_map AS m
    ON d.admission_type_id = m.admission_type_id;

CREATE TABLE clean.discharge_disposition_map (
    discharge_disposition_id INTEGER PRIMARY KEY,
    description VARCHAR(255)
);
INSERT INTO clean.discharge_disposition_map
(discharge_disposition_id, description)
VALUES
(1, 'Discharged to home'),
(2, 'Discharged/transferred to another short term hospital'),
(3, 'Discharged/transferred to SNF'),
(4, 'Discharged/transferred to ICF'),
(5, 'Discharged/transferred to another type of inpatient care institution'),
(6, 'Discharged/transferred to home with home health service'),
(7, 'Left AMA'),
(8, 'Discharged/transferred to home under care of Home IV provider'),
(9, 'Admitted as an inpatient to this hospital'),
(10, 'Neonate discharged to another hospital for neonatal aftercare'),
(11, 'Expired'),
(12, 'Still patient or expected to return for outpatient services'),
(13, 'Hospice / home'),
(14, 'Hospice / medical facility'),
(15, 'Discharged/transferred within this institution to Medicare approved swing bed'),
(16, 'Discharged/transferred/referred another institution for outpatient services'),
(17, 'Discharged/transferred/referred to this institution for outpatient services'),
(18, NULL),
(19, 'Expired at home. Medicaid only, hospice.'),
(20, 'Expired in a medical facility. Medicaid only, hospice.'),
(21, 'Expired, place unknown. Medicaid only, hospice.'),
(22, 'Discharged/transferred to another rehab facility including rehab units of a hospital'),
(23, 'Discharged/transferred to a long term care hospital'),
(24, 'Discharged/transferred to a nursing facility certified under Medicaid but not Medicare'),
(25, 'Not Mapped'),
(26, 'Unknown/Invalid'),
(27, 'Discharged/transferred to a federal health care facility'),
(28, 'Discharged/transferred/referred to a psychiatric hospital or psychiatric distinct part unit'),
(29, 'Discharged/transferred to a Critical Access Hospital (CAH)'),
(30, 'Discharged/transferred to another type of health care institution not defined elsewhere');

select *
from raw.ids_mapping;

SELECT
    d.encounter_id,
    d.discharge_disposition_id,
    m.description AS discharge_disposition
FROM raw.diabetic_data AS d
LEFT JOIN clean.discharge_disposition_map AS m
    ON d.discharge_disposition_id = m.discharge_disposition_id;


CREATE TABLE clean.admission_source_map (
    admission_source_id INTEGER PRIMARY KEY,
    description VARCHAR(255)
);
INSERT INTO clean.admission_source_map
(admission_source_id, description)
VALUES
(1, 'Physician Referral'),
(2, 'Clinic Referral'),
(3, 'HMO Referral'),
(4, 'Transfer from a hospital'),
(5, 'Transfer from a Skilled Nursing Facility (SNF)'),
(6, 'Transfer from another health care facility'),
(7, 'Emergency Room'),
(8, 'Court/Law Enforcement'),
(9, 'Not Available'),
(10, 'Transfer from critical access hospital'),
(11, 'Normal Delivery'),
(12, 'Premature Delivery'),
(13, 'Sick Baby'),
(14, 'Extramural Birth'),
(15, 'Not Available'),
(17, NULL),
(18, 'Transfer From Another Home Health Agency'),
(19, 'Readmission to Same Home Health Agency'),
(20, 'Not Mapped'),
(21, 'Unknown/Invalid'),
(22, 'Transfer from hospital inpatient/same facility resulting in a separate claim'),
(23, 'Born inside this hospital'),
(24, 'Born outside this hospital'),
(25, 'Transfer from Ambulatory Surgery Center'),
(26, 'Transfer from Hospice');

SELECT * FROM clean.discharge_disposition_map
ORDER BY discharge_disposition_id;

SELECT * FROM clean.admission_source_map
ORDER BY admission_source_id;


CREATE TABLE clean.diabetic_encounters AS
SELECT
    d.encounter_id,
    d.patient_nbr,

    -- Demographics
    NULLIF(d.race, '?') AS race,
    d.gender,
    d.age AS age_group,

    -- Encounter information
    d.admission_type_id,
    a.admission_type,
    d.discharge_disposition_id,
    dd.description AS discharge_disposition,
    d.admission_source_id,
    s.description AS admission_source,

    -- Hospital utilization
    d.time_in_hospital,
    d.number_outpatient,
    d.number_emergency,
    d.number_inpatient,

    -- Clinical activity
    d.num_lab_procedures,
    d.num_procedures,
    d.num_medications,
    d.number_diagnoses,

    -- Diagnoses
    NULLIF(d.diag_1, '?') AS diag_1,
    NULLIF(d.diag_2, '?') AS diag_2,
    NULLIF(d.diag_3, '?') AS diag_3,

    -- Diabetes testing
    d.max_glu_serum,
    d."A1Cresult",

    -- Diabetes treatment
    d.insulin,
    d.change,
    d."diabetesMed",

    -- Outcome
    CASE
        WHEN d.readmitted = '<30' THEN 'Readmitted <30 days'
        WHEN d.readmitted = '>30' THEN 'Readmitted >30 days'
        WHEN d.readmitted = 'NO' THEN 'Not readmitted'
        ELSE 'Unknown'
    END AS readmission_status

FROM raw.diabetic_data AS d

LEFT JOIN clean.admission_type_map AS a
    ON d.admission_type_id = a.admission_type_id

LEFT JOIN clean.discharge_disposition_map AS dd
    ON d.discharge_disposition_id = dd.discharge_disposition_id

LEFT JOIN clean.admission_source_map AS s
    ON d.admission_source_id = s.admission_source_id;


SELECT COUNT(*)
FROM clean.diabetic_encounters;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT encounter_id) AS unique_encounters,
    COUNT(DISTINCT patient_nbr) AS unique_patients
FROM clean.diabetic_encounters;

SELECT
    readmission_status,
    COUNT(*) AS encounters
FROM clean.diabetic_encounters
GROUP BY readmission_status
ORDER BY encounters DESC;

SELECT
    COUNT(*) AS total_encounters,
    COUNT(*) FILTER (
        WHERE readmission_status = 'Readmitted <30 days'
    ) AS readmitted_within_30_days,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE readmission_status = 'Readmitted <30 days'
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct
FROM clean.diabetic_encounters;

--which age group have higher 30 day readmission rates
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
GROUP BY age_group
ORDER BY age_group;

-- Does prior inpatient utilization relate to 30-day readmission?
SELECT
    number_inpatient,
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
GROUP BY number_inpatient
ORDER BY number_inpatient;

-- Prior emergency visits
SELECT
    number_emergency as prior_er_visits,
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
GROUP BY number_emergency
ORDER BY number_emergency;

-- Are patients with longer hospital stays more likely to be readmitted within 30 days?
SELECT
    CASE
        WHEN time_in_hospital BETWEEN 1 AND 2 THEN '1-2 days'
        WHEN time_in_hospital BETWEEN 3 AND 4 THEN '3-4 days'
        WHEN time_in_hospital BETWEEN 5 AND 7 THEN '5-7 days'
        WHEN time_in_hospital BETWEEN 8 AND 14 THEN '8-14 days'
        ELSE '15+ days'
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

GROUP BY stay_group

ORDER BY
    MIN(time_in_hospital);

-- Are encounters involving more medications associated with higher 30-day readmission?

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

GROUP BY medication_group

ORDER BY MIN(num_medications);

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
GROUP BY discharge_disposition
ORDER BY total_encounters DESC;

