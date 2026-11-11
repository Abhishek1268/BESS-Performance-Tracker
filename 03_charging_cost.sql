-- Query: Charging cost per cycle using time-of-use tariffs
-- Description: Joins battery cycles with tariff zones on charge start hour
--              to calculate the cost of each charging session
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

WITH charge_cost AS (
    SELECT b.cycle_id,
           s.site_name,
           b.cycle_date,
           b.energy_in_kwh,
           t.zone,
           t.rate_eur_kwh,
           ROUND(b.energy_in_kwh * t.rate_eur_kwh, 2) AS charge_cost_eur
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
    JOIN tariff_zones AS t
      ON CAST(substr(b.charge_start, 1, 2) AS INTEGER) = t.hour
)
SELECT *
FROM charge_cost
ORDER BY cycle_id;