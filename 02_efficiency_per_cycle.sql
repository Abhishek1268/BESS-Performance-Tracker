-- Query: Round-trip efficiency per cycle
-- Description: Calculates efficiency as (energy_out / energy_in) * 100
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

SELECT b.cycle_id,
       s.site_name,
       b.cycle_date,
       b.energy_in_kwh,
       b.energy_out_kwh,
       ROUND((b.energy_out_kwh / b.energy_in_kwh) * 100, 2) AS efficiency_pct
FROM battery_cycles AS b
JOIN site_info AS s ON b.site_id = s.site_id
ORDER BY b.cycle_id;