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
LIMIT 3;
