# BESS Performance Tracker

A end-to-end data project tracking Battery Energy Storage System (BESS) 
performance using SQL for data analysis and Excel VBA for dashboard reporting.

---

## Project Overview

This project simulates a real-world BESS monitoring workflow:

- A **SQLite database** stores battery cycle data, site information and 
  time-of-use tariff zones
- **SQL queries** analyse round-trip efficiency, charging costs and 
  performance flags per cycle and per site
- An **Excel VBA dashboard** automatically reads the analysis output, 
  formats a report table, highlights underperforming cycles and generates 
  an efficiency trend chart

---

## Tools Used

| Tool | Purpose |
|---|---|
| SQLite / DB Browser | Database storage and SQL querying |
| Excel VBA | Dashboard automation and chart generation |
| Python (planned) | Extended data simulation and preprocessing |

---

## Database Schema

### `site_info`
Stores metadata for each BESS site.

| Column | Type | Description |
|---|---|---|
| site_id | INTEGER | Primary key |
| site_name | TEXT | Site identifier |
| location | TEXT | Physical location |
| capacity_kwh | REAL | Total battery capacity |
| max_power_kw | REAL | Maximum charge/discharge power |

### `tariff_zones`
Maps each hour of the day to a tariff zone and rate.

| Column | Type | Description |
|---|---|---|
| hour | INTEGER | Hour of day (0–23) |
| zone | TEXT | off-peak / shoulder / peak |
| rate_eur_kwh | REAL | Electricity rate in EUR/kWh |

### `battery_cycles`
Records each charge/discharge cycle per site.

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

## SQL Queries

| File | Description |
|---|---|
| `01_create_tables.sql` | Creates all three database tables |
| `02_efficiency_per_cycle.sql` | Round-trip efficiency per cycle |
| `03_charging_cost.sql` | Charging cost using time-of-use tariffs |
| `04_performance_summary.sql` | Full performance summary with status flag |
| `05_site_summary.sql` | Aggregated KPIs per site |

---

## Key Metrics

| Metric | Formula |
|---|---|
| Round-trip efficiency | (energy_out / energy_in) × 100 |
| Charging cost | energy_in × tariff_rate |
| Status flag | OK if efficiency ≥ 90%, else Below target |

---

## Excel VBA Dashboard

The `BuildDashboard` macro in `vba/BuildDashboard.bas`:

1. Reads `bess_performance.csv` automatically
2. Writes a formatted table with a blue header row
3. Highlights underperforming cycles in red
4. Generates an efficiency trend line chart
5. Autofits all columns for clean presentation

---

## Project Structure

BESS-Performance-Tracker/
│
├── data/
│ └── bess_performance.csv # SQL query export
│
├── database/
│ └── energy_project.db # SQLite database
│
├── sql/
│ ├── 01_create_tables.sql
│ ├── 02_efficiency_per_cycle.sql
│ ├── 03_charging_cost.sql
│ ├── 04_performance_summary.sql
│ └── 05_site_summary.sql
│
├── vba/
│ └── BuildDashboard.bas # VBA macro source code
│
├── dashboard/
│ └── BESS_Dashboard.xlsm # Excel dashboard file
│
└── README.md


---

## Results

**BESS_North** — 5 cycles, avg efficiency 91.57%, total charge cost €85.68  
**BESS_South** — 5 cycles, avg efficiency 89.44%, total charge cost €65.52

BESS_South recorded 2 cycles below the 90% efficiency target (cycles 7 and 8),
indicating potential degradation or suboptimal operating conditions.

---

## Author

**Abhishekkumar Panchal**  
M.Eng. Smart Energy Systems — Hochschule Ansbach  
[LinkedIn](https://linkedin.com/in/abhishekkumar-panchal-2391a4253) | 
[GitHub](https://github.com/Abhishek1268)