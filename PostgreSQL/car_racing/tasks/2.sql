WITH CarPerformance AS (
    SELECT
        r.car AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM "Results" r
    JOIN "Cars" c ON r.car = c.name
    JOIN "Classes" cl ON c.class = cl.class
    GROUP BY r.car, c.class, cl.country
)
SELECT cp.car_name, cp.car_class, ROUND(cp.average_position, 4) AS average_position, cp.race_count, cp.car_country
FROM CarPerformance cp
WHERE cp.average_position = (SELECT MIN(average_position) FROM CarPerformance)
ORDER BY cp.car_name
LIMIT 1;