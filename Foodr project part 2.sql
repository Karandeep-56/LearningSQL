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









