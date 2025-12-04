# 🏥 Diabetic Patient Readmission Analysis

## 📌 Project Overview
Hospital readmissions are a critical metric for healthcare quality and a major driver of financial penalties (CMS Readmission Reduction Program). This project analyzes **99,000+ clinical records** from 130 US hospitals to identify high-risk diabetic patients and factors contributing to readmission.

**Goal:** Build an end-to-end data pipeline (Python -> SQL -> Power BI) to predict patient risk and recommend operational interventions.

---

## 🛠️ Tech Stack
*   **Python:** Data Cleaning (Pandas), Feature Engineering, Statistical Testing (Scipy).
*   **MySQL:** Relational Database Design, Advanced Analysis (Window Functions, CTEs).
*   **Power BI:** Interactive Dashboarding & KPI Tracking.

---

## 🔍 Key Findings
### 1. Demographic Risk
Patients aged **60+** have the highest probability of readmission. There is a statistically significant correlation between Age and Readmission Risk (P-Value < 0.05).

### 2. Top Diagnoses
Using SQL ranking, we identified the top reasons for hospitalization:
1.  **Heart Failure (428)**
2.  **Diabetes (250)**
3.  **Respiratory Issues (486)**

### 3. The "Frequent Flyer" Cohort
We identified a specific high-risk segment: Patients entering via **Emergency**, staying **>7 days**, and having **Polypharmacy (15+ meds)**. This group represents the highest financial drain.

---

## 📊 Visualizations
*(Note: Upload your Power BI screenshot here later)*

---

## 💻 SQL Analysis
**Sample Query: Identifying High-Risk Patients via CTE**
```sql
WITH HighRiskCohort AS (
    SELECT *
    FROM patient_data
    WHERE admission_source LIKE '%Emergency%' 
      AND time_in_hospital > 7
)
SELECT count(*) FROM HighRiskCohort;
