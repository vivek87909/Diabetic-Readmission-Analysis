create database healthcare;
use healthcare;
CREATE TABLE patients_data (
    encounter_id INT,
    patient_nbr INT,
    race VARCHAR(100),
    gender VARCHAR(20),
    age VARCHAR(50),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    number_diagnoses INT,
    diag_1 VARCHAR(50),
    diag_2 VARCHAR(50),
    diag_3 VARCHAR(50),
    max_glu_serum VARCHAR(50),
    a1cresult VARCHAR(50),
    insulin VARCHAR(50),
    `change` VARCHAR(20),
    diabetesmed VARCHAR(20),
    readmitted VARCHAR(20),
    age_group VARCHAR(50) NULL,
    los_category VARCHAR(50) NULL,
    readmit_binary VARCHAR(10) NULL,     
    readmitted_num INT NULL);

  select count(*) from patients_data;
  SELECT 
    age_group,
    gender,
    COUNT(*) AS total_patients,
    SUM(readmitted_num) AS readmitted_count,
    CONCAT(ROUND((SUM(readmitted_num) / COUNT(*)) * 100,
                    2),
            '%') AS readmission_rate
FROM
    patients_data
GROUP BY age_group , gender
ORDER BY readmission_rate DESC;
  
 
 
 SELECT 
    diag_1,
    CASE 
        WHEN diag_1 LIKE '250%' THEN 'Diabetes'
        WHEN diag_1 LIKE '428%' THEN 'Heart Failure'
        WHEN diag_1 LIKE '414%' THEN 'Coronary Atherosclerosis (Heart)'
        WHEN diag_1 LIKE '486%' THEN 'Pneumonia'
        WHEN diag_1 LIKE '410%' THEN 'Heart Attack'
        WHEN diag_1 LIKE '786%' THEN 'Respiratory Abnormality'
        WHEN diag_1 LIKE '715%' THEN 'Osteoarthrosis'
        WHEN diag_1 LIKE '491%' THEN 'Chronic Bronchitis'
        WHEN diag_1 LIKE 'V57%' THEN 'Rehabilitation'
        ELSE 'Other / Less Common'
    END AS diagnosis_description,
    COUNT(*) AS total_cases,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rank_id
FROM patients_data
GROUP BY diag_1, diagnosis_description
ORDER BY total_cases DESC
LIMIT 10;


SELECT 
    `change` AS med_change_status, -- `change` is a keyword in MySQL, so we use backticks
    COUNT(*) AS total_patients,
    CONCAT(ROUND((SUM(readmitted_num) / COUNT(*)) * 100, 2), '%') AS readmission_rate
FROM patients_data
GROUP BY `change`;  




WITH HighRiskCohort AS (
    SELECT *
    FROM patients_data
    WHERE admission_source_id = 7  -- Emergency Room ID
      AND time_in_hospital > 10    -- Long stay
)
SELECT 
    patient_nbr,
    age_group,
    diag_1,
    readmit_binary as readmitted
FROM HighRiskCohort
LIMIT 10;


SELECT 
    patient_nbr,
    encounter_id,
    time_in_hospital AS current_days,
    LAG(time_in_hospital) OVER (PARTITION BY patient_nbr ORDER BY encounter_id) AS previous_visit_days,
    (time_in_hospital - LAG(time_in_hospital) OVER (PARTITION BY patient_nbr ORDER BY encounter_id)) AS change_in_days
FROM patients_data
LIMIT 20;  
  