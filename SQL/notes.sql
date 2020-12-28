Fundamentally, you need to remember that SQL is supposed to help you combine and return data from multiple relational databases
which are linked together by some key. Each table is data on some unique level of granularity and you hvae to manipulate it all
to link it all together how you want. Each row of each table is a unique entry (at that level of granularity).

#JOINS
An Inner join matches only for entries with key values in each table.

A left join results in a table in which every row of the left table is included and addtional columns of information are added on
to the table for those data entries which had a matching key value to the right table. For data rows which did not have a matching
value, these values are left blank.

A right join is similar, but relatively useless since the same functionality can be applied using a left join with the tables
listed in reverse order. However the syntax is not reversed. The left table comes first, after `FROM`, and the right table comes
after `RIGHT JOIN`.

A full join is essentially a combination of a a left and right join. It includes every row of both tables. Matching values are
filled in. Values without matches are left blank.

A cross join pairs every row on the left table with every row on the right table. Essentially, if table A has `n` rows, and
table B has `m` rows, then the cross joined table will have `n`x`m` rows.

A semi-join joins tables based on sub-queries being satisfied. An anti-join is similar but where value is NOT IN:

SELECT president, country, continent
FROM presidents
WHERE country NOT IN
(SELECT name
FROM states
WHERE indep_year < 1800);


#SET THEORY
UNION -> this is a stacking of two sets of values on top of one another such that every value is represented once. Data in each
column must be of the same type because this is simply a stacking of data. If multiple columns are stacked, then operators flag a
match only when ALL fields match ALL fields. To ORDER BY etc. you have to use the column names in the first part of the set.

INTERSECT -> Similar stacking, but only returns only those values which appear in both sets.

EXCEPT -> Similar stacking but only returns values which appear in the first set but not the second.

UNION ALL -> Similar stacking but doesnt exclude any values. Values which appear in both sets are duplicated.

SELECT country_code
FROM cities
UNION
SELECT code
FROM currencies
ORDER BY country_code

SELECT 		-> 	which data do you want returned					(AVG(), MIN(), MAX(), SUM(), COUNT(), DISTINCT)
CASE WHEN   ->  Do you want to output funtions of data
FROM 		-> 	which table are you pulling the data from
JOIN 		-> 	which table are you pulling the data from
WHERE 		-> 	how are you filtering
GROUP BY 	->	at what level do you want the data retunred 	#Always comes after the WHERE clause
HAVING 		->	if grouping then how are you filtering			#Always use GROUP BY when using HAVING, otherwise HAVING treats everything as one group
ORDER BY 	-> 	in what order do you want data returned			(DESC) 	#Always comes last
LIMIT 		-> 	how many entries do you want returned

The join, whatever type of join, is part of the definition of the table. Like whatever you put together through the join, is
the overall table that youre pulling from. If you inner join with only 1 entry per ID on the left table, but `n` entries for that 
ID in the right table, youll get `n` entries per matched ID in the joined table. If you left join with only 1 entry per ID on the 
left table, but `n` entries for that ID in the right table, youll still get `n` entries per matched ID in the joined table. The only 
difference is that entries in the left table without a match in the right table, will still be included in the joined table. And any
fields in the query that are coming from the right table will be Null for those entries. For both inner and left joins, if you have 
`n` entries for a particular ID in the left table and `m` entries in the right table, then you will have `n` X `m` entries for each 
matched ID in the joined table.

If youre joining multiple tables, you should think about it like the first join is its own table, then the second join is a join of
the third table onto that joined table etc. But also, in general think about joins as an `n` x `n` moment in terms of number of
entries in the new, joined dataset.

If you join on multiple keys, then basically it looks for matches in both fields, and returns matches as such.

The WHERE clause filters your data. When you include the WHERE clause after the join, then youre filtering the joined table. 
This is not a problem in an inner join. However, when you do a LEFT or RIGHT join, this may not give you your desired output.
If you want to filter tables individually before joining, say if you wanted to join the tables only under certain circumstances,
then it is slightly more complicated. To filter the left table just create a CTE of the table filteres as desired. To filter the
right table, add conditions in the ON clause, in the JOIN statement. In left joins, you should never filter the right table in a 
WHERE clause after the join. You should put any criteria on your right table within the join expression itself. For example: 
`LEFT JOIN table_b AS b ON a.key = b.key AND b.attendance > 500`. Alternatively, you could use a CTE on your right table to get it 
how you want, and then join it to the left table without having to use any filter criteria at all! This whole issue exists because 
filtering in a WHERE clause will remove Null values, which you might not want to do. Inner joins  dont have these issues, but you 
should still be consistent.

To summarize, if, in a left join, you join on a key AND some filter on the outer table, then that filter is basically a WHERE clause 
on the second table. But if you instead write out a WHERE clause after the join, then the WHERE clause will filter on the entire 
joined table. 

If you want to ORDER or GROUP BY aggregate functions like count() or MAX(), you have to either alias those aggregates and group/order
by the alias, or use numbers to order/group by those aggregate functions by their order in the select statement. But that also means 
that in general, you should group/order by the alias name, not the database name. Doesnt apply for the HAVING clause. You can use
an aggregate function with HAVING without issue.

Correlated Subquery: a subquery that depends on the outer query for its values.

SELECT product_name, list_price, category_id
FROM production.products p1
WHERE list_price IN 
    (
        SELECT 		MAX (p2.list_price)
        FROM 		production.products p2
        GROUP BY 	p2.category_id
    )
ORDER BY
    category_id, product_name;
#This will return the name, price, and category of products which have the maximum price in their category.

EXISTS operator: logical operator that checks whether a subquery returns any rows. Returns TRUE as soon as it finds the first
returned row. Basically, the EXISTS subquery is evaluated for each row in the main query table, even if the subquery is unrelated to 
that row. It basically turns the first row of the main query table into the entire table. The same of that table is the same as
whatever its called or the alias. If a row is returned in the subquery, then TRUE is returned, and the main query pocesses its 
filter condition accordingly. The EXISTS operator is in many ways similar to the IN operator. Often times, you can perform the same 
functionality without an EXISTS or IN operator using joins, but EXISTS/IN can sometimes prove more efficient. However, using NOT IN 
or NOT EXISTS typically loses the efficiency gain since you still have to index through all records. Can also use the EXISTS
subquery with DELETE or UPDATE.

SELECT CategoryName
FROM Categories
WHERE EXISTS
	(SELECT *
	FROM Products
	WHERE Products.CategoryID = Categories.CategoryID)
#Returns the Categories which have products associated with them in the products table

SELECT CategoryName
FROM Categories
WHERE CategoryID IN
	(SELECT CategoryID
	FROM Products)
#Returns the same thing as above

You can do `SELECT 1 ...` when you want to check whether any data exist for some particular query. It will return a column of ones. 

#SELF JOIN for hierarchial data
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;
#This returns the full employee name and full manager name of each employee in the sales staff table


#CASE WHEN
CASE WHEN is basically SQLs version of IF ELSE statements. It checks for a certain number of coditions. If a condition is met, it
returns the specified value in that column. If no condition is met, it returns the value in the ELSE clause. If there is no ELSE
clause, then it returns NULL. You can alias the column as you wish. The conditions you check can be multi-faceted. 

In essence though, the CASE WHEN statement is just another field youre selecting and wanting to display from your data. You can only
display data through the statement that is logically possible to be displayed. That is, any data that can be displayed as a normal
field, ought to be able to be displayed through a CASE WHEN statement.

You could theortically filter a table using the entire CASE WHEN statement as the filter. Alternatively you could use a CTE.

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result_DNE AS condition_column
END;

#CASE WHEN statements for aggregating data:

SELECT 
        season, 
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN ID END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND home_goal < away_goal THEN ID END) AS away_wins
FROM match
GROUP BY season

This query returns the season and the number of home/away game wins by Liverpool for each season. The COUNT() function counts every
ID returned by the CASE statement inside of it. When counting information in a CASE statement, you can return anything you like. 
A number, string of text, or any column in a table. SQL is counting the number of rows returned but the case statement. For example,
the below is the same query:


SELECT 
        season, 
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 54321 END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND home_goal < away_goal THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season


Basically when you combine COUNT() with CASE WHEN, you can output the number of occurances of different values for a particular
field. you have to GROUP BY though to use aggregate functions. You can also use CASE WHEN with the SUM() function:

Select
        season,
        SUM(CASE WHEN hometown_id = 8650 THEN home_goal END) AS home_goals,
        SUM(CASE WHEN hometown_id = 8650 THEN away_goal END) AS away_goals,
FROM match
GROUP BY season

This query returns the total number of home/away goals by Liverpool by season. The SUM() function sums every goal count returned
by the CASE statement inside of it. You can also use the AVG() function with CASE:

Select
        season,
        AVG(CASE WHEN hometown_id = 8650 THEN home_goal END) AS home_goals_avg,
        AVG(CASE WHEN hometown_id = 8650 THEN away_goal END) AS away_goals_avg,
FROM match
GROUP BY season

This query gives the average number of goals Liverpool scored in each season for home and away games. You can also use the AVG()
function with CASE WHEN to calculate percentages:

Select
        season,
        AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
            WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
            END) AS pct_homewins,
        AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
            WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
            END) AS pct_awaywins
FROM match
GROUP BY season

This query calculates the percentage of home and away games Liverpool won by season. All ties and games not including Liverpool in
this query are excluded as Nulls.

In R or Python, you have the ability to calculate a SUM of logical values (i.e., TRUE/FALSE) directly. In SQL, you have to convert
these values into 1 and 0 before calculating a sum. This can be done using a CASE statement.

SELECT 
    c.name AS country,
    -- Sum the total records in each season where the home team won
    SUM(CASE WHEN  m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2012_2013,
    SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2013_2014,
    SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;


#Views
Views: A view is essentially a dataset that is some manipulation of another typically larger dataset. You basically query data such
that the output is a more useful collection of data that you actually are going to use for further queries. Like the dataset is the
raw data, and the view is the processed data, in a way.


#Window Functions
Window Functions: functions which perform calculations on a window without having to group your data.

They operate on a set of rows and return a single value for each row. This is different from using
the GROUP BY clause because this way you can actually retain data at the observation level. Essentially, you can apply a function
over particular PARTITIONS of your data, and instead of just receiving one output value for that group of observation, each
observation gets the value tacked on to the end. For example,

SELECT SUM(PageViews) over (PARTITION BY id)

returns the data such that the total page views for each partition category (id) is added to the data set at the observation level.

You dont have to PARTITION BY however. You can just call the OVER() function. This will pass the function over the entire dataset.

SELECT SUM(PageViews) over ()

This returns the sum of all PageViews over the entire dataframe.

The over function specifies the rows for the calculations. If you use ORDER BY in the row specification, say for a sum, then you
actually get a cumulative sum for each row. As in, you would get a different value for each row within the partition category with
the final row having the value that a normal summation window function would provide for all the rows. For example,

SELECT SUM(PageViews) over (PARTITION BY id ORDER BY DateNum)

Say the data set had 20 observations, 10 in each of 2 id categories. Then the above query will return 2 set of 10 observations,
ordered by date, whose summation value for pageviews will be the sum of all the summation values of all the observations before it
plus its own pageview count. Thus, the last observation by date, in each of the two paritions of data will display the total
summation value which a non-ORDER BY window function would return.

You can also use a RANGE clause to manipulate your window functions. For example,

SELECT SUM(PageViews) over (PARTITION BY id ORDER BY DateNum RANGE BETWEEN 6 preeceding AND 0 preeceding)

returns the sum of pageviews for that day and the 6 days before it. This is an intuitive functionality, but DateNum has to be an
integer. If not an interger, you can substitute the word `ROW` for `RANGE` Note, this is not a cumulative sum as defined in the
previous example.

#ROW_NUMBER() & RANK()
SELECT
ROW_NUMBER() over (PARTITION BY x, y, z, ORDER BY t (desc)) AS row_number
RANK()
FROM
WHERE condition

ROW_NUMBER gives you the row number of that observation within the partition, based on whatever youre using to rank them
RANK() gives you the rank, but it assigns ties the same rank, which is different from ROW_NUMBER


 
COUTIF

SELECT
coutif()
FROM
WHERE






#CTEs
 CTE: This stands for Common Table Expression. A CTE is a temporary result set which can be referenced within a SELECT, INSERT,
 UPDATE, or DELETE statement that immediately follows a CTE.

 WITH cte_name (column_name1, column_name2)
 AS 
 (cte_query)
 SELECT ...
 FROM ...
 JOIN cte_name ON ...

 So this will create a temporary table called cte_name defined by the cte_query. Then youll query your data, using the cte you made
 earlier however it is convenient to you, often via a join of some kind. You can create multiple CTEs and then query from all of
 then in a single SELECT statement simply by separating them with commas.







Examples of when to use Self-Joins

UPDATE

DELETE


CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        '2019 Summer Promotion',
        0.15,
        '20190601',
        '20190901'
    ),
    (
        '2019 Fall Promotion',
        0.20,
        '20191001',
        '20191101'
    ),
    (
        '2019 Winter Promotion',
        0.25,
        '20191201',
        '20200101'
    );






         
#So here we are creating a table, and inserting observations into it.            
CREATE TABLE 'registrants' ('id' integer, 'name' varchar(255), 'dorm' varchar(255));
INSERT INTO registrants (id, name, dorm) VALUES(1, 'John', 'Wigglesworth');      
INSERT INTO registrants (id, name, dorm) VALUES(2, 'Rana', 'Holworthy');
INSERT INTO registrants (id, name, dorm) VALUES(3, 'Eric', 'Currier');  
INSERT INTO registrants (id, name, dorm) VALUES(4, 'Noah', 'Weld');  

#Here we are inserting a singular observation, but it will have NA values in places        
INSERT INTO registrants (name) VALUES('Harsh')                                                                              

#Here we are selecting from our created database                                                                              
SELECT * FROM registrants WHERE  dorm = 'Weld';

#Here we are changing particular values in the table using SQL commands                                      
UPDATE registrants SET dorm = 'canaday' WHERE id = 1;

#Here we are deleting particular values in the table using SQL commands
DELETE FROM registrants WHERE id = 1;




Dimension tables - just make sure that the tables are like put together properly and there shouldnt be anything wrong with using them
CURRENT_DATE()
DATE_SUB
DATE_ADD
DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) AND CURRENT_DATE()
timestamp()
count(1)
lower()
COUTIF()
IN
NOT IN
IS NULL
IS NOT NULL
coalesce()
safe_cast()
sum(if (ap.DataSourceOrgCode='TA',Sessions,0)) SessionsLastYr
safe_divide()
CTEs
trim()
unix_date(bi.FirstTransactionDate) as DateNum


case when bi.DeviceClientType like '%APP%' then 'App'
               when bi.DeviceClientType = 'MOBILE' then 'MobileWeb'
               when bi.DeviceClientType in('DESKTOP','TABLET') then 'Desktop/Tablet'
               else 'Other'
          end DeviceType
 

Bookings2 as (

  select  b.Email
         ,b.IsCancelled
         ,first_value(b.DeviceType) over w1 DeviceType
         /* Taking last NPS score of the day for a given booker*/
         ,first_value(b.NPS ignore nulls) over (partition by b.Email, b.Org, b.FirstTransactionDate order by b.FirstTransactionDateTime desc) NPS 
         ,b.NetRevenue
  from Bookings b
  Window w1 as (partition by b.Email, b.Org, b.FirstTransactionDate order by b.FirstTransactionDateTime)
)

 

count(1) over (partition by bd.Email, bd.Org order by bd.DateNum range between 730 preceding and 0 preceding) BookingNum


 


/*Research the below and add it to your SQL doc but also your CS general doc and DS general doc*/
NoSQL vs. SQL?

The difference is how the backend of the database relates the table and how it understands how the table is generated
 
NOSQL
- Primarily built within Hadoop, uses MapReduce. Every column is stored as separate files, and keep track through meta-data how the rows
and columns should map to each other. This allows for better compression of data and potentially faster performace. Rather than indexing, it
has partitions. Partitions are often by date.
- HIVE
- BigQuery
- Vertica

 
SQL: it breaks down a table, rather than an aggregate, but as a row. It says "row number one contains these values for the columns"

- SQL SERVER
- MYSQL
- POSTGRES

 
RedShift
Azure
Spark - ETL workflow?
Star schema
snowflake schema
etc?
 

SQL Server is probably the biggest language, probably because of legacy. More data type places are intot he NoSQL environments. And on the cloud.


----------------------------------------------------------------------------------      













#HELPFUL QUERIES TO REMEMBER

SELECT title, certification
FROM films
WHERE certification IN ('NC-17','R')
#returns title and rating of films which are NC-17 or rated R

SELECT name
FROM people
WHERE name NOT LIKE 'A%';
#returns names of people whose names do not start with an A

SELECT name
FROM people
WHERE name LIKE '_r%';
#returns names of people whose name second letter is r

SELECT 100.0*COUNT(deathdate)/COUNT(*) AS percentage_dead
FROM people
#returns percentage of people who are dead

SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code AND p.year = e.year
#Note that you have to join on multiple things sometimes if joining multiple tables

#You can also add in new columns to your table as follows:
SELECT name, continent, indep_year,
    CASE WHEN indep_year < 1900 THEN 'before 1900'
    WHEN indep_year <= 1930 THEN 'between 1900 and 1930'
    ELSE 'after 1930' END
    AS indep_year_group
FROM states
ORDER BY indep_year_group

SELECT string_agg(title, ', ') as titles, genre, count(*) FROM films GROUP BY genre;
#This returns the genre, number of films in that genre, and a comma-seperated list of titles of that genre

#GROUP BY KEY AFTER JOIN
SELECT  films.id, films.title, films.genre, count(*) as number_of_reviews 
FROM films 
LEFT JOIN reviews 
ON films.id = reviews.film_id 
GROUP BY films.id;
#This returns the film id, film title, film genre, and the number of reviews it recieved. The join is returning multiple rows for
#each key, so by grouping on the key you get the number of reviews

SELECT 
        season, 
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN ID END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND home_goal < away_goal THEN ID END) AS away_wins
FROM match
GROUP BY season
#This query returns the season and the number of home/away game wins by Liverpool for each season. The COUNT() function counts every
#ID returned by the CASE statement inside of it.

SELECT 
        season, 
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 54321 END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND home_goal < away_goal THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season
#When counting information in a CASE statement, you can return anything you like. A number, string of text, or any column in a table.
#SQL is counting the number of rows returned but the case statement. For example, the above is the same query as before.

Select
        season,
        SUM(CASE WHEN hometown_id = 8650 THEN home_goal END) AS home_goals,
        SUM(CASE WHEN hometown_id = 8650 THEN away_goal END) AS away_goals,
FROM match
GROUP BY season
#This query returns the season and the total number of home/away goals by Liverpool for each season. The SUM() function sums every
#goal count returned by the CASE statement inside of it.

SELECT 
    c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
    ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
             WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
             END),2) AS pct_ties_2013_2014,
    ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
             WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
             END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;
#This Query gives us the percentage of games which end as a tie for 2 seasons for every country.

