SELECT user_id , 
MIN(order_date) AS reg_date 
FROM orders 
GROUP BY user_id 
ORDER BY user_id 
LIMIT 3;