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


