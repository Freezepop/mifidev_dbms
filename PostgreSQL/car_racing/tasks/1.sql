WITH CarPerformance AS (
    SELECT
        r.car AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM "Results" r
    JOIN "Cars" c ON r.car = c.name
    GROUP BY r.car, c.class
),
MinAvgPosition AS (
    SELECT
        car_class,
        MIN(average_position) AS min_avg_position
    FROM CarPerformance
    GROUP BY car_class
)
SELECT cp.car_name, cp.car_class, ROUND(cp.average_position, 4) AS average_position, cp.race_count
FROM CarPerformance cp
JOIN MinAvgPosition mp ON cp.car_class = mp.car_class AND cp.average_position = mp.min_avg_position
ORDER BY cp.average_position;