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