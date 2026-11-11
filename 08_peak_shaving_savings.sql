-- Query: Peak shaving savings per month
-- Description: Calculates revenue from discharging during peak hours
--              compared to cost of charging during off-peak hours
--              Net saving = discharge revenue - charge cost
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

WITH charge_cost AS (
    SELECT b.cycle_id,
           s.site_name,
           strftime('%Y-%m', b.cycle_date) AS month,
           b.energy_in_kwh,
           b.energy_out_kwh,
           ROUND(b.energy_in_kwh * tc.rate_eur_kwh, 2) AS charge_cost_eur,
           ROUND(b.energy_out_kwh * td.rate_eur_kwh, 2) AS discharge_revenue_eur
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
    JOIN tariff_zones AS tc
      ON CAST(substr(b.charge_start, 1, 2) AS INTEGER) = tc.hour
    JOIN tariff_zones AS td
      ON CAST(substr(b.discharge_start, 1, 2) AS INTEGER) = td.hour
)
SELECT site_name,
       month,
       ROUND(SUM(charge_cost_eur), 2)       AS total_charge_cost_eur,
       ROUND(SUM(discharge_revenue_eur), 2) AS total_discharge_revenue_eur,
       ROUND(SUM(discharge_revenue_eur)
           - SUM(charge_cost_eur), 2)        AS net_saving_eur
FROM charge_cost
GROUP BY site_name, month
ORDER BY site_name, month;