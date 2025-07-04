WITH reg_dates AS ( SELECT user_id, 
MIN(order_date) as reg_date FROM orders 
GROUP BY user_id
ORDER BY user_id ) 
SELECT 
DATE_TRUNC( 'month', reg_date):: DATE AS foodr_month,
COUNT (DISTINCT user_id) AS regs 
FROM reg_dates
GROUP BY foodr_month 
ORDER BY foodr_month ASC 
LIMIT 3

---Active user query 
SELECT DATE_TRUNC ( 'month', order_date) :: DATE AS foodr_month, 
COUNT(DISTINCT user_id) AS Mau 
FROM orders 
GROUP BY foodr_month 
order by foodr_month 
LIMIT 3 

----registations running total 
WITH reg_dates AS 
(SELECT user_id , MIN(order_date) AS reg_date
FROM orders 
GROUP BY user_id 
), 
registrations AS (SELECT 
DATE_TRUNC('month', reg_date) ::DATE AS foodr_month,
COUNT(DISTINCT user_id) AS regs
FROM reg_dates 
GROUP BY foodr_month )
SELECT foodr_month, 
regs, SUM(regs) OVER(order by foodr_month ASC) AS reg_rt 
FROM registrations
ORDER BY foodr_month ASC
LIMIT 3;

--Lagged mau
WITH maus AS ( 
  SELECT 
    DATE_TRUNC('month', order_date) :: DATE AS foodr_month, 
    COUNT(DISTINCT user_id) AS mau 
  FROM orders 
  GROUP BY foodr_month)  
 SELECT 
  foodr_month, 
  mau, 
  COALESCE( 
    LAG(mau) OVER (ORDER BY foodr_month ASC), 
  1) AS last_mau 
FROM maus 
ORDER BY foodr_month ASC 
LIMIT 3;


---Deltas query 
WITH maus AS 
(SELECT DATE_TRUNC('month', order_date)::DATE AS foodr_month, 
COUNT(DISTINCT user_id) AS mau 
FROM orders 
GROUP BY foodr_month ),
l_delta AS (
SELECT foodr_month, mau,
COALESCE ( LAG(mau) OVER (ORDER BY foodr_month ASC),1) AS l_mau
FROM maus
ORDER BY foodr_month 

) 
SELECT foodr_month , 
mau , mau - l_mau AS mau_delta 
FROM l_delta 
ORDER BY foodr_month 
LIMIT 3;

--Growth rate 
WITH maus AS ( 
SELECT DATE_TRUNC('month',order_date)::DATE AS foodr_month, 
COUNT( DISTINCT user_id) AS mau 
FROM orders 
GROUP BY foodr_month
),
l_mau AS (
SELECT foodr_month, 
mau, 
COALESCE( LAG(mau) OVER (ORDER BY foodr_month),1) AS l_maus
FROM maus
ORDER BY foodr_month ASC
) 
SELECT foodr_month, 
mau, 
 ROUND (
 (mau- l_maus)::NUMERIC/ 
  l_maus,2) AS growth 
  FROM l_mau
  ORDER BY foodr_month ASC 
  LIMIT 3

---Retention Rate
WITH user_activity AS ( SELECT 
DATE_TRUNC('month', order_date)::DATE AS foodr_month, 
 user_id 
FROM orders )
SELECT 
previous.foodr_month, 
ROUND (
       COUNT( DISTINCT current.user_id)::NUMERIC/
   GREATEST(COUNT(DISTINCT previous.user_id),1),
   2) AS retention 
FROM user_activity AS previous 
LEFT JOIN user_activity AS current 
ON previous.user_id = current.user_id 
AND previous.foodr_month = (current.foodr_month - INTERVAL '1 month')
GROUP BY previous.foodr_month 
ORDER BY previous.foodr_month ASC
LIMIT 3;

---Average Revenue per user 
WITH KPIs AS 
( SELECT 
SUM (meal_price * order_quantity) AS revenue, 
COUNT(DISTINCT user_id) AS users 
FROM meals 
JOIN orders ON meals.meal_id = orders.meal_id
)
SELECT ROUND( revenue ::NUMERIC/ GREATEST(users,1),2) AS arpu
FROM KPIs

--by month ARPU
WITH KPIs AS (
SELECT DATE_TRUNC('month', order_date)::DATE AS deliver_month, 
SUM(meal_price* order_quantity) AS revenue ,
COUNT(DISTINCT user_id) AS users
FROM meals JOIN orders ON meals.meal_id = orders.meal_id 
GROUP BY deliver_month
)  
SELECT deliver_month , 
ROUND( revenue:: NUMERIC/ GREATEST(users,1),2) AS ARPM
FROM KPIs
ORDER BY deliver_month ASc


---Query 2( Average revenue per user)
WITH KPIs AS (SELECT 
user_id, 
SUM(meal_price* order_quantity) AS revenue
FROM meals JOIN orders ON meals.meal_id = orders.meal_id 
GROUP BY user_id 
)
SELECT ROUND(AVG(revenue)::NUMERIC ,2) AS arpu 
FROM KPIs 

---Orders per user 
WITH KPIs AS 
(SELECT user_id,
 COUNT(DISTINCT order_id) AS orders
 FROM meals JOIN orders ON meals.meal_id = orders.meal_id 
 GROUP BY user_id
 ) 
 SELECT orders,
 COUNT(DISTINCT user_id) AS users
 FROM KPIs 
 GROUP BY orders
 order by orders ASC





