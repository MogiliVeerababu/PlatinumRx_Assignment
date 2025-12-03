-- B.1 Revenue by sales channel
SELECT sales_channel, SUM(amount) AS revenue
FROM clinic_sales
GROUP BY sales_channel;


-- B.2 Top 10 valuable customers
SELECT uid, SUM(amount) AS total_spend
FROM clinic_sales
GROUP BY uid
ORDER BY total_spend DESC
LIMIT 10;


-- B.3 Month-wise revenue, expenses & profit
WITH r AS (
  SELECT DATE_FORMAT(datetime, '%Y-%m-01') AS month, SUM(amount) AS revenue
  FROM clinic_sales
  GROUP BY month
),
e AS (
  SELECT DATE_FORMAT(datetime, '%Y-%m-01') AS month, SUM(amount) AS expense
  FROM expenses
  GROUP BY month
)
SELECT COALESCE(r.month, e.month) AS month,
       COALESCE(r.revenue, 0) AS revenue,
       COALESCE(e.expense, 0) AS expense,
       COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
       CASE WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0
            THEN 'profitable' ELSE 'not-profitable' END AS status
FROM r
LEFT JOIN e ON r.month = e.month
UNION
SELECT COALESCE(r.month, e.month) AS month,
       COALESCE(r.revenue, 0) AS revenue,
       COALESCE(e.expense, 0) AS expense,
       COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
       CASE WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0
            THEN 'profitable' ELSE 'not-profitable' END AS status
FROM e
LEFT JOIN r ON e.month = r.month
ORDER BY month;


-- B.4 Most profitable clinic per city
WITH profit AS (
  SELECT c.city, c.cid,
         COALESCE(SUM(cs.amount),0) AS revenue,
         COALESCE(SUM(e.amount),0) AS expense,
         COALESCE(SUM(cs.amount),0) - COALESCE(SUM(e.amount),0) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales cs ON c.cid = cs.cid
  LEFT JOIN expenses e ON c.cid = e.cid
  GROUP BY c.city, c.cid
)
SELECT city, cid, profit
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY city ORDER BY profit DESC) rn
  FROM profit
) t
WHERE rn = 1;



-- B.5 Second least profitable clinic per state
WITH profit AS (
  SELECT c.state, c.cid,
         COALESCE(SUM(cs.amount),0) - COALESCE(SUM(e.amount),0) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales cs ON c.cid = cs.cid
  LEFT JOIN expenses e ON c.cid = e.cid
  GROUP BY c.state, c.cid
),
ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY state ORDER BY profit ASC) rn
  FROM profit
)
SELECT state, cid, profit
FROM ranked
WHERE rn = 2;
