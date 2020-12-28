SQL, which stands for Structured Query Language, is a language for interacting with data stored
in something called a relational database. You can think of a relational database as a collection 
of tables. A table is just a set of rows and columns, like a spreadsheet, which represents exactly 
one type of entity. For example, a table might represent employees in a company or purchases made,
but not both.  
  
Each row, or record, of a table contains information about a single entity. For example, 
in a table representing employees, each row represents a single person. Each column, or field, 
of a table contains a single attribute for all rows in the table. 



SELECT people 
FROM table;
#returns the people column from table

SELECT people, roles
FROM table;
#returns the people and roles columns from table

SELECT *
FROM table; 
#returns all the columns from table

SELECT * 
FROM table LIMIT 10;
#returns all columns from the data and returns first 10 rows from table

SELECT DISTINCT country
FROM table;
#returns all unique values for country from table

SELECT COUNT (people)
FROM table;
#returns number of non-missing entities in people column of table

SELECT COUNT (*)
FROM table;
#returns number of rows in table

SELECT COUNT (DISTINCT people)
FROM table;
#returns number of distinct values in people column of table

WHERE keyword allows you to filter using operators below. WEHRE always comes after FROM.

= equal
<> not equal
< less than
> greater than
<= less than or equal to
>= greater than or equal to


SELECT title
FROM table
WHERE release_year > 2000;
#returns all titles in table which were made in the 21st century

SELECT *
FROM films
WHERE release_year = 2016
#returns all values for films released in the year 2016, effectively returns a table

SELECT COUNT(release_year)
FROM films
WHERE release_year < 2000
#returns the number of films released before 2000 in the table

SELECT title, release_year
FROM films
WHERE release_year > 2000
#returns the title and release year of films released after the year 2000

SELECT *
FROM films
WHERE language = 'French';
#return all details for films which are in French

SELECT *
FROM films
WHERE language = 'Spanish'
AND release_year > 2000
AND release_year < 2010;
#returns all details for films in Spanish released between 2000 and 2010

SELECT title, release_year 
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND (gross > 2000000)
#returns the title and release year of films released in the 90s which were in French or Spanish 
#and which took in more than 2M gross.

SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND (language = 'Spanish' OR language = 'French')
#returns title and release year of films in Spanish and French between 1990 and 2000 inclusive 
#whose budget was over 100M

SELECT title, certification
FROM films
WHERE certification IN ('NC-17','R')
#returns title and rating of films which are NC-17 or rated R

BETWEEN is an inclusive function

SELECT COUNT(*)
FROM films
WHERE language IS NULL;
#returns number of films which are missing an entry for language

As you have seen, the WHERE clause can be used to filter text data. However, so far you 
have only seen able to filter by specifying the exact text you are interested in. In the real
world, often you will want to search for a pattern rather than a specific text string.

In SQL, the LIKE operator can be used in a WHERE clause to search for a pattern in a column. 
To accomplish this, you use something called a wildcard as a placeholder for some other values. 
ere are two wildcards you can use with LIKE:

The % wildcard will match zero, one, or many characters in text. The _ wildcard will match a 
single character. 

SELECT name
FROM people
WHERE name LIKE '_r%';
#returns names of people whose name second letter is r

SELECT name
FROM people
WHERE name NOT LIKE 'A%';
#returns names of people whose names do not start with an A

Often, you will want to perform some calculation on the data in a database. SQL provides a few 
functions, called aggregate functions, to help you out with this. For example,

SELECT AVG(budget)
FROM films;
#gives you the average value from the budget column of the films table. Similarly, the MAX function returns the highest budget:

SELECT MAX(budget)
FROM films;
#The SUM function returns the result of adding up the numeric values in a column:

SELECT SUM(budget)
FROM films;
#You can probably guess what the MIN function does! Now its your turn to try out some SQL functions.

SELECT AVG(gross)
FROM films
WHERE title LIKE 'A%';
#returns

SELECT MAX(gross)
FROM films
WHERE release_year BETWEEN 2000 AND 2012;
#returns

In addition to using aggregate functions, you can perform basic arithmetic with symbols 
like +, -, *, and /. So, for example, the first expression below gives a result of 12 whereas the
second gives a result of 1.

SELECT (4 * 3);
SELECT (4 / 3);

SQL assumes that if you divide an integer by an integer, you want to get an integer back. 
So be careful when dividing! If you want more precision when dividing, you can add decimal 
places to your numbers. For example,

SELECT (4.0 / 3.0) AS result;
#Returns the result you would expect: 1.333.

You may have noticed in the first exercise of this chapter that the column name of your 
result was just the name of the function you used. For example,

SELECT MAX(budget)
FROM films;
#gives you a result with one column, named max. But what if you use two functions like this?

SELECT MAX(budget), MAX(duration)
FROM films;
#Well, then youd have two columns named max, which isnt very useful!

To avoid situations like this, SQL allows you to do something called aliasing. Aliasing 
simply means you assign a temporary name to something. To alias, you use the AS keyword, which 
you haveve already seen earlier in this course. For example, in the above example we could use aliases 
to make the result clearer:

SELECT MAX(budget) AS max_budget,
       MAX(duration) AS max_duration
FROM films;
#Aliases are helpful for making results more readable!

SELECT AVG(duration)/60.0 AS avg_duration_hours
from films
#returns the average duration of films under a column with title avg_duration_hours

SELECT 100.0*COUNT(deathdate)/COUNT(*) AS percentage_dead
FROM people
#returns percentage of people who are dead

SELECT birthdate AS birthdate, name AS name
FROM people
ORDER BY birthdate
#returns values for names and birthdates, in order by order of birth

SELECT *
from films
WHERE release_year <> 2015
ORDER BY duration
#returns all details for all films except those released in 2015 and ordered by duration

SELECT title, gross
from films
WHERE title LIKE 'M%'
ORDER BY title
#returns title and gross earnings for movies which begin with the letter M and orders 
#alphabetically

SELECT title, duration
from films
ORDER BY duration DESC
#returns title and duration for every film in order of longest to shortest

SELECT release_year, duration, title
FROM films
ORDER BY release_year, duration
#returns release year, duration, and title of films ordered by the release year and then their 
#duration. Duration is the "tie-breaker".

In SQL, GROUP BY allows you to group a result by one or more columns.

SELECT imdb_score, COUNT(*)
FROM reviews
GROUP BY imdb_score;
#returns the imdb scored and count of films reviewd by imdb in the reviews table

SELECT language, SUM(gross)
FROM films
GROUP BY language
#returns the langiage and total gross amount films in each language made

SELECT release_year, country, MIN(gross)
FROM films
GROUP BY release_year, country
ORDER BY country, release_year
#returns country, release year, and lowest amount grossed per release year per country, ordered 
#by country and release year.


In SQL, aggregate functions cannott be used in WHERE clauses. For example, the following 
query is invalid:


SELECT release_year
FROM films
GROUP BY release_year
WHERE COUNT(title) > 10;

This means that if you want to filter based on the result of an aggregate function, you need 
another way. That is where the HAVING clause comes in. For example,


SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;
#shows only those years in which more than 10 films were released.

SELECT release_year,AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY avg_gross DESC;
#returns the average budget, and average gross earnings for films in each year after 1990 of the 
#average budget is greater than 60M in descending order

Get the country, average budget, and average gross take of countries that have made more than 10 
films. Order the result by country name, and limit the number of results displayed to 5. You should 
alias the averages as avg_budget and avg_gross respectively.

SELECT country, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
from films
GROUP BY country
HAVING COUNT(*) > 10
ORDER BY country
LIMIT 5;