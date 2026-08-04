-- =============================================
-- Readmission Analytics
-- =============================================

SELECT

    patient_id,

    COUNT(encounter_id) AS total_encounters,

    SUM(is_30day_readmission) AS readmissions,

    ROUND(AVG(length_of_stay_days),2) AS avg_length_of_stay,

    ROUND(AVG(high_risk_comorbidity_count),2) AS avg_high_risk_comorbidities

FROM fact_encounters

GROUP BY patient_id

ORDER BY readmissions DESC;



-- High Risk Patients

SELECT *

FROM analytical_mart.v_patient_readmission_features

ORDER BY

    total_30day_readmissions DESC,

    avg_high_risk_comorbidities DESC

LIMIT 20;