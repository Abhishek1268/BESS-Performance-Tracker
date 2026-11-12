# BESS Performance Tracker

An end-to-end Battery Energy Storage System (BESS) performance tracking 
project built with Python, SQL and Excel VBA — from synthetic data generation 
to a fully automated 5-sheet Excel dashboard.

---

## Project Overview

This project simulates a real-world BESS monitoring and reporting workflow:

1. **Python** generates 730 days of realistic battery cycle data with built-in
   degradation trends and C-rate dependent efficiency, injected directly into 
   a SQLite database
2. **SQL** analyses the data across 9 queries — covering efficiency, charging 
   costs, degradation tracking, peak shaving savings and C-rate analysis
3. **Excel VBA** reads the SQL output automatically and builds a 5-sheet 
   dashboard with formatted tables and charts — no manual work required

---

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Python 3 | Synthetic data generation, database population |
| SQLite / DB Browser | Relational database storage |
| SQL | Data analysis and KPI calculation |
| Excel VBA | Dashboard automation and chart generation |

---

## Database Schema

### `site_info`
Metadata for each BESS site.

| Column | Type | Description |
|---|---|---|
| site_id | INTEGER | Primary key |
| site_name | TEXT | Site identifier |
| location | TEXT | Physical location |
| capacity_kwh | REAL | Total battery capacity (kWh) |
| max_power_kw | REAL | Maximum charge/discharge power (kW) |

### `tariff_zones`
Time-of-use tariff rates mapped to each hour of the day.

| Column | Type | Description |
|---|---|---|
| hour | INTEGER | Hour of day (0–23) |
| zone | TEXT | off-peak / shoulder / peak |
| rate_eur_kwh | REAL | Electricity rate (EUR/kWh) |

### `battery_cycles`
One record per charge/discharge cycle per site.

| Column | Type | Description |
|---|---|---|
| cycle_id | INTEGER | Primary key |
| site_id | INTEGER | Foreign key → site_info |
| cycle_date | TEXT | Date of cycle |
| charge_start | TEXT | Charge start time |
| charge_end | TEXT | Charge end time |
| discharge_start | TEXT | Discharge start time |
| discharge_end | TEXT | Discharge end time |
| energy_in_kwh | REAL | Energy charged (kWh) |
| energy_out_kwh | REAL | Energy discharged (kWh) |
| soc_start | REAL | State of charge at start (%) |
| soc_end | REAL | State of charge at end (%) |
| c_rate | REAL | C-rate of each cycle (energy_in / capacity) |

---

## Python Data Generator

`python/generate_data.py` populates the database with 730 realistic cycles:

- 365 days × 2 sites = 730 cycles
- Charge windows set to off-peak hours (01:00 to 07:00)
- Discharge windows set to peak hours (08:00 to 20:00)
- Built-in degradation: BESS_North loses ~1.7% efficiency over the year,
  BESS_South loses ~2.7% (56% faster degradation rate)
- C-rate calculated per cycle as energy_in / site capacity
- RTE penalty applied as a function of C-rate, based on
  Preger et al. (Sandia National Laboratories, J Electrochem Soc 2020)
  which found RTE varied by up to 10% depending on cycling conditions
- Random noise added to simulate real operating variability

---

## SQL Queries

| File | Description |
|---|---|
| `01_create_tables.sql` | Creates all three database tables |
| `02_efficiency_per_cycle.sql` | Round-trip efficiency per cycle |
| `03_charging_cost.sql` | Charging cost using time-of-use tariffs |
| `04_performance_summary.sql` | Full performance summary with status flag |
| `05_site_summary.sql` | Aggregated KPIs per site |
| `06_monthly_summary.sql` | Monthly efficiency, energy and cost per site |
| `07_degradation_trend.sql` | Monthly efficiency degradation vs January baseline |
| `08_peak_shaving_savings.sql` | Monthly net savings from peak/off-peak arbitrage |
| `09_rte_vs_crate.sql` | RTE vs C-rate analysis by band and site |

---

## Key Metrics

| Metric | Formula |
|---|---|
| Round-trip efficiency | (energy_out / energy_in) × 100 |
| C-rate | energy_in / site capacity (kWh) |
| Charging cost | energy_in × off-peak tariff rate |
| Discharge revenue | energy_out × peak tariff rate |
| Net peak shaving saving | discharge revenue − charging cost |
| Degradation | monthly avg efficiency − January baseline |
| Status flag | OK if efficiency ≥ 90%, else Below target |

---

## Excel VBA Dashboard

`vba/BuildDashboard.bas` builds the full 5-sheet dashboard automatically
from CSV files exported from SQL queries:

### Sheet 1 — Dashboard
- 730 rows of cycle-level performance data
- Blue header row, red highlighting for Below target cycles
- Line chart: efficiency trend across all 730 cycles

### Sheet 2 — Monthly
- 24 rows — 12 months × 2 sites
- Monthly aggregation of efficiency, energy output and charging cost

### Sheet 3 — Degradation
- 24 rows showing monthly efficiency vs January baseline
- Line chart: degradation curve for both sites over 12 months

### Sheet 4 — Peak Shaving
- 24 rows showing monthly charge cost, discharge revenue and net saving
- Bar chart: monthly net savings per site

### Sheet 5 — C-Rate Analysis
- 6 rows — 3 C-rate bands × 2 sites
- Bar chart: average efficiency per C-rate band per site
- Separates rate-dependent losses from time-based degradation

---

## Key Findings

**Efficiency:**
- BESS_North average efficiency: 91.57% — above 90% target throughout the year
- BESS_South average efficiency: 89.44% — below target from May 2024 onwards

**Degradation:**
- BESS_North lost −1.72% efficiency over 12 months — within normal range
- BESS_South lost −2.69% — degrading 56% faster, maintenance recommended

**C-Rate Analysis:**
- BESS_South runs at avg C-rate of 0.487 vs 0.475 for BESS_North
- BESS_South spends 171 out of 365 cycles in the high C-rate band
  vs only 74 for BESS_North
- Efficiency drops consistently as C-rate increases on both sites
- The RTE gap between sites has two contributors: faster ageing rate
  and higher C-rate due to smaller capacity relative to energy throughput

**Peak Shaving Savings:**
- BESS_North annual net saving: ~€4,000
- BESS_South annual net saving: ~€2,900
- Combined annual saving: €6,818

---

## Project Structure

BESS-Performance-Tracker/
│
├── data/
│ ├── bess_performance.csv
│ ├── monthly_summary.csv
│ ├── degradation_trend.csv
│ ├── peak_shaving_savings.csv
│ └── rte_vs_crate.csv
│
├── database/
│ └── energy_project.db
│
├── python/
│ └── generate_data.py
│
├── sql/
│ ├── 01_create_tables.sql
│ ├── 02_efficiency_per_cycle.sql
│ ├── 03_charging_cost.sql
│ ├── 04_performance_summary.sql
│ ├── 05_site_summary.sql
│ ├── 06_monthly_summary.sql
│ ├── 07_degradation_trend.sql
│ ├── 08_peak_shaving_savings.sql
│ └── 09_rte_vs_crate.sql
│
├── vba/
│ └── BuildDashboard.bas
│
├── dashboard/
│ └── BESS_Dashboard.xlsm
│
└── README.md


---

## How to Run

1. Clone the repository
2. Open `database/energy_project.db` in DB Browser for SQLite
3. Run `python/generate_data.py` to populate the database
4. Run each SQL query in DB Browser and export results as CSV to `data/`
5. Open `dashboard/BESS_Dashboard.xlsm` in Excel
6. Press Alt + F8 → select `BuildAllSheets` → click Run

---

## References

Preger, Y. et al. (2020). Degradation of Commercial Lithium-Ion Cells as a 
Function of Chemistry and Cycling Conditions. Journal of The Electrochemical 
Society, 167(12). Sandia National Laboratories.

---

## Author

**Abhishekkumar Panchal**
M.Eng. Smart Energy Systems — Hochschule Ansbach
[LinkedIn](https://www.linkedin.com/in/abhishekkumar-prakashkumar-panchal) |
[GitHub](https://github.com/Abhishek1268)
