-- =============================================
-- Data Quality Checks
-- =============================================

-- Null Patient IDs

SELECT COUNT(*)

FROM dim_patient

WHERE patient_id IS NULL;



-- Null Encounter IDs

SELECT COUNT(*)

FROM fact_encounters

WHERE encounter_id IS NULL;



-- Invalid Length of Stay

SELECT *

FROM fact_encounters

WHERE length_of_stay_days < 0;



-- Future Admissions

SELECT *

FROM fact_encounters

WHERE admission_date > CURRENT_DATE;



-- Duplicate Encounter IDs

SELECT

    encounter_id,

    COUNT(*)

FROM fact_encounters

GROUP BY encounter_id

HAVING COUNT(*) > 1;



-- Missing Discharge Dates

SELECT *

FROM fact_encounters

WHERE discharge_date IS NULL;



-- Patients without Encounters

SELECT

    p.patient_id

FROM dim_patient p

LEFT JOIN fact_encounters f

ON p.patient_id = f.patient_id

WHERE f.patient_id IS NULL;