-- 链接 LINK: https://leetcode-cn.com/problems/first-and-last-call-on-the-same-day/
-- 标题 TITLE: 1972. 同一天的第一个电话和最后一个电话
-- 日期 DATE: 2022-04-09 10:18:18

/* 设计思路 基础题
- 题意是接电话，也算在内。因此 UNION 将表扩展一下
- 找到每天每名用户的第一个电话和最后一个电话
- 筛选出每天每名用户的两个电话都是和同一个人
- 将以上用户去重打印
**/

-- 题解 SQL
SELECT DISTINCT u1 user_id 
FROM (
    SELECT dt, u1, u2
            , MIN(dt) OVER(PARTITION BY DATE_FORMAT(dt, '%Y-%m-%d'), u1) min_dt
            , MAX(dt) OVER(PARTITION BY DATE_FORMAT(dt, '%Y-%m-%d'), u1) max_dt
    FROM (
        SELECT caller_id u1, recipient_id u2, call_time dt FROM Calls 
        UNION
        SELECT recipient_id u1, caller_id u2, call_time dt FROM Calls 
    ) TA
) T1
WHERE dt = min_dt OR dt = max_dt
GROUP BY DATE_FORMAT(dt, '%Y-%m-%d'), u1
HAVING COUNT(DISTINCT u2) = 1
ORDER BY user_id 

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Calls;
Create table If Not Exists Calls (caller_id int, recipient_id int, call_time datetime);
Truncate table Calls;
insert into Calls (caller_id, recipient_id, call_time) values ('8', '4', '2021-08-24 17:46:07');
insert into Calls (caller_id, recipient_id, call_time) values ('4', '8', '2021-08-24 19:57:13');
insert into Calls (caller_id, recipient_id, call_time) values ('5', '1', '2021-08-11 05:28:44');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '3', '2021-08-17 04:04:15');
insert into Calls (caller_id, recipient_id, call_time) values ('11', '3', '2021-08-17 13:07:00');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '11', '2021-08-17 22:22:22');