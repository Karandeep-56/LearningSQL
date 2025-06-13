----Calculating profit by bringing revenue and cost together 

With Revenue AS 
( SELECT meals.meal_id, 
SUM(meal_price * order_quantity) AS revenue 
FROM meals 
JOIN orders
ON meals.meal_id = orders.meal_id 
Group BY meals.meal_id 
),
Costing AS 
(SELECT meals.meal_id, 
SUM ( meal_cost* stocked_quantity) AS cost_ 
FROM meals 
JOIN stock ON meals.meal_id = stock.meal_id 
Group BY meals.meal_id )
SELECT Revenue.meal_id , Revenue, Costing , revenue - cost_ AS profit 
FROM Revenue 
JOIN Costing ON Revenue.meal_id = Costing.meal_id 
ORDER BY profit DESC
LIMIT 3
