-- =============================================
-- Gold Layer Validation Queries
-- =============================================

-- Total Patients
SELECT COUNT(*) AS total_patients
FROM dim_patient;

-- Total Encounters
SELECT COUNT(*) AS total_encounters
FROM fact_encounters;

-- Current Patient Records
SELECT COUNT(*) AS current_patients
FROM dim_patient
WHERE is_current = TRUE;

-- Duplicate Patient Check
SELECT
    patient_id,
    COUNT(*) AS record_count
FROM dim_patient
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- Missing Patient IDs
SELECT COUNT(*) AS missing_patient_ids
FROM dim_patient
WHERE patient_id IS NULL;

-- Encounter Count Per Patient
SELECT
    patient_id,
    COUNT(*) AS encounter_count
FROM fact_encounters
GROUP BY patient_id
ORDER BY encounter_count DESC
LIMIT 20;

-- Average Length of Stay
SELECT
    ROUND(AVG(length_of_stay_days),2) AS avg_length_of_stay
FROM fact_encounters;

-- Readmission Count
SELECT
    COUNT(*) AS readmissions
FROM fact_encounters
WHERE is_30day_readmission = TRUE;