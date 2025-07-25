# 🎓Student Result Processing System

## 📌 Objective
A MySQL-based system to manage student academic records, calculate GPA, display pass/fail statistics, generate rank lists, and export results.

---

##  Technologies Used
- MySQL 8.0+
- MySQL Workbench / CLI
- SQL

---

##  Database Schema

### Tables:
1. **Students** – Student ID, name, department.
2. **Courses** – Course ID, name, and credit weight.
3. **Semesters** – Semester IDs and names.
4. **Grades** – Marks and grades for each course per student.
5. **GPA_Log** – GPA per student per semester (auto-updated using triggers).

---

##  Features
- GPA Calculation (credit-weighted).
- Pass/Fail Statistics.
- Semester-wise Rank List using `RANK()` window function.
- Trigger to auto-calculate GPA.
- Export result summary to CSV.

---

##  Grade Points

| Grade | Points |
|-------|--------|
| A     | 10     |
| B     | 8      |
| C     | 6      |
| D     | 4      |
| F     | 0      |

**Formula:**  
`GPA = Σ (Grade_Points × Credits) / Σ Credits`

---

##  How to Use
1. Open MySQL Workbench.
2. Run the full SQL script 
3. Use provided queries for:
   - GPA per student per semester
   - Rank list
   - Pass/fail summary
4. Export results using `SELECT ... INTO OUTFILE` (optional).

---

##  Deliverables
- SQL Script
- GPA Trigger
- Rank List Query
- README file
- Project Report

---

## 📌 Author
Project by: Maheshwaram sadhana


---
