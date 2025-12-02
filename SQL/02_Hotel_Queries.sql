-- A.1 Last booked room per user
SELECT u.user_id, b.room_no
FROM users u
LEFT JOIN (
  SELECT booking_id, user_id, room_no,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
  FROM bookings
) b ON b.user_id = u.user_id AND b.rn = 1;


-- A.2 Total billing amount for bookings in Nov 2021
SELECT b.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON i.item_id = bc.item_id
WHERE b.booking_date BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY b.booking_id;


-- A.3 Bills in Oct 2021 > 1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE bc.bill_date BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- A.4 Most & least ordered item per month (2021)
WITH monthly AS (
  SELECT DATE_FORMAT(bill_date, '%Y-%m-01') AS month,
         item_id,
         SUM(item_quantity) AS qty
  FROM booking_commercials
  WHERE bill_date BETWEEN '2021-01-01' AND '2021-12-31'
  GROUP BY month, item_id
),
most AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY month ORDER BY qty DESC) AS rn
  FROM monthly
),
least AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY month ORDER BY qty ASC) AS rn
  FROM monthly
)
SELECT month, item_id, qty, 'most' AS type
FROM most WHERE rn = 1
UNION ALL
SELECT month, item_id, qty, 'least' AS type
FROM least WHERE rn = 1;



-- A.5 Second highest bill total per month (2021)
WITH totals AS (
  SELECT DATE_FORMAT(bc.bill_date, '%Y-%m-01') AS month,
         b.user_id,
         SUM(bc.item_quantity * i.item_rate) AS total_spent
  FROM booking_commercials bc
  JOIN items i ON i.item_id = bc.item_id
  JOIN bookings b ON b.booking_id = bc.booking_id
  WHERE bc.bill_date BETWEEN '2021-01-01' AND '2021-12-31'
  GROUP BY month, b.user_id
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rnk
  FROM totals
)
SELECT month, user_id, total_spent
FROM ranked
WHERE rnk = 2;
