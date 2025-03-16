WITH ClassPerformance AS (
    SELECT
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS class_avg_position,
        COUNT(r.race) AS total_races
    FROM "Results" r
    JOIN "Cars" c ON r.car = c.name
    JOIN "Classes" cl ON c.class = cl.class
    GROUP BY c.class, cl.country
),
MinClassPerformance AS (
    SELECT MIN(class_avg_position) AS min_avg_position
    FROM ClassPerformance
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
       cp.race_count, cl.car_country, cl.total_races
FROM CarPerformance cp
JOIN ClassPerformance cl ON cp.car_class = cl.car_class
WHERE cl.class_avg_position = (SELECT min_avg_position FROM MinClassPerformance)
ORDER BY cp.average_position, cp.car_name;
