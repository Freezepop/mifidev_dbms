WITH ClassAvg AS (
    SELECT
        c.class AS car_class,
        AVG(r.position) AS class_avg_position,
        COUNT(DISTINCT c.name) AS car_count
    FROM "Results" r
    JOIN "Cars" c ON r.car = c.name
    GROUP BY c.class
    HAVING COUNT(DISTINCT c.name) > 1
),
CarPerformance AS (
    SELECT
        r.car AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM "Results" r
    JOIN "Cars" c ON r.car = c.name
    GROUP BY r.car, c.class
)
SELECT cp.car_name, cp.car_class, ROUND(cp.average_position, 4) AS average_position,
       cp.race_count, cl.country AS car_country
FROM CarPerformance cp
JOIN ClassAvg ca ON cp.car_class = ca.car_class
JOIN "Classes" cl ON cp.car_class = cl.class
WHERE cp.average_position < ca.class_avg_position
ORDER BY cp.car_class, cp.average_position;