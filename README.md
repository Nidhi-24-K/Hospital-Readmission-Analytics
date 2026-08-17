## Hospital Readmission Analytics

### Identifying patterns associated with 30-day readmission among patients with diabetes

## 📌 Project Overview

Hospital readmissions are an important healthcare analytics problem because repeated hospitalizations can increase healthcare utilization, operational burden, and patient care complexity.

This project analyzes **101,766 inpatient encounters involving patients with diabetes** across 130 U.S. hospitals and integrated delivery networks from **1999–2008**.

The goal is to use **PostgreSQL and Tableau** to investigate:

> **Which patient, utilization, clinical, and discharge factors are associated with higher 30-day readmission, and where could care teams focus follow-up efforts?**

This project focuses on **descriptive and diagnostic analytics** rather than predicting individual patient outcomes.

---

## Business Question

> **Which factors are associated with higher 30-day hospital readmission, and where could healthcare teams focus follow-up efforts?**

---

## Key Questions

The analysis investigates four major areas:

### 1. Patient characteristics
- How does 30-day readmission vary across age groups?

### 2. Clinical complexity
- Does length of hospital stay relate to readmission?
- Does medication count relate to readmission?

### 3. Prior healthcare utilization
- Is previous inpatient utilization associated with higher readmission?
- Is previous emergency-room utilization associated with higher readmission?

### 4. Discharge planning
- Does discharge destination correspond with different observed readmission rates?

---

# 🗂️ Dataset

**Source:** UCI Machine Learning Repository

**Dataset:** Diabetes 130-US Hospitals for Years 1999–2008

The dataset contains clinical records from **130 U.S. hospitals and integrated delivery networks** over a ten-year period.

It contains:

- **101,766 encounters**
- **71,518 unique patients**
- **47 features**
- Patient demographics
- Admission and discharge information
- Laboratory and medication information
- Previous inpatient and emergency visits
- Diagnosis information
- Length of stay
- Readmission outcome

The original dataset defines three readmission outcomes:

- `<30` — readmitted within 30 days
- `>30` — readmitted after 30 days
- `NO` — not readmitted

## 🎥 Demo
https://github-production-user-asset-6210df.s3.amazonaws.com/139551318/637062337-338288db-1fa5-462a-9d3d-17bc7f8a3665.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20260817%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260817T165441Z&X-Amz-Expires=300&X-Amz-Signature=ad2b6583e095830898e5d6070f88bc2634b0015b018d0e7fc8cda1185811fd52&X-Amz-SignedHeaders=host&response-content-type=video%2Fmp4

### Source

UCI Machine Learning Repository:

https://archive.ics.uci.edu/dataset/296/diabetes%2B130-us%2Bhospitals%2Bfor%2Byears%2B1999-2008

**Citation:**

Clore, J., Cios, K., DeShazo, J., & Strack, B. (2014). *Diabetes 130-US Hospitals for Years 1999-2008*. UCI Machine Learning Repository. https://doi.org/10.24432/C5230J

The dataset is licensed under **CC BY 4.0**.

---

# Project Architecture

The project follows a simplified analytics pipeline:

```text
Raw CSV Files
      │
      ▼
Raw Schema
      │
      ▼
Data Cleaning & Validation
      │
      ▼
Clean Schema
      │
      ▼
Business Analysis
      │
      ▼
Analytics Views
      │
      ▼
CSV Extracts
      │
      ▼
Tableau Desktop
      │
      ▼
Interactive Tableau Dashboard
