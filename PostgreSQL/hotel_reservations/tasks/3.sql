WITH hotel_category AS (
    SELECT
        r.ID_hotel,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM
        "Room" r
    GROUP BY
        r.ID_hotel
),
customer_preferences AS (
    SELECT
        b.ID_customer,
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels,
        MAX(CASE
            WHEN hc.hotel_type = 'Дорогой' THEN 'Дорогой'
            WHEN hc.hotel_type = 'Средний' THEN 'Средний'
            ELSE 'Дешевый'
        END) AS preferred_hotel_type
    FROM
        "Booking" b
    JOIN
        "Room" r ON b.ID_room = r.ID_room
    JOIN
        hotel_category hc ON r.ID_hotel = hc.ID_hotel
    JOIN
        "Hotel" h ON r.ID_hotel = h.ID_hotel
    GROUP BY
        b.ID_customer
)
SELECT
    c.ID_customer,
    cu.name,
    c.preferred_hotel_type,
    c.visited_hotels
FROM
    customer_preferences c
JOIN
    "Customer" cu ON c.ID_customer = cu.ID_customer
ORDER BY
    CASE
        WHEN c.preferred_hotel_type = 'Дешевый' THEN 1
        WHEN c.preferred_hotel_type = 'Средний' THEN 2
        ELSE 3
    END;