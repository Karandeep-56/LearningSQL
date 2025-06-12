SELECT * FROM presidents AS p1 INNER JOIN prime_ministers AS p2 
ON p1.country = p2.country 
INNER JOIN states AS p3 
ON p1.country = p3.country