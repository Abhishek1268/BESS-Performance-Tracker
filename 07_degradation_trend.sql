-- Query: Efficiency degradation trend over time
-- Description: Tracks monthly average efficiency per site
--              to quantify battery degradation across the year
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

WITH monthly_efficiency AS (
    SELECT s.site_name,
           strftime('%Y-%m', b.cycle_date) AS month,
           ROUND(AVG((b.energy_out_kwh / b.energy_in_kwh) * 100), 2) AS avg_efficiency_pct
    FROM battery_cycles AS b
    JOIN site_info AS s ON b.site_id = s.site_id
    GROUP BY s.site_name, month
),
first_month AS (
    SELECT site_name,
           avg_efficiency_pct AS baseline_efficiency
    FROM monthly_efficiency
    WHERE month = '2024-01'
)
SELECT m.site_name,
       m.month,
       m.avg_efficiency_pct,
       ROUND(m.avg_efficiency_pct - f.baseline_efficiency, 2) AS degradation_pct
FROM monthly_efficiency AS m
JOIN first_month AS f ON m.site_name = f.site_name
ORDER BY m.site_name, m.month;