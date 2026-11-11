-- Query: Full performance summary per cycle
-- Description: Combines efficiency, charging cost and status flag
--              using a two-step CTE chain
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

WITH charge_cost AS (
    SELECT b.cycle_id,
           s.site_name,
           b.cycle_date,
           b.energy_in_kwh,
           b.energy_out_kwh,
           t.zone AS charge_zone,
           t.rate_eur_kwh,
           ROUND(b.energy_in_kwh * t.rate_eur_kwh, 2) AS charge_cost_eur
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
    JOIN tariff_zones AS t
      ON CAST(substr(b.charge_start, 1, 2) AS INTEGER) = t.hour
),
performance AS (
    SELECT cycle_id,
           site_name,
           cycle_date,
           energy_in_kwh,
           energy_out_kwh,
           charge_zone,
           charge_cost_eur,
           ROUND((energy_out_kwh / energy_in_kwh) * 100, 2) AS efficiency_pct
    FROM charge_cost
)
SELECT cycle_id,
       site_name,
       cycle_date,
       energy_in_kwh,
       energy_out_kwh,
       efficiency_pct,
       charge_zone,
       charge_cost_eur,
       CASE WHEN efficiency_pct >= 90 THEN 'OK'
            ELSE 'Below target'
       END AS status
FROM performance
ORDER BY cycle_id;