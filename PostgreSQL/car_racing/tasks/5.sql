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
LowPositionCars AS (
    SELECT
        cp.car_name,
        cp.car_class,
        ROUND(cp.average_position, 4) AS average_position,
        cp.race_count,
        cl.country AS car_country
    FROM CarPerformance cp
    JOIN "Classes" cl ON cp.car_class = cl.class
    WHERE cp.average_position > 3.0
),
ClassRaceStats AS (
    SELECT
        lpc.car_class,
        COUNT(lpc.car_name) AS low_position_count,
        (SELECT COUNT(*) FROM "Results" r
         JOIN "Cars" c ON r.car = c.name
         WHERE c.class = lpc.car_class) AS total_races
    FROM LowPositionCars lpc
    GROUP BY lpc.car_class
)
SELECT
    lpc.car_name,
    lpc.car_class,
    lpc.average_position,
    lpc.race_count,
    lpc.car_country,
    crs.total_races,
    crs.low_position_count
FROM LowPositionCars lpc
JOIN ClassRaceStats crs ON lpc.car_class = crs.car_class
ORDER BY crs.low_position_count DESC, lpc.average_position ASC;