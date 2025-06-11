SELECT prime_ministers.country, prime_ministers.continent, prime_minister, president 
FROM presidents 
INNER JOIN prime_ministers
ON prime_ministers.country = presidents.country