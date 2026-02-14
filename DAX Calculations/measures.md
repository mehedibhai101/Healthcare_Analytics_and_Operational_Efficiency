# 📊 Measures & Calculations: Healthcare Analytics

This documentation provides a complete catalog of all DAX measures used in the Healthcare Analytics project, organized by functional category.

---

## 💰 Financial Performance

**Total Billing Amount**: The sum of all invoices generated for patient visits.

  * **Formula**: `SUM(fact_visits[Billing Amount])`
  * **Format**: `0`

**Total Insurance Coverage**: Total amount covered by insurance providers.

  * **Formula**: `SUM(fact_visits[Insurance Coverage])`
  * **Format**: `General`

**Total Out-of-Pocket**: Total amount paid directly by patients.

  * **Formula**: `SUM(fact_visits[Out-of-Pocket])`
  * **Format**: `General`

**Total Medication Cost**: Total cost of medicines prescribed.

  * **Formula**: `SUM(fact_visits[Medication Cost])`
  * **Format**: `0`

**Total Treatment Cost**: Total cost of medical procedures and treatments.

  * **Formula**: `SUM(fact_visits[Treatment Cost])`
  * **Format**: `0`

**Total Room Charge**: Total revenue generated from room utilization.

  * **Formula**: `SUM(fact_visits[Room Charge])`
  * **Format**: `0`

**Avg Billing Amount**: Average revenue per visit.

  * **Formula**: `AVERAGE(fact_visits[Billing Amount])`
  * **Format**: `General`

**Avg Out-of-Pocket**: Average direct cost to the patient per visit.

  * **Formula**: `AVERAGE(fact_visits[Out-of-Pocket])`
  * **Format**: `General`

**Avg Insurance Coverage**: Average amount covered by insurance per visit.

  * **Formula**: `AVERAGE(fact_visits[Insurance Coverage])`
  * **Format**: `General`

**Avg Medication Cost**: Average cost of medication per visit.

  * **Formula**: `AVERAGE(fact_visits[Medication Cost])`
  * **Format**: `General`

**Avg Treatment Cost**: Average cost of treatment per visit.

  * **Formula**: `AVERAGE(fact_visits[Treatment Cost])`
  * **Format**: `General`

**Avg Room Charge**: Average room charge per admitted visit.

  * **Formula**: `AVERAGE(fact_visits[Room Charge])`
  * **Format**: `General`

**Neg Insurance Coverage**: Helper measure for waterfall charts (negative value).

  * **Formula**: `- [Total Insurance Coverage]`
  * **Format**: `General`

**Collection Rate**: Percentage of visits where payment status is pending.

  * **Formula**: `DIVIDE(CALCULATE([Total Visits], fact_visits[Payment Status]="Pending"),[Total Visits])`
  * **Format**: `General`

---

## 🏥 Visits & Operational Metrics

**Total Visits**: Total count of patient encounters.

  * **Formula**: `COUNT(fact_visits[Date of Visit])`
  * **Format**: `0`

**Total Patients**: Count of unique patients treated.

  * **Formula**: `DISTINCTCOUNT(fact_visits[Patient ID])`
  * **Format**: `0`

**Emergency Visits**: Count of visits flagged as emergencies.

  * **Formula**: `CALCULATE(COUNT(fact_visits[Emergency Visit]),fact_visits[Emergency Visit]="Yes")`
  * **Format**: `0`

**% Emergency Visit**: Percentage of total visits that were emergencies.

  * **Formula**: `DIVIDE([Emergency Visits],[Total Visits], "--")`
  * **Format**: `General`

**Admission Rate**: Ratio of admitted visits to total visits.
  
  * **Formula**: `DIVIDE(COUNTA(fact_visits[Admitted Date]), [Total Visits])`
  * **Format**: `General`

**Avg Lenght of Stay**: Average duration (in days) of hospital stay.

  * **Formula**: `AVERAGE(fact_visits[Lenght of Stay])`
  * **Format**: `General`

**Avg Satisfaction Score**: Average patient feedback score.

  * **Formula**: `AVERAGE(fact_visits[Patient Satisfaction Score])`
  * **Format**: `General`

**Follow-up Visits**: Count of recorded follow-up appointments.

  * **Formula**: `COUNTA(fact_visits[Follow-Up Visit Date])`
  * **Format**: `0`

**Readmission**: Ratio of readmissions to total visits.

  * **Formula**: `DIVIDE(SUM(fact_visits[Readmission]), [Total Visits])`
  * **Format**: `General`

**Readmission Rate**: Ratio of follow-up dates to initial visit dates.

  * **Formula**: `DIVIDE(COUNTA(fact_visits[Follow-Up Visit Date]), COUNTA(fact_visits[Date of Visit]))`
  * **Format**: `General`

**Room Utilization**: Percentage of visits requiring room allocation.

  * **Formula**: `1-DIVIDE(CALCULATE([Total Visits], fact_visits[Room Type]="N/A"), [Total Visits])`
  * **Format**: `General`

---

## 🛡️ Insurance & Coverage Analysis

**Insurance Coverage %**: Percentage of total billing covered by insurance.

  * **Formula**: `DIVIDE([Total Insurance Coverage], [Total Billing Amount], "--")`
  * **Format**: `General`

**Insured Patients%**: Percentage of unique patients with insurance coverage.

  * **Formula**: `1-DIVIDE(CALCULATE([Total Patients], ISBLANK(fact_visits[Insurance Coverage])), [Total Patients])`
  * **Format**: `0`

**Total Insured Patients**: Count of patients with valid insurance.

  * **Formula**: `[Total Patients]-CALCULATE([Total Patients], ISBLANK(fact_visits[Insurance Coverage]))`
  * **Format**: `0`

---

## 👥 Demographics & Distribution (Formatting)

**Male Axis**: Count of male patients (Positive Axis).

  * **Formula**: `1 * CALCULATE([Total Patients], patients[Gender]="Male")`
  * **Format**: `0`

**Female Axis**: Count of female patients (Negative Axis for Tornado Charts).

  * **Formula**: `-1 * CALCULATE([Total Patients], patients[Gender]="Female")`
  * **Format**: `0`

**M%**: Formatted string for Male percentage label.

  * **Formula**:
  
  ```dax
  "Male ("&ROUND(DIVIDE(CALCULATE([Total Patients], patients[Gender]="Male"), [Total Patients]), 3)*100&"%)"
  ```
  
  * **Format**: `General`

**F%**: Formatted string for Female percentage label.

  * **Formula**:
  
  ```dax
  "("&ROUND(DIVIDE(CALCULATE([Total Patients], patients[Gender]="Female"), [Total Patients]), 3)*100&"%) Female "
  ```
  
  * **Format**: `General`

**Scotland%**: Dynamic Label for Scotland patient share.

  * **Formula**:
  
  ```dax
  "Scotland"&UNICHAR(10)&"("&ROUND(DIVIDE(CALCULATE([Total Patients], cities[State]="Scotland"), [Total Patients]), 3)*100&"%)"
  ```
  
  * **Format**: `General`

**England%**: Dynamic Label for England patient share.

  * **Formula**:
  
  ```dax
  "England"&UNICHAR(10)&"("&ROUND(DIVIDE(CALCULATE([Total Patients], cities[State]="England"), [Total Patients]), 3)*100&"%)"
  ```
  
  * **Format**: `General`

**Wales%**: Dynamic Label for Wales patient share.

  * **Formula**:
  
  ```dax
  "Wales"&UNICHAR(10)&"("&ROUND(DIVIDE(CALCULATE([Total Patients], cities[State]="Wales"), [Total Patients]), 3)*100&"%)"
  ```
  
  * **Format**: `General`

**N. Ireland%**: Dynamic Label for Northern Ireland patient share.

  * **Formula**:
  
  ```dax
  "N. Ireland"&UNICHAR(10)&"("&ROUND(DIVIDE(CALCULATE([Total Patients], cities[State]="Northern Ireland"), [Total Patients]), 3)*100&"%)"
  ```
  
  * **Format**: `General`

---

## 🏷️ Dynamic Labels & Text Formats

**%Department**: Share of billing amount by Department.

  * **Formula**: `FORMAT(DIVIDE([Total Billing Amount],CALCULATE([Total Billing Amount], ALL(department[Department]))), "0.0%")`
  * **Format**: `General`

**%Diagnosis**: Share of billing amount by Diagnosis.

  * **Formula**: `FORMAT(DIVIDE([Total Billing Amount],CALCULATE([Total Billing Amount], ALL(diagnose[Diagnosis]))), "0.00%")`
  * **Format**: `General`

**%Procedure**: Share of billing amount by Procedure.

  * **Formula**: `FORMAT(DIVIDE([Total Billing Amount],CALCULATE([Total Billing Amount], ALL(procedures[Procedure]))), "0.0%")`
  * **Format**: `General`

**Month Label**: Dynamic axis title for Month slicers.

  * **Formula**:
  
  ```dax
   IF(      ISFILTERED(date_table[Month Full Name]), "", "Month" )
  ```
  
  * **Format**: `General`

**Year Label**: Dynamic axis title for Year slicers.

  * **Formula**:
  
  ```dax
   IF(      ISFILTERED(date_table[Year]), "", "Year" )
  ```
  
  * **Format**: `General`

**Procedure Label**: Dynamic axis title for Procedure slicers.

  * **Formula**:
  
  ```dax
   IF(      ISFILTERED(procedures[Procedure]), "", "Procedure" )
  ```
  
  * **Format**: `General`

**Active Dept**: Returns the currently selected department name.

  * **Formula**: `SELECTEDVALUE(department[Department])`
  * **Format**: `General`

---

**🧠 Explanation of Complex Logics**

**Demographic Tornado Charting**: The `Male Axis` and `Female Axis` measures are designed specifically for a "Population Pyramid" or "Tornado" chart. By multiplying the Female count by -1, we force the bar chart to extend to the left of the zero axis, while the Male count (multiplied by 1) extends to the right. This creates a mirrored visual comparison without requiring complex custom visuals.

**Dynamic Geographic Labels**: Measures like `Scotland%` and `England%` use `UNICHAR(10)` to insert a line break directly into the data label. This allows the visual to display the Region Name on the top line and the calculated Percentage on the bottom line within a single text element, keeping the dashboard clean and space-efficient.

**Inverse Logic for Utilization**: The `Room Utilization` and `Insured Patients%` measures calculate their values by subtraction (1 - Non-Utilized/Uninsured). This "Inverse Logic" is often faster and cleaner than filtering for the positive case, especially when the "Null" or "N/A" condition (e.g., `Room Type="N/A"`) is easier to isolate than listing all possible valid room types.

**Context-Aware Titles**: The `Month Label` and `Year Label` measures use `ISFILTERED`. This is a UI/UX trick. When a user selects a specific month, the axis title disappears (returns `""`) to reduce clutter, as the context is obvious. When no filter is applied, it reappears to guide the user.
