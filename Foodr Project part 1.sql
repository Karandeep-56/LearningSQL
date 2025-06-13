SELECT order_id, SUM(meal_cost * order_quantity) AS Revenue 
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY order_id 