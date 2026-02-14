# 🏗️ Calculated Columns & Parameters: Healthcare Analytics

This documentation outlines the calculated columns and field parameters used to refine patient data and financial tracking within the healthcare data model.

---

## 📑 Calculated Columns

These columns enrich the `fact_visits` and `patients` tables, enabling clinical performance tracking (like Length of Stay) and demographic segmentation.

| Table Name | Column Name | DAX Formula |
| --- | --- | --- |
| **fact_visits** | **Lenght of Stay** | `DATEDIFF(fact_visits[Admitted Date], fact_visits[Discharge Date], DAY)` |
| **fact_visits** | **Room Charge** | `fact_visits[Lenght of Stay] * fact_visits[Room Charges(daily rate)]` |
| **fact_visits** | **Billing Amount** | `fact_visits[Treatment Cost] + fact_visits[Medication Cost] + fact_visits[Room Charge]` |
| **fact_visits** | **Out-of-Pocket** | `fact_visits[Billing Amount] - fact_visits[Insurance Coverage]` |
| **fact_visits** | **Readmission** | See Multi-line Snippet Below |
| **patients** | **Age Group** | See Multi-line Snippet Below |
| **patients** | **Age Group 2** | See Multi-line Snippet Below |

---

## 🛠️ Field Parameters

Field parameters allow for dynamic reporting, letting users switch the granularity of visuals between geographic levels.

* **Geographic Parameter**:

  ```dax
  Parameter = {
      ("City", NAMEOF('cities'[City]), 0),
      ("State", NAMEOF('cities'[State]), 1)
  }
  ```

---

## 🧠 Complex Column Logic Explained

* **Readmission (fact_visits)**:
Identifies "unplanned" readmissions by checking if a follow-up visit occurred within a critical 31-day window after the initial encounter.

  ```dax
  IF(
      DATEDIFF(fact_visits[Date of Visit], fact_visits[Follow-Up Visit Date], DAY) <= 31 && 
      DATEDIFF(fact_visits[Date of Visit], fact_visits[Follow-Up Visit Date], DAY) > 0,
      1, 
      0
  )
  ```

* **Age Group (patients)**:
Standard 10-year brackets used for granular demographic analysis and clinical research.

  ```dax
  SWITCH( TRUE(),
      patients[Age] <= 17, "Below 18",
      patients[Age] <= 24, "18 - 24",
      patients[Age] <= 34, "25 - 34",
      patients[Age] <= 44, "35 - 44",
      patients[Age] <= 54, "45 - 54",
      patients[Age] <= 64, "55 - 64",
      patients[Age] <= 74, "65 - 74",
      "Above 74"
  )
  ```

* **Age Group 2 (patients)**:
Condensed age brackets optimized for high-level executive summary visuals and resource planning.

  ```dax
  SWITCH( TRUE(),
      patients[Age] <= 17, "Below 18",
      patients[Age] <= 24, "18 - 24",
      patients[Age] <= 44, "25 - 44",
      patients[Age] <= 64, "45 - 64",
      patients[Age] <= 74, "65 - 74",
      "Above 74"
  )
  ```

---

**🧠 Explanation of Complex Logics**

* **The 31-Day Clinical Rule**: The `Readmission` column implements a standard healthcare quality metric. By flagging visits that result in a return to the facility within 31 days, we can identify potential issues in discharge planning or treatment efficacy. The logic specifically excludes same-day events (`> 0`) to avoid counting continuous treatment sessions as new readmissions.

* **Financial Line-Item Totals**: The `Billing Amount` is a composite calculated column. Unlike simple ledger systems, this logic must aggregate three distinct cost drivers (Treatment, Medication, and Room). Because `Room Charge` is itself a calculated column (Length of Stay × Daily Rate), the model follows a sequential calculation path to ensure the final billing figure is accurate for both outpatient and inpatient encounters.

* **Out-of-Pocket (Patient Liability)**: This column acts as a financial bridge. By subtracting `Insurance Coverage` from the total `Billing Amount` at the row level, we can track the financial burden on the patient. This allows for high-level analysis of "Patient Financial Toxicity"—identifying which treatments or diagnoses are causing the highest personal costs for the community.

* **Dynamic Demographic Binning**: Having two versions of `Age Group` allows the dashboard to be adaptive. `Age Group` provides the granularity needed for specialized departments (like Geriatrics or Pediatrics), while `Age Group 2` collapses the 25–44 range into a single bucket, which is ideal for broad capacity planning and general wellness campaigns.
