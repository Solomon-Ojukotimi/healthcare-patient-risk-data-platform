-- =============================================
-- Patient 360 Queries
-- =============================================

SELECT
    p.patient_id,
    p.gender,
    p.age,
    p.age_group,
    p.marital_status,

    COUNT(f.encounter_id) AS encounters,

    AVG(f.length_of_stay_days) AS avg_los,

    SUM(f.is_30day_readmission) AS readmissions,

    AVG(f.comorbidity_count) AS avg_comorbidities

FROM fact_encounters f

JOIN dim_patient p
ON f.patient_id = p.patient_id

WHERE p.is_current = TRUE

GROUP BY

    p.patient_id,
    p.gender,
    p.age,
    p.age_group,
    p.marital_status

ORDER BY readmissions DESC;