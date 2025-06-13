----Calculating Revenue 
SELECT  
  order_id,  
  SUM(meal_price * order_quantity) AS revenue  
FROM meals  
JOIN orders ON meals.meal_id = orders.meal_id  
GROUP BY order_id;


-----Calculating cost 
SELECT  
  meals.meal_id,   
  SUM(meal_cost * stocked_quantity) AS cost   
FROM meals  
JOIN stock ON meals.meal_id = stock.meal_id  
GROUP BY meals.meal_id  
ORDER BY meals.cost DESC  
LIMIT 3;

---- Using common table expression (CTE)
WITH costs_and_quantities AS (  
 SELECT  
   meals.meal_id,  
   SUM(stocked_quantity) AS quantity,  
   SUM(meal_cost * stocked_quantity) AS cost  
 FROM meals  
 JOIN stock ON meals.meal_id = stock.meal_id  
 GROUP BY meals.meal_id 
)   
SELECT   
 meal_id,  
 quantity,  
 cost  
FROM costs_and_quantities  
ORDER BY cost DESC  
LIMIT 3; 





----Calculating profit by bringing revenue and cost together 

With Revenue AS 
( SELECT meals.meal_id, 
SUM(meal_price * order_quantity) AS revenue 
FROM meals 
JOIN orders
ON meals.meal_id = orders.meal_id 
Group BY meals.meal_id 
),
Cost AS 
(SELECT meals.meal_id, 
SUM ( meal_cost* stocked_quantity) AS cost_ 
FROM meals 
JOIN stock ON meals.meal_id = stock.meal_id 
Group BY meals.meal_id )
SELECT Revenue.meal_id , Revenue, Cost , revenue - cost_ AS profit 
FROM Revenue 
JOIN Cost ON Revenue.meal_id = Cost.meal_id 
ORDER BY profit DESC
LIMIT 3
