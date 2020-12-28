
SELECT title, imdb_score 
FROM films 
INNER JOIN reviews
ON films.id = reviews.film_id
WHERE title = 'To Kill a Mockingbird';
#inner join is a join only for those records which have a key match in each table

SELECT cities.name AS city, countries.name AS country, countries.region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code
#returns cities, countries, and region of the cities whose country code was found in the country table

SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code AND p.year = e.year
#returns code, name, region, year, fertility rate, and unemployment rate from the three inner joined tables. 

Note that you only have to specify which table to get each column if the column 
name is present in multiple tables.

You can also add in new columns to your table as follows:

SELECT name, continent, indep_year
CASE WHEN indep_year < 1900 THEN 'before 1900'
WHEN indep_year <= 1930 THEN 'between 1900 and 1930'
ELSE 'after 1930' END
AS indep_year_group
FROM states
ORDER BY indep_year_group


An Inner join matches only for entries with key values in each table.


A left join results in a table in which every row of the left table is included
and addtional columns of information are added on to the table for those data
entries which had a matching key value to the right table. For data rows 
which did not have a matching value, these values are left blank.


A right join is similar, but relatively useless since the same functionality
can be applied using a left join with the tables listed in reverse order.


A full join is essentially a union of a a left and right join. It includes every
row of each table with their corresponding values. For data entries with matching
key values, additional columns of information are filled in. For rows without
matches, these values are left blank.


A cross join pairs every value on the left with every value on the right.
Essentially every possible combination is accounted for.


UNION -> this is a stacking of two sets of values on top of one another
such that every value is represented once. Data in each column must be of the same type
because this is simply a stacking of data. Matching is done such that 
each category must be matched if multiple categories are specified.

SELECT country_code
FROM cities
UNION
SELECT code
FROM currencies
ORDER BY country_code

INTERSECT -> this looks at two sets of values, and returns only those values which appear in both sets.

SELECT name
FROM countries
INTERSECT
SELECT name
FROM cities

EXCEPT -> this looks at two sets of values and returns only those which appear in the first set but not the second.

UNION ALL -> this looks at two sets of values and combines them. Values which appear in both sets are duplicated.

SELECT code, year
FROM economies
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;

A semi-join joins tables based on sub-queries being satisfied:

SELECT president, country, continent
FROM presidents
WHERE country IN
(SELECT name
FROM states
WHERE indep_year < 1800);

An anti-join is similar:

SELECT president, country, continent
FROM presidents
WHERE continent LIKE '%America'
AND country NOT IN
(SELECT name
FROM states
WHERE indep_year < 1800);


Sub-Queries

SELECT name, fert_rate
FROM states
WHERE continent = 'Asia'
AND fert_rate <
(SELECT AVG(fert_rate)
FROM states);
#Returns the name and fertility rates of Asian countries which are below the average fertility rate

#Final Challenge
-- Select fields
SELECT name, country_code, city_proper_pop, metroarea_pop,
	  -- Calculate city_perc
      city_proper_pop / metroarea_pop * 100 AS city_perc
  -- From appropriate table    
  FROM cities
  -- Where
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;