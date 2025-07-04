SELECT order_id, SUM( meal_price * order_quantity) AS revenue 
FROM meals 
JOIN orders ON meals.meal_id = orders.meal_id 
GROUP BY order_id 

-----COST 
SELECT meals.meal_id,
SUM( meal_price * stocked_quantity) AS cost 
FROM meals 
JOIN stock ON meals.meal_id = stock.meal_id 
GROUP BY meals.meal_id
ORDER BY cost DESC 
LIMIT 3


----CTE 
WITH cost_and_quantities AS 
( SELECT 
meals.meal_id,
SUM(stocked_quantity) AS quantity,
SUM(meal_cost * stocked_quantity) As cost 
FROM meals 
JOIN stock ON meals.meal_id = stock.meal_id 
GROUP BY meals.meal_id
)
SELECT meal_id,
quantity , 
cost
FROM cost_and_quantities 
order BY cost DESC
LIMIT 3 

----profit 
WITH Revenue AS ( SELECT meals.meal_id, 
SUM ( meal_price * order_quantity) AS revenue 
FROM meals JOIN orders ON meals.meal_id = orders.meal_id 
GROUP BY meals.meal_id 
),
Cost AS ( 
SELECT meals.meal_id, 
SUM( meal_cost * stocked_quantity) AS cost
FROM meals JOIN stock 
ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
)

SELECT Revenue.meal_id, revenue, cost , revenue-cost AS profit 
FROM Revenue JOIN Cost 
ON Revenue.meal_id = Cost.meal_id 
ORDER BY profit DESC 
LIMIT 5

----Registration query 
SELECT user_id , MIN (order_date) AS reg_date 
FROM orders 
GROUP BY user_id 
ORDER BY user_id 
LIMIT 3


----registrations query second using CTE 
WITH regs AS 
(SELECT user_id, MIN(order_date) AS reg_date
FROM orders 
GROUP BY user_id
)
SELECT DATE_TRUNC( 'month', reg_date):: DATE AS foodr_month, 
Count(DISTINCT user_id) AS reg
FROM regs 
GROUP BY foodr_month 
ORDER BY foodr_month 
LIMIT 5

----
WITH reg_dates AS 
(SELECT user_id, min(order_date) AS reg_date 
FROM orders 
GROUP by user_id ),
registrations AS (
SELECT 
DATE_TRUNC( 'month', reg_date) :: DATE AS foodr_month,
COUNT(DISTINCT user_id) AS regs 
FROM reg_dates
GROUP BY foodr_month) 
SELECT foodr_month , regs , 
SUM(regs) OVER (order bY foodr_month ASC)
FROM registrations 
LIMIT 3

















