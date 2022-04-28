-- 链接 LINK: https://leetcode-cn.com/problems/human-traffic-of-stadium/
-- 标题 TITLE: 601. 体育馆的人流量
-- 日期 DATE: 2022-04-10 11:38:36

/* 设计思路 基础题：连续签到类问题

**/

-- 题解 SQL
SELECT id, visit_date, people
FROM (
    SELECT *,
            COUNT(1) OVER(PARTITION BY tag) tag_cnt
    FROM (
        SELECT *
                , (id - ROW_NUMBER() OVER(ORDER BY id)) tag
        FROM Stadium 
        WHERE people >= 100
    ) TA
) T1
WHERE tag_cnt >= 3
ORDER BY visit_date

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Stadium;
Create table If Not Exists Stadium (id int, visit_date DATE NULL, people int);
Truncate table Stadium;
insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');