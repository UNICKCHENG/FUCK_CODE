-- 链接 LINK: https://leetcode-cn.com/problems/new-users-daily-count/
-- 标题 TITLE: 107. 每日新用户统计
-- 日期 DATE: 2022-04-30 16:58:49


-- 题解 SQL
SELECT activity_date login_date, COUNT(user_id) user_count
FROM (
    SELECT user_id, activity_date
            , MIN(activity_date) OVER(PARTITION BY user_id) first_login_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id, activity_date
) T1
WHERE activity_date = first_login_date AND TIMESTAMPDIFF(DAY, activity_date, '2019-06-30') <= 90
GROUP BY activity_date

;

-- 题解 SQL
SELECT activity_date login_date, COUNT(user_id) user_count
FROM (
    SELECT user_id, MIN(activity_date) activity_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
    HAVING TIMESTAMPDIFF(DAY, activity_date, '2019-06-30') <= 90
) T1
GROUP BY activity_date

;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Traffic;
Create table If Not Exists Traffic (user_id int, activity ENUM('login', 'logout', 'jobs', 'groups', 'homepage'), activity_date date);
Truncate table Traffic;
insert into Traffic (user_id, activity, activity_date) values ('1', 'login', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('1', 'homepage', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('1', 'logout', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('2', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('2', 'logout', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('3', 'login', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('3', 'jobs', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('3', 'logout', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('4', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('4', 'groups', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('4', 'logout', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('5', 'login', '2019-03-01');
insert into Traffic (user_id, activity, activity_date) values ('5', 'logout', '2019-03-01');
insert into Traffic (user_id, activity, activity_date) values ('5', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('5', 'logout', '2019-06-21');