-- 链接 LINK: https://leetcode-cn.com/problems/reported-posts-ii/
-- 标题 TITLE: 1132. 报告的记录 II
-- 日期 DATE: 2022-04-23 10:13:41


-- 可能存在重复的行，所以需要去重
-- 题解 SQL
SELECT ROUND(AVG(COUNT(T2.post_id) * 100 / COUNT(T1.post_id)) OVER(), 2) average_daily_percent
FROM (
    SELECT action_date, post_id
    FROM Actions 
    WHERE extra = 'spam'
    GROUP BY action_date, post_id
) T1
LEFT JOIN Removals T2 ON T2.post_id = T1.post_id
GROUP BY T1.action_date
LIMIT 1

;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Actions;
DROP TABLE IF EXISTS Removals;
Create table If Not Exists Actions (user_id int, post_id int, action_date date, action ENUM('view', 'like', 'reaction', 'comment', 'report', 'share'), extra varchar(10));
create table if not exists Removals (post_id int, remove_date date);
Truncate table Actions;
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'like', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'share', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '2', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '2', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-03', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-03', 'report', 'racism');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-03', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-03', 'report', 'racism');
Truncate table Removals;
insert into Removals (post_id, remove_date) values ('2', '2019-07-20');
insert into Removals (post_id, remove_date) values ('3', '2019-07-18');