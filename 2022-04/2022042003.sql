-- 链接 LINK: https://leetcode-cn.com/problems/get-the-second-most-recent-activity/
-- 标题 TITLE: 1369. 获取最近第二次的活动
-- 日期 DATE: 2022-04-20 11:45:31

-- 题解 SQL
SELECT username, activity, startDate, endDate
FROM (
    SELECT *
            , ROW_NUMBER() OVER(PARTITION BY username ORDER BY startDate DESC) ranks
            , COUNT(1) OVER(PARTITION BY username) n
    FROM UserActivity
) T1
WHERE n = 1 OR ranks = 2
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS UserActivity;
Create table If Not Exists UserActivity (username varchar(30), activity varchar(30), startDate date, endDate date);
Truncate table UserActivity;
insert into UserActivity (username, activity, startDate, endDate) values ('Alice', 'Travel', '2020-02-12', '2020-02-20');
insert into UserActivity (username, activity, startDate, endDate) values ('Alice', 'Dancing', '2020-02-21', '2020-02-23');
insert into UserActivity (username, activity, startDate, endDate) values ('Alice', 'Travel', '2020-02-24', '2020-02-28');
insert into UserActivity (username, activity, startDate, endDate) values ('Bob', 'Travel', '2020-02-11', '2020-02-18');