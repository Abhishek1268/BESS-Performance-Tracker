-- Query: RTE vs Cycle Depth analysis
-- Description: Shows relationship between cycle depth (throughput fraction)
--              and round-trip efficiency per site.
--              Note: cycle_depth = energy_in / capacity — a throughput fraction,
--              not a true C-rate (which divides power by capacity in kW/kWh).
--              Informed by Preger et al. (Sandia, J Electrochem Soc 2020).
-- Author: Abhishekkumar Panchal

WITH cycle_analysis AS (
    SELECT s.site_name,
           b.cycle_date,
           b.cycle_depth,
           ROUND((b.energy_out_kwh / b.energy_in_kwh) * 100, 2) AS efficiency_pct,
           CASE
               WHEN b.cycle_depth < 0.47 THEN 'Low (< 0.47)'
               WHEN b.cycle_depth < 0.49 THEN 'Medium (0.47-0.49)'
               ELSE 'High (> 0.49)'
           END AS cycle_depth_band
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
)
SELECT site_name,
       cycle_depth_band,
       COUNT(*)                           AS total_cycles,
       ROUND(AVG(cycle_depth), 4)         AS avg_cycle_depth,
       ROUND(AVG(efficiency_pct), 2)      AS avg_efficiency_pct,
       ROUND(MIN(efficiency_pct), 2)      AS min_efficiency_pct,
       ROUND(MAX(efficiency_pct), 2)      AS max_efficiency_pct
FROM cycle_analysis
GROUP BY site_name, cycle_depth_band
ORDER BY site_name, avg_cycle_depth;