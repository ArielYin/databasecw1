-- This file is for your solutions to the census question.
-- Lines starting with -- ! are recognised by a script that we will
-- use to automatically test your queries, so you must not change
-- these lines or create any new lines starting with this marker.
--
-- You may break your queries over several lines, include empty
-- lines and SQL comments wherever you wish.
--
-- Remember that the answer to each question goes after the -- !
-- marker for it and that the answer to each question must be
-- a single SQL query.
--
-- Upload this file to SAFE as part of your coursework.

-- !census

-- !question0

-- Sample solution to question 0.
SELECT data FROM Statistic WHERE wardId = 'E05001982' AND occId = 2 AND gender = 0;

-- !question1

SELECT data FROM Statistic WHERE wardId = 'E05001975'
AND occId = 7 AND gender = 1;

-- !question2

SELECT SUM(data) FROM Statistic WHERE wardId = 'E05000697' AND occId = 5;

-- !question3

SELECT SUM(data) AS num_people, Occupation.name AS occ_class 
FROM Statistic JOIN Occupation ON Statistic.occId = Occupation.id 
WHERE wardId = 'E05008884' 
GROUP BY Occupation.name ;

-- !question4

SELECT SUM(data) AS working_population, Ward.code, Ward.name, County.name AS Unit_name 
FROM Statistic JOIN Ward ON Ward.code = Statistic.wardId 
               JOIN County ON Ward.parent = County.code 
               GROUP BY Ward.code ORDER BY SUM(data) ASC LIMIT 1;

-- !question5

SELECT COUNT(*)
FROM (SELECT (WardId) 
FROM (SELECT WardId, SUM(data) AS b 
FROM Statistic GROUP BY WardId)AS a WHERE b >=1000)AS c;

-- !question6

SELECT a.aname AS name, totdata/totward AS avg_SIZE FROM
(SELECT Region.name as aname, SUM(data) AS totdata 
FROM Region JOIN County ON Region.code = County.parent 
            JOIN Ward ON Ward.parent = County.code 
            JOIN Statistic ON Statistic.wardId = Ward.code 
            GROUP BY Region.name) AS a 
JOIN 
(SELECT Region.name AS bname, COUNT(DISTINCT Ward.code) AS totward 
FROM Region JOIN County ON Region.code = County.parent 
            JOIN Ward ON Ward.parent = County.code 
            JOIN Statistic ON Statistic.wardId = Ward.code 
            GROUP BY Region.name) AS b 
WHERE a.aname = b.bname;

-- !question7

SELECT CLU, occupation, REPLACE(REPLACE(gender, '1', 'female'),'0', 'male')AS gender,N 
FROM(
SELECT gender, occname AS occupation, SUM(data) AS N, County.name AS CLU 
FROM(
SELECT gender, occname, data, Ward.parent AS wp 
FROM(
SELECT gender, name AS occname, wardId, data FROM Statistic JOIN Occupation ON occId = id) AS a 
JOIN Ward ON Ward.code = wardID) AS b 
JOIN County ON County.code = wp WHERE County.parent = "E12000002" GROUP BY b.gender, b.occname, wp) AS c WHERE N >= 10000 ORDER BY N ASC;

-- !question8

SELECT aname AS Region_name, male_data, female_data, female_data/work_data AS proportion FROM 
(SELECT Region.name AS aname, e AS male_data FROM(
SELECT County.parent AS f, SUM(c) AS e FROM(
SELECT Ward.parent AS d, SUM(data) AS c FROM(
SELECT wardId, data FROM Statistic WHERE occId = '1' AND gender = '0') AS a JOIN Ward ON Ward.code = wardId GROUP BY Ward.parent) AS b JOIN County ON d = County.code GROUP BY County.parent) AS g JOIN Region ON f = Region.code)AS aaa 
JOIN
(SELECT Region.name AS bname, e AS female_data FROM(
SELECT County.parent AS f, SUM(c) AS e FROM(
SELECT Ward.parent AS d, SUM(data) AS c FROM(
SELECT wardId, data FROM Statistic WHERE occId = '1' AND gender = '1') AS a JOIN Ward ON Ward.code = wardId GROUP BY Ward.parent) AS b JOIN County ON d = County.code GROUP BY County.parent) AS g JOIN Region ON f = Region.code) AS bbb ON aname = bname JOIN
(SELECT Region.name AS cname, e AS work_data FROM(
SELECT County.parent AS f, SUM(c) AS e FROM(
SELECT Ward.parent AS d, SUM(data) AS c FROM(
SELECT wardId, data FROM Statistic WHERE occId = '1') AS a JOIN Ward ON Ward.code = wardId GROUP BY Ward.parent) AS b JOIN County ON d = County.code GROUP BY County.parent) AS g JOIN Region ON f = Region.code) AS ccc ON bname = cname ORDER BY proportion ASC;

-- !question9

SELECT a.aname AS name, totdata/totward AS avg_SIZE FROM(SELECT Region.name as aname, SUM(data) AS totdata 
FROM Region JOIN County ON Region.code = County.parent 
            JOIN Ward ON Ward.parent = County.code 
            JOIN Statistic ON Statistic.wardId = Ward.code GROUP BY Region.name) AS a 
JOIN 
(SELECT Region.name AS bname, COUNT(DISTINCT Ward.code) AS totward 
FROM Region JOIN County ON Region.code = County.parent 
            JOIN Ward ON Ward.parent = County.code 
            JOIN Statistic ON Statistic.wardId = Ward.code GROUP BY Region.name) AS b WHERE a.aname = b.bname
UNION ALL 
SELECT Country.name AS England, SUM(data)/COUNT(DISTINCT Ward.code) AS avg_SIZE 
FROM Country JOIN County ON Country.code = County.country 
             JOIN Ward ON Ward.parent = County.code 
             JOIN Statistic ON Statistic.wardId = Ward.code WHERE Country.name = "England"
UNION ALL 
SELECT 'ALL', SUM(data)/COUNT(DISTINCT wardId) FROM Statistic;

-- !end
