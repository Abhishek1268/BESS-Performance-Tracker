# BESS Performance Tracker

An end-to-end Battery Energy Storage System (BESS) performance tracking 
project built with Python, SQL and Excel VBA — from synthetic data generation 
to a fully automated 4-sheet Excel dashboard.

---

## Project Overview

This project simulates a real-world BESS monitoring and reporting workflow:

1. **Python** generates 730 days of realistic battery cycle data with built-in 
   degradation trends and injects it directly into a SQLite database
2. **SQL** analyses the data across 8 queries — covering efficiency, 
   charging costs, degradation tracking and peak shaving savings
3. **Excel VBA** reads the SQL output automatically and builds a 4-sheet 
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

---

## Python Data Generator

`python/generate_data.py` populates the database with 730 realistic cycles:

- 365 days × 2 sites = 730 cycles
- Charge windows set to off-peak hours (01:00–07:00)
- Discharge windows set to peak hours (08:00–20:00)
- Built-in degradation: BESS_North loses ~1.7% efficiency over the year,
  BESS_South loses ~2.7% (56% faster degradation rate)
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

---

## Key Metrics

| Metric | Formula |
|---|---|
| Round-trip efficiency | (energy_out / energy_in) × 100 |
| Charging cost | energy_in × off-peak tariff rate |
| Discharge revenue | energy_out × peak tariff rate |
| Net peak shaving saving | discharge revenue − charging cost |
| Degradation | monthly avg efficiency − January baseline |
| Status flag | OK if efficiency ≥ 90%, else Below target |

---

## Excel VBA Dashboard

`vba/BuildDashboard.bas` contains 6 Subs that build the full dashboard 
automatically from 4 CSV files exported from SQL:

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

---

## Key Findings

**Efficiency:**
- BESS_North average efficiency: **91.57%** — above 90% target throughout the year
- BESS_South average efficiency: **89.44%** — below target from May onwards

**Degradation:**
- BESS_North lost **−1.72%** efficiency over 12 months — within normal range
- BESS_South lost **−2.69%** — degrading 56% faster, maintenance recommended

**Peak Shaving Savings:**
- BESS_North annual net saving: **~€4,000**
- BESS_South annual net saving: **~€2,900**
- Combined annual saving: **~€6,900**

---

## Project Structure

BESS-Performance-Tracker/
│
├── data/
│ ├── bess_performance.csv # Cycle-level performance export
│ ├── monthly_summary.csv # Monthly aggregation export
│ ├── degradation_trend.csv # Degradation trend export
│ └── peak_shaving_savings.csv # Peak shaving savings export
│
├── database/
│ └── energy_project.db # SQLite database
│
├── python/
│ └── generate_data.py # Data generation script
│
├── sql/
│ ├── 01_create_tables.sql
│ ├── 02_efficiency_per_cycle.sql
│ ├── 03_charging_cost.sql
│ ├── 04_performance_summary.sql
│ ├── 05_site_summary.sql
│ ├── 06_monthly_summary.sql
│ ├── 07_degradation_trend.sql
│ └── 08_peak_shaving_savings.sql
│
├── vba/
│ └── BuildDashboard.bas # VBA macro source code
│
├── dashboard/
│ └── BESS_Dashboard.xlsm # Excel dashboard workbook
│
└── README.md


---

## How to Run

1. Clone the repository
2. Open `database/energy_project.db` in DB Browser for SQLite
3. Run `python/generate_data.py` to populate the database
4. Run each SQL query in DB Browser and export results as CSV to `data/`
5. Open `dashboard/BESS_Dashboard.xlsm` in Excel
6. Press **Alt + F8** → select `BuildAllSheets` → click **Run**

---

## Author

**Abhishekkumar Panchal**  
M.Eng. Smart Energy Systems — Hochschule Ansbach  
[LinkedIn](https://linkedin.com/in/abhishekkumar-panchal-2391a4253) |
[GitHub](https://github.com/Abhishek1268)