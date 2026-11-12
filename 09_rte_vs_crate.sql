-- Query: RTE vs C-rate analysis
-- Description: Shows relationship between C-rate and round-trip efficiency
--              per site to separate degradation effect from rate-dependent losses
-- Reference: Preger et al. (Sandia, J Electrochem Soc 2020)
-- Author: Abhishekkumar Panchal

WITH cycle_analysis AS (
    SELECT s.site_name,
           b.cycle_date,
           b.c_rate,
           ROUND((b.energy_out_kwh / b.energy_in_kwh) * 100, 2) AS efficiency_pct,
           CASE
               WHEN b.c_rate < 0.47 THEN 'Low (< 0.47C)'
               WHEN b.c_rate < 0.49 THEN 'Medium (0.47-0.49C)'
               ELSE 'High (> 0.49C)'
           END AS c_rate_band
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
)
SELECT site_name,
       c_rate_band,
       COUNT(*)                        AS total_cycles,
       ROUND(AVG(c_rate), 4)           AS avg_c_rate,
       ROUND(AVG(efficiency_pct), 2)   AS avg_efficiency_pct,
       ROUND(MIN(efficiency_pct), 2)   AS min_efficiency_pct,
       ROUND(MAX(efficiency_pct), 2)   AS max_efficiency_pct
FROM cycle_analysis
GROUP BY site_name, c_rate_band
ORDER BY site_name, avg_c_rate;