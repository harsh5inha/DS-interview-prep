
#CASE WHEN

CASE WHEN statements are used to categorize your data, and potentially to filter your data. They can also be used to aggregate your
data. 

SELECT 
	m.date,	t.team_long_name AS opponent, 
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;

This Query returns a new field called `outcome` which displays `home wins` if the home goals are greater than the away goals and
`home loses` when the away goals are greater than the home goals. If neither condition is true, then it returns `tie`.



-- Select matches where Barcelona was the away team
SELECT  
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.away_goal > m.home_goal THEN 'Barcelona win!'
	     WHEN m.away_goal < m.home_goal THEN 'Barcelona loss :(' 
         ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Join teams_spain to matches_spain
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;

This Query returns a new field called `outcome` which displays `Barcelona loses` if the home goals are greater than the away goals and
`Barcelona wins` when the away goals are greater than the home goals. If neither condition is true, then it returns `tie`. This
query ensures that Barcelona is the away team.



SELECT 
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS  away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

This query mandates that the away team is either Real or Barca, and that the home team is either Real or Barca. It creates new
fields `home` and `away` which lists out the names of the teams if their ID matches.


SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);


This query mandates that the away team is either Real or Barca, and that the home team is either Real or Barca. It creates new
fields `home` and `away` which lists out the names of the teams if their ID matches. It also creates a field called `outcome`
which displays one of 4 messages depending on the balance of hoe vs. away goals and which team is the home team.


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

this query calculates the percentage of home and away games Liverpool won by season. All ties and games not including Liverpool in
this query are excluded as Nulls.


SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(CASE WHEN m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN 12345 END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN 'arbitrary' END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country
#This query returns the name of the country and the total number of matches played in each of 3 seasons for each country.



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

This Query gives us the percentage of games which end as a tie for 2 seasons for every country.













