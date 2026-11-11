-- Query: Monthly performance summary per site
-- Description: Aggregates efficiency and cost by month
--              to track performance trends over the year
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

WITH charge_cost AS (
    SELECT b.cycle_id,
           s.site_name,
           strftime('%Y-%m', b.cycle_date) AS month,
           b.energy_in_kwh,
           b.energy_out_kwh,
           ROUND(b.energy_in_kwh * t.rate_eur_kwh, 2) AS charge_cost_eur,
           ROUND((b.energy_out_kwh / b.energy_in_kwh) * 100, 2) AS efficiency_pct
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
    JOIN tariff_zones AS t
      ON CAST(substr(b.charge_start, 1, 2) AS INTEGER) = t.hour
)
SELECT site_name,
       month,
       COUNT(cycle_id)                AS total_cycles,
       ROUND(AVG(efficiency_pct), 2)  AS avg_efficiency_pct,
       ROUND(SUM(energy_out_kwh), 2)  AS total_energy_out_kwh,
       ROUND(SUM(charge_cost_eur), 2) AS total_charge_cost_eur
FROM charge_cost
GROUP BY site_name, month
ORDER BY site_name, month;