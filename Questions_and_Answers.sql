/* Q1: What is the soonest date and time of the table reservation? */

SELECT booking_date, booking_time
FROM bookings
ORDER BY booking_date ASC, booking_time ASC
LIMIT 1;

+--------------+--------------+
| booking_date | booking_time |
+--------------+--------------+
| 2024-07-03   | 17:00:00     |
+--------------+--------------+


/* Q2: What is the number of reserved tables on 03.07.2024? */

SELECT COUNT(*) AS count
FROM Bookings
WHERE Booking_date = '2024-07-03';

+-------+
| count |
+-------+
|     4 |
+-------+


/* Q3: Which payment method is more popular and how many times has it been used? */

SELECT payment_method, COUNT(*) AS count
FROM payments
GROUP BY payment_method
ORDER BY count DESC
LIMIT 1;

+----------------+-------+
| payment_method | count |
+----------------+-------+
| GooglePay      |     7 |
+----------------+-------+


/* Q4: What is the farthest date of the table reserved? What time, table, customer name and phone number? */

SELECT Bookings.booking_date, Bookings.booking_time, customers.first_name, customers.last_name, customers.phone_number
FROM Bookings
JOIN Customers ON Bookings.customer_id = Customers.customer_id
ORDER BY booking_date DESC, booking_time DESC
LIMIT 1;

+--------------+--------------+------------+-----------+--------------+
| booking_date | booking_time | first_name | last_name | phone_number |
+--------------+--------------+------------+-----------+--------------+
| 2024-07-28   | 15:30:00     | Svitlana   | Pavlychko | 0730851764   |
+--------------+--------------+------------+-----------+--------------+


/* Q5: Write the query to return a 5 user's name with the largest amount of payment, reservation date and time, and special request if any. */

SELECT  Bookings.booking_date, Bookings.booking_time, Bookings.special_request, Customers.first_name, Customers.last_name, Payments.amount 
FROM Bookings 
JOIN  Customers ON Bookings.customer_id = Customers.customer_id 
JOIN Payments ON Bookings.booking_id = Payments.booking_id
ORDER BY amount DESC
LIMIT 5;

+--------------+--------------+---------------------------------------------------------------------------------+------------+-------------+----------+
| booking_date | booking_time | special_request                                                                 | first_name | last_name   | amount   |
+--------------+--------------+---------------------------------------------------------------------------------+------------+-------------+----------+
| 2024-07-03   | 20:00:00     | we would like to celebrate birthday at your restaurant. i would like free cake) | Ehor       | Rogoviy     | 10000.00 |
| 2024-07-08   | 22:00:00     | romantic vibes with red roses, is it possible?                                  | Alex       | Onyshchenko |  6400.00 |
| 2024-07-03   | 17:00:00     | we would like cold Champagne before we come                                     | Marat      | Fedyshin    |  5000.00 |
| 2024-07-04   | 19:45:10     | I would like to arrange a banquet with you                                      | Ilarion    | Zlochevskiy |  5000.00 |
| 2024-07-08   | 18:00:00     | 1 children                                                                      | Olexandra  | Chepiga     |  2550.00 |
+--------------+--------------+---------------------------------------------------------------------------------+------------+-------------+----------+


/* Q6: Write the query to return the name of the user who didn`t pay for the reservation. */

SELECT Customers.first_name, Customers.last_name, Customers.phone_number, Payments.payment_method
From Customers
JOIN Bookings ON Customers.customer_id = Bookings.customer_id
Join Payments ON Bookings.booking_id = Payments.booking_id
WHERE payment_method = "";
 
+------------+-----------+---------------+----------------+
| first_name | last_name | phone_number  | payment_method |
+------------+-----------+---------------+----------------+
| Ehor       | Rogoviy   | +380935418689 |                |
| Maryna     | Overchuk  | 0447631897    |                |
+------------+-----------+---------------+----------------+

/* Q7: Write the query to return a waiter's name, and phone number who will serve the most expensive order and special request from a customer. */

SELECT Staff.first_name, Staff.last_name, Staff.phone_number, Tables.table_number, Tables.location,Bookings.special_request, Payments.amount
FROM Staff
JOIN Tables ON Staff.staff_id = Tables.staff_id
JOIN Bookings ON Tables.table_id = Bookings.table_id
JOIN Payments ON Bookings.booking_id = Payments.booking_id
WHERE position In ('waiter', 'waiteress')
ORDER BY amount DESC
LIMIT 1;

+------------+------------+---------------+--------------+----------+---------------------------------------------------------------------------------+----------+
| first_name | last_name  | phone_number  | table_number | location | special_request                                                                 | amount   |
+------------+------------+---------------+--------------+----------+---------------------------------------------------------------------------------+----------+
| Yuriy      | Tymoshenko | +380937654555 |            1 | terrace  | we would like to celebrate birthday at your restaurant. i would like free cake) | 10000.00 |
+------------+------------+---------------+--------------+----------+---------------------------------------------------------------------------------+----------+


/* Q8: Write the query to return top-3 most booked tables, their location and the waiter`s name who working there. */

SELECT Bookings.table_id, COUNT(*) AS bookings_count, Tables.location, Staff.first_name, Staff.last_name
From Bookings
JOIN Tables ON Bookings.table_id = Tables.table_id
JOIN Staff ON Tables.staff_id = Staff.staff_id
GROUP BY table_id
ORDER BY bookings_count DESC
LIMIT 3;

+----------+----------------+----------+------------+------------+
| table_id | bookings_count | location | first_name | last_name  |
+----------+----------------+----------+------------+------------+
|       10 |              3 | terrace  | Yuriy      | Tymoshenko |
|        4 |              2 | 2 hall   | Svitlana   | Pavlenko   |
|        8 |              2 | 3 hall   | Mykola     | Fedorov    |
+----------+----------------+----------+------------+------------+

/* Q9: Return first name, last name and an email of a customer who ordered from the 'Main dishes' category, and the date of booking. */

SELECT Customers.first_name, Customers.last_name, Customers.email, Bookings.booking_date
FROM Customers 
JOIN Bookings ON Customers.customer_id = Bookings.customer_id 
JOIN Payments ON Bookings.booking_id = Payments.booking_id
WHERE menu_item_id IN (
    SELECT menu_item_id FROM Menuitems
    WHERE category LIKE 'Main dishes'
)
ORDER BY email;

+------------+-----------+-----------------------------+--------------+
| first_name | last_name | email                       | booking_date |
+------------+-----------+-----------------------------+--------------+
| Anna       | Dymka     | broveuddumoucre65@gamil.com | 2024-07-05   |
| Olexandra  | Chepiga   | ochepiga614@gamil.com       | 2024-07-04   |
| Olexandra  | Chepiga   | ochepiga614@gamil.com       | 2024-07-08   |
+------------+-----------+-----------------------------+--------------+

/* Q10: Return all the meal names that have price more than the average price at the restaurant. Return the Name and Price for each meal. Order by the highest price listed first. */

SELECT name, price
FROM Menuitems
WHERE price > (
    SELECT AVG(price) AS avg_price
    FROM Menuitems
)
ORDER BY price DESC;

/*  +------------+
    | avg_price  |
    +------------+
    | 279.166667 |
    +------------+   */
+------------------------------------------------------------+--------+
| name                                                       | price  |
+------------------------------------------------------------+--------+
| Veal fillet with caramelized vegetables and baked potatoes | 455.00 |
| Risotto with stewed veal cheeks                            | 410.00 |
| Warm Camembert with white mushrooms                        | 405.00 |
| Seabass with Bermonte sauce and brussels sprouts           | 345.00 |
| Carbonara                                                  | 325.00 |
| Tagliolini with pike perch                                 | 305.00 |
+------------------------------------------------------------+--------+
