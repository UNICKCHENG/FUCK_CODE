-- 链接 LINK: https://leetcode-cn.com/problems/students-report-by-geography/
-- 标题 TITLE: 618. 学生地理信息报告
-- 日期 DATE: 2022-04-21 14:32:50


-- 题解 SQL CASE 1
SELECT IFNULL(T4.name, 'null') America, IFNULL(T2.name, 'null') Asia, IFNULL(T3.name, 'null') Europe
FROM (
    SELECT ROW_NUMBER() OVER() ranks FROM Student
) T1
LEFT JOIN (
    SELECT name, ROW_NUMBER() OVER() ranks 
    FROM Student WHERE continent = 'Asia' ORDER BY name
) T2 ON T2.ranks = T1.ranks
LEFT JOIN (
    SELECT name, ROW_NUMBER() OVER() ranks 
    FROM Student WHERE continent = 'Europe' ORDER BY name
) T3 ON T3.ranks = T1.ranks
LEFT JOIN (
    SELECT name, ROW_NUMBER() OVER() ranks 
    FROM Student WHERE continent = 'America' ORDER BY name
) T4 ON T4.ranks = T1.ranks
WHERE T2.ranks IS NOT NULL OR T3.ranks IS NOT NULL OR T4.ranks IS NOT NULL
;

-- 题解 SQL CASE 2 [推荐]
SELECT MAX(CASE WHEN continent = 'America' THEN name ELSE null END) America
        , MAX(CASE WHEN continent = 'Asia' THEN name ELSE NULL END) Asia
        , MAX(CASE WHEN continent = 'Europe' THEN name ELSE NULL END) Europe
FROM (
    SELECT *
            , ROW_NUMBER() OVER(PARTITION BY continent ORDER BY name) ranks
    FROM Student
) T1
GROUP BY ranks
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Student;
Create table If Not Exists Student (name varchar(50), continent varchar(7));
Truncate table Student;
insert into Student (name, continent) values ('Jane', 'America');
insert into Student (name, continent) values ('Pascal', 'Europe');
insert into Student (name, continent) values ('Xi', 'Asia');
insert into Student (name, continent) values ('Jack', 'America');