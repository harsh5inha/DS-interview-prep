CREATE TABLE interactions ('s_id' integer, 'r_id' integer, 'interaction' varchar(255), 'date' DATE);
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'comment', '2019-04-28');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'like', '2019-04-26');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'comment', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'like', '2019-04-08');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 456, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(456, 123, 'like', '2019-04-25');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(456, 123, 'comment', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(456, 123, 'react', '2019-04-02');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, NULL, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 456, 'comment', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 456, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 456, 'comment', '2019-04-01');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 456, 'like', '2019-04-05');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 456, 'like', '2019-04-13');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(456, 789, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(123, 789, 'comment', '2019-04-16');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(456, 789, 'react', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'comment', '2019-04-22');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'comment', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 934, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(934, 856, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(934, 856, 'comment', '2019-04-19');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(934, 856, 'react', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'like', '2019-04-30');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'comment', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'comment', '2019-04-28');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'like', '2019-04-04');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(789, 934, 'like', '2019-04-11');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(934, 789, 'like', '2019-04-14');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(856, 789, 'comment', '2019-04-07');
INSERT INTO interactions (s_id, r_id, interaction, date) VALUES(934, 789, 'react', '2019-04-14');


#Number of interactions between individual pairs
WITH CTE AS
(
SELECT s_id, r_id, COUNT(*) AS num
FROM interactions
GROUP BY s_id, r_id
)
SELECT t1.s_id, t1.r_id, t1.num + t2.num AS num2
FROM CTE AS t1
INNER JOIN CTE AS t2
ON t1.s_id = t2.r_id AND t2.s_id = t1.r_id
WHERE t1.s_id > t1.r_id


#Unique Pairs
WITH CTE AS
(
SELECT s_id, r_id
FROM interactions

UNION

SELECT r_id, s_id
FROM interactions
)
SELECT r_id, s_id
FROM CTE
WHERE r_id < s_id;


#Top ten people by number of friends
SELECT id, COUNT(*)
FROM table
GROUP BY id
ORDER BY COUNT(*) DESC
LIMIT 10


#Display the table and show whether the interaction is in the like/comment bucket or the 'other bucket'
SELECT s_id, r_id,
CASE WHEN interaction = 'like' OR interaction = 'comment' THEN 'like/comment'
ELSE 'other' END AS type
FROM interactions;


#returns number of boys in each grade
SELECT 
		grade_level,
		COUNT(CASE WHEN table.gender = 'boy' THEN 'arbitrary' END) AS number_male
FROM table
GROUP BY grade_level


#returns total goals scored by boys in each grade
SELECT 
		grade_level,
		SUM(CASE WHEN table.gender = 'boy' THEN goals END) AS total_male_goals
FROM table
GROUP BY grade_level


#returns average goals scored by boys in each grade
SELECT 
		grade_level,
		AVG(CASE WHEN table.gender = 'boy' THEN goals END) AS avg_goals_male
FROM table
GROUP BY grade_level


#Percentage of boys in each grade
SELECT 
		grade_level,
		AVG(CASE WHEN table.gender = 'boy' THEN 1 ELSE 0 END) AS perc_male
FROM table
GROUP BY grade_level


#An attendance log for every student in a school district:   			attendance_events : date | student_id | attendance
#A summary table with demographics for each student in the district: 	all_students : student_id | school_id | grade_level | date_of_birth | hometown
#What percentage of Students attend school on their birthday?
WITH CTE AS
(
SELECT ae.student_id, ae.date, ae.attendance AS attendance
FROM attendance_events ae
INNER JOIN all_students all
ON ae.student_id = all.student_id AND ae.date = all.date_of_birth)
)
SELECT AVG(attendance)
FROM CTE


#Which grade level had the largest drop in attendance between yesterday and today?
WITH CTE AS
(
SELECT all.grade_level,
COUNT(CASE WHEN ae.date = '09-11-2019' AND ae.attendance = 1 END) AS yesterday_att,
COUNT(CASE WHEN ae.date = '10-11-2019' AND ae.attendance = 1 END) AS today_att
FROM attendance_events AS ae
INNER JOIN all_students all
ON ae.student_id = all.student_id
GROUP BY all.grade_level
),
CTE2 AS
(
SELECT CTE.grade_level, yesterday_att - today_att AS attendance
FROM CTE
)
SELECT grade_level
FROM CTE2
WHERE attendance = (SELECT MAX(attendance) FROM CTE2)


#This will return the name, price, and category of products which have the maximum price in their category.
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


#returns title and rating of films which are NC-17 or rated R
SELECT title, certification
FROM films
WHERE certification IN ('NC-17','R')


#returns names of people whose name second letter is r
SELECT name
FROM people
WHERE name LIKE '_r%';


#returns names of people whose names do not start with an A
SELECT name
FROM people
WHERE name NOT LIKE 'A%';


#returns the sum of pageviews over entire dataset
SELECT SUM(PageViews) over ()


#returns sum of pageviews over each id at the observation level
SELECT SUM(PageViews) over (PARTITION BY id)


#returns a cumulative sum
SELECT SUM(PageViews) over (PARTITION BY id ORDER BY DateNum)


#returns the sum over the past week If DateNum not an integer then use 'ROW' instead of 'RANGE'
SELECT SUM(PageViews) over (PARTITION BY id ORDER BY DateNum RANGE BETWEEN 6 preeceding AND 0 preeceding)


#returns ranks within partitions (ties can happen)
SELECT
RANK() over (PARTITION BY x, y, z, ORDER BY t (desc)) AS row_number
FROM
WHERE condition


#returns row numbers within partitions
SELECT
ROW_NUMBER() over (PARTITION BY x, y, z, ORDER BY t (desc)) AS row_number
FROM
WHERE condition


#returns the full dataset sorted by date + the row number
SELECT *, ROW_NUMBER() OVER(ORDER BY date) 
FROM interactions;


#Given timestamps of logins, figure out how many people on Facebook were active all seven days of a week on a mobile phone?
WITH CTE AS
(
	SELECT *
	FROM interactions
	WHERE date BETWEEN '2019-04-10' AND '2019-04-16'
),
CTE2 AS
(
SELECT s_id, strftime('%d', date) AS day_of_week
FROM CTE
GROUP BY 1, 2
),
CTE3 AS
(
SELECT s_id, RANK() over (PARTITION BY s_id ORDER BY day_of_week) AS place
FROM CTE2
)
SELECT s_id
FROM CTE3
GROUP BY s_id
HAVING MAX(place) = 7


#How do you determine what product in Facebook was used most by the non-employee users for the last quarter?
WITH CTE AS
(
SELECT product_id
FROM table
WHERE employee = 0
AND date BETWEEN '2019-01-01' AND '2019-03-31'
)
SELECT product_id, COUNT(*)
FROM CTE
GROUP BY product_id


#Query Even Numbered Rows
WITH CTE AS
(
SELECT *, ROW_NUMBER() over() as row_number
FROM interactions
)
SELECT *
FROM CTE
WHERE row_number % 2 = 0


#returns usernames of every user that follows reese whom reese also follows back
SELECT username
FROM users
WHERE id IN
(
SELECT followee_id AS id
FROM followers
WHERE follower_id = (SELECT id FROM users WHERE username = 'reese')

INTERSECT

SELECT follower_id AS id
FROM followers
WHERE followee_id = (SELECT id FROM users WHERE username = 'reese')
)


#returns 2nd degree usernames
SELECT username
FROM users
WHERE id IN
(
SELECT followee_id
FROM followers
WHERE follower_id IN
(
SELECT followee_id
FROM followers
WHERE follower_id = (SELECT id FROM users WHERE username = 'ileana')
)
)


#returns first value in each window
WITH summary AS (
    SELECT p.id, 
           p.customer, 
           p.total, 
           ROW_NUMBER() OVER(PARTITION BY p.customer 
                                 ORDER BY p.total) AS rk
      FROM PURCHASES p)
SELECT s.*
  FROM summary s
 WHERE s.rk = 1


#returns last value in each window
WITH summary AS (
    SELECT p.id, 
           p.customer, 
           p.total, 
           ROW_NUMBER() OVER(PARTITION BY p.customer 
                                 ORDER BY p.total DESC) AS rk
      FROM PURCHASES p)
SELECT s.*
  FROM summary s
 WHERE s.rk = 1


#returns Nth value in each window
WITH summary AS (
    SELECT p.id, 
           p.customer, 
           p.total, 
           ROW_NUMBER() OVER(PARTITION BY p.customer 
                                 ORDER BY p.total) AS rk
      FROM PURCHASES p)
SELECT s.*
  FROM summary s
 WHERE s.rk = n


#once you have a NULL it screws everything because you can't operate on it
#returns the first non-null input from list, so if null, then replaces with '0'
SELECT s_id, COALESCE(r_id, 0) AS not_null
FROM interactions


#returns all unique one-way interactions
SELECT DISTINCT s_id, r_id
FROM interactions




#COURSES table - course_id & course_name | FACULTY table - faculty_id & faculty_name | COURSE_FACULTY - faculty_id & course_id
#how would you return a list of faculty who teach a course given the name of a course?
SELECT faculty_name
FROM FACULTY
WHERE faculty_id IN
(
	SELECT faculty_id
	FROM COURSE_FACULTY
	WHERE course_id = (SELECT course_id FROM COURSES WHERE course_name = 'History')
)


#IMPRESSIONS - ad_id, click (indicator that the ad was clicked) & date
#find click-through-rate of each ad by month.
WITH CTE AS
(
SELECT *, MONTH(date) as month
FROM IMPRESSIONS
)
SELECT ad_id, month, 
AVG(CASE WHEN click = 1 THEN 1 ELSE 0 END) as CTR
GROUP BY ad_id, month


#EMPLOYEES - Emp_ID (Primary key) Emp_Name 
#EMPLOYEE_DEPT - Emp_ID (Foreign key) & Dept_ID (Foreign key)
#DEPTS containing: Dept_ID (Primary key) and Dept_Name
#return the name of each department and a count of the number of employees in each:
SELECT d.Dept_Name, COUNT(*)
FROM DEPTS AS d
INNER JOIN EMPLOYEE_DEPTS AS ed
ON d.Dept_ID = ed.Dept_ID
GROUP BY d.Dept_Name




#Given an event-level table of interactions between pairs of users (note that there aren't duplicates in one day for one pair 
#of users), for each possible number of "people interacted with" find the count for that group in a given day (i.e. 10 people 
#interacted with only one person, 20 with 2, etc.).  













