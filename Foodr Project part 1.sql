---Revenue by order_id 
SELECT
	ORDER_ID,
	SUM(MEAL_COST * ORDER_QUANTITY) AS REVENUE
FROM
	MEALS
	JOIN ORDERS ON MEALS.MEAL_ID = ORDERS.MEAL_ID
GROUP BY
	ORDER_ID

---- Calculating cost 
SELECT meals.meal_id, SUM(meal_cost * stocked_quantity ) AS Total_cost 
From meals 
JOIN stock ON meals.meal_id = stock.meal_id  
GROUP BY meals.meal_id
ORDER BY Total_cost DESC 
LIMIT 3

-----
WITH cost_and_quantities AS 
( SELECT meals.meal_id, SUM(stocked_quantity) AS Quantity, 
SUM(meal_cost * stocked_quantity) AS total_cost 
FROM meals 
JOIN stock ON meals.meal_id = stock.meal_id 
GROUP BY meals.meal_id )

SELECT meal_id, Quantity, total_cost 
FROM cost_and_quantities 
ORDER BY total_cost DESC
LIMIT 3
