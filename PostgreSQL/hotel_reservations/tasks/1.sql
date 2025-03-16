WITH BookingStats AS (
    SELECT
        b.ID_customer,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        STRING_AGG(DISTINCT h.name, ', ') AS hotels_list,
        AVG(b.check_out_date - b.check_in_date) AS avg_stay
    FROM "Booking" b
    JOIN "Room" r ON b.ID_room = r.ID_room
    JOIN "Hotel" h ON r.ID_hotel = h.ID_hotel
    GROUP BY b.ID_customer
    HAVING COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) > 1
)
SELECT
    c.name AS customer_name,
    c.email,
    c.phone,
    bs.total_bookings,
    bs.hotels_list,
    ROUND(bs.avg_stay, 4) AS avg_stay
FROM BookingStats bs
JOIN "Customer" c ON bs.ID_customer = c.ID_customer
ORDER BY bs.total_bookings DESC;
