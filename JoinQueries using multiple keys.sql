SELECT p1.country, p1.continent, president, prime_minister 
FROM prime_ministers AS p1 INNER JOIN presidents AS p2 
USING (country)
INNER JOIN prime_minister_terms AS p3 USING (prime_minister)