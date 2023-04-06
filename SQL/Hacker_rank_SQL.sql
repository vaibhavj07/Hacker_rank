-- BASIC SELECT

-- Revising the Select Query I
SELECT * FROM CITY 
WHERE POPULATION > 100000 AND COUNTRYCODE = 'USA'

-- Revising the Select Query II
SELECT NAME FROM CITY
WHERE COUNTRYCODE = 'USA' AND POPULATION > 120000

--- Select All
SELECT * FROM CITY

-----Select By Id
select * from city 
where id = 1661

-----Japanese Cities' Attributes
Select * from City
where Countrycode = 'JPN'

-------Japanese Cities' Names
Select Name from city 
where countrycode = 'JPN'

-----The Pads
select CONCAT(Name,"(",LEFT(Occupation,1),")") from Occupations order by name;
select CONCAT("There are total ", Count(Occupation), " ", LOWER(occupation), "s.") from Occupations Group by Occupation order by  Count(Occupation);

--- Occupations
Select 
    MAX(IF(OCCUPATION = "DOCTOR",NAME,NULL)) AS DOCTOR , 
    Min(IF(OCCUPATION = "PROFESSOR",NAME,NULL)) AS PROFESSOR , 
    MAX(IF(OCCUPATION = "SINGER",NAME,NULL)) AS SINGER ,
    Min(IF(OCCUPATION = "ACTOR",NAME,NULL)) AS ACTOR 
FROM
(select name,occupation,Row_number() Over (PARTITION BY occupation ORDER BY name) as row_num FROM occupations) as ord group by row_num


---Binary Tree Search
select N,case when P is null then "Root" when N in (select P from BST) then "Inner" else "Leaf" End
from BST
order by N

-----------------------------------------------------
--Weather Station 5
(SELECT CITY, LENGTH(CITY) as len from Station
order by len, CITY
limit 1)
UNION
(SELECT CITY, LENGTH(CITY) as len from Station
order by len desc, CITY
limit 1)

----------------------------------------------------
---New Companies
SELECT C.COMPANY_CODE, C.FOUNDER, COUNT(DISTINCT LM.LEAD_MANAGER_CODE), COUNT(DISTINCT SM.SENIOR_MANAGER_CODE), COUNT(DISTINCT M.MANAGER_CODE),COUNT(DISTINCT E.EMPLOYEE_CODE) FROM COMPANY C
INNER JOIN LEAD_MANAGER LM ON
C.COMPANY_CODE = LM.COMPANY_CODE
INNER JOIN SENIOR_MANAGER SM ON
LM.LEAD_MANAGER_CODE = SM.LEAD_MANAGER_CODE 
INNER JOIN MANAGER M ON
SM.SENIOR_MANAGER_CODE = M.SENIOR_MANAGER_CODE
INNER JOIN EMPLOYEE E ON 
M.MANAGER_CODE = E.MANAGER_CODE
GROUP BY C.COMPANY_CODE, C.FOUNDER
ORDER BY C.COMPANY_CODE asc

------------------------------------------------------
-- FINDING MEDIAN IN SQL - WEATHER STATION 20
SET @row_index := -1;
SELECT ROUND(avg(SUBQ.LAT_N),4) FROM(
SELECT @row_index:=@row_index + 1 AS row_index, LAT_N from STATION
order by LAT_N) AS SUBQ
WHERE SUBQ.row_index IN (FLOOR(@row_index / 2) , CEIL(@row_index / 2));

------------------ 
--Calculating Manhatan distance in SQL - Weather observation 18
SELECT ROUND((ABS(t.a-t.c)+ABS(t.b-t.d)),4)FROM
(SELECT MIN(LAT_N) AS A, MIN(LONG_W) AS B, MAX(LAT_N) AS C, MAX(LONG_W) AS D FROM STATION) AS T

------------ Calcualting Eucliedian Distance in SQL 
--Weather Station 19 
SELECT ROUND(SQRT(POW(t.c-t.a,2)+POW(t.d-t.b,2)),4)FROM
(SELECT MIN(LAT_N) AS A, MIN(LONG_W) AS B, MAX(LAT_N) AS C, MAX(LONG_W) AS D FROM STATION) AS T

------------- The Report--------------------
select if(g.grade < 8, NULL, s.name), g.grade, s.marks from students s
join grades g where s.marks between g.min_mark and g.max_mark
order by grade desc, s.name, s.marks

-------------------------------------Top Competitors-----------------------
select s.hacker_id, h.name from submissions s
join challenges c on 
s.challenge_id = c.challenge_id
join difficulty d on
c.difficulty_level = d.difficulty_level
join hackers h on
s.hacker_id = h.hacker_id
where s.score = d.score
group by s.hacker_id, h.name
having count(s.hacker_id) > 1
order by count(s.hacker_id) desc, s.hacker_id asc

-------------------------------- Olliander's Inventory--------------------------------
select w.id,wp.age, w.coins_needed, w.power from wands w
join wands_property wp on 
w.code = wp.code
where wp.is_evil = 0 and w.coins_needed =(SELECT MIN(coins_needed) FROM wands a JOIN wands_property b ON a.code = b.code WHERE a.power = w.power AND b.age = wp.age)
order by w.power desc, wp.age desc

--------------------------------------------------------Challenges------------------------------
/*
Enter your query here.
*/
with tnc as (
select h.hacker_id, h.name, count(c.challenge_id) as num_challenges from hackers h
join challenges c on 
h.hacker_id = c.hacker_id
group by h.hacker_id, h.name
), tcc as (
select num_challenges, count(num_challenges) as count_challenges from tnc group by num_challenges)

select tnc.hacker_id, tnc.name, tnc.num_challenges from tnc 
join tcc on tnc.num_challenges = tcc.num_challenges
where tcc.count_challenges < 2
or 
tnc.num_challenges = (select max(num_challenges) from tnc)
order by tnc.num_challenges desc, hacker_id

----------------------------------------- Contest Leaderboard--------------------------------------
SELECT h.hacker_id, h.name, SUM(sub.score)
FROM
    (SELECT hacker_id, challenge_id, MAX(score) score
    FROM submissions
    GROUP BY hacker_id, challenge_id) sub
JOIN hackers h
ON sub.hacker_id = h.hacker_id
GROUP BY h.hacker_id, h.name
HAVING SUM(sub.score) != 0
ORDER BY SUM(sub.score) DESC, h.hacker_id
---------------------------SQL Project plannins
WITH PROJECT_START_DATE AS (
SELECT 
    START_DATE,
    RANK() OVER (ORDER BY START_DATE) AS RANK_START
FROM PROJECTS 
WHERE START_DATE NOT IN (SELECT END_DATE FROM PROJECTS)
),
PROJECT_END_DATE AS(
SELECT 
    END_DATE,
    RANK() OVER (ORDER BY END_DATE) AS RANK_END
FROM PROJECTS 
WHERE END_DATE NOT IN (SELECT START_DATE FROM PROJECTS))

SELECT start_date, end_date FROM PROJECT_START_DATE, PROJECT_END_DATE
where rank_start = rank_end
order by end_date - start_date, start_date
------------------Placements-----------------------
/*
Enter your query here.
*/
select s.name from students s
join friends f on
s.id = f.id
join packages p on 
p.id = s.id
join packages p1 on
f.friend_id = p1.id
where p1.salary > p.salary
order by p1.salary
--------------------------------- symmetric pairs------------
/*
Enter your query here.
*/

select f1.x as x1 ,f1.y as y1 from functions f1
join functions f2
on f1.x = f2.y and f2.x = f1.y group by f1.x,f1.y
having count(f1.x) > 1 or f1.x<f1.y
order by f1.x asc

-----------weather station 1---------------------------------------------
/*
Enter your query here.
*/
SELECT CITY, STATE FROM STATION
--------------weather station 3-----------------------------
/*
Enter your query here.
*/
select distinct city from station 
where mod(id,2) = 0
-------------weather station 4
/*
Enter your query here.
*/
select count(*) - count(distinct city) from station
------------------weather station 6------------------
/*
Enter your query here.
*/
select city from station
where left(city,1) in ('a', 'e', 'i', 'o','u')
----------weather station 7-------------------------
/*
Enter your query here.
*/
select distinct city from station
where right(city,1) in ('a', 'e', 'i', 'o','u')
-----------weather station 8 ------------------------
/*
Enter your query here.
*/
select distinct city from station
where right(city,1) in ('a', 'e', 'i', 'o','u') and left(city,1) in ('a', 'e', 'i', 'o','u')
----------weather station 9------------------------------------
/*
Enter your query here.
*/
select distinct city from station
where left(city,1) not in ('a', 'e', 'i', 'o','u')
---------------weather station 10--------------------------------
/*
Enter your query here.
*/
select distinct city from station
where right(city,1) not in ('a', 'e', 'i', 'o','u')
-----------weather  station 11 ----------------------------------
/*
Enter your query here.
*/
select distinct city from station
where right(city,1) not in ('a', 'e', 'i', 'o','u') or left(city,1)  not in ('a', 'e', 'i', 'o','u')
-----------------weather station 12------------------------------
/*
Enter your query here.
*/
select distinct city from station
where right(city,1) not in ('a', 'e', 'i', 'o','u') and left(city,1)  not in ('a', 'e', 'i', 'o','u')
------------------------Higher than 75 marks------------------------
select name from students where marks > 75 order by right (name,3), id;
-------------------Employee Names--------------------
/*
Enter your query here.
*/
select name from Employee 
order by name asc
---------------------Type of Triangle-----------------------------------
/*
Enter your query here.
*/
Select 
    CASE 
        WHEN A+B<=C OR A+C<=B OR B+C<=A THEN "Not A Triangle" 
        WHEN A=B AND A=C AND B=C THEN "Equilateral"
        WHEN A<>B AND B<>C AND C<>A THEN "Scalene"
        ELSE "Isosceles"
    END as checking
FROM TRIANGLES        
---------------------- Population Difference-------------------------
select max(population) - min(population) as difference from city
---------------------- The blunder----------------------------------
select CEIL(avg(salary) - avg(replace(salary,'0',''))) from employees
----------------------Top Earners-----------------------------------
/*
Enter your query here.
*/
select salary*months, COUNT(*) from employee
group by salary*months
order by salary*months desc limit 1
-------------------Weather observation station 2-------------------------
Enter your query here.
*/
select round(sum(lat_n),2), round(sum(long_w),2) from station
---------------

