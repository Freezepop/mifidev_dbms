WITH booking_summary AS (
    SELECT
        b.ID_customer,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM
        "Booking" b
    JOIN
        "Room" r ON b.ID_room = r.ID_room
    GROUP BY
        b.ID_customer
),
clients_with_multiple_bookings AS (
    SELECT
        ID_customer,
        total_bookings,
        unique_hotels,
        total_spent
    FROM
        booking_summary
    WHERE
        total_bookings > 2 AND unique_hotels > 1
),
clients_with_high_spending AS (
    SELECT
        ID_customer,
        total_bookings,
        total_spent
    FROM
        booking_summary
    WHERE
        total_spent > 500
)
SELECT
    c.ID_customer,
    cu.name,
    c.total_bookings,
    c.total_spent,
    c.unique_hotels
FROM
    clients_with_multiple_bookings c
JOIN
    "Customer" cu ON c.ID_customer = cu.ID_customer
WHERE
    c.ID_customer IN (SELECT ID_customer FROM clients_with_high_spending)
ORDER BY
    c.total_spent ASC;