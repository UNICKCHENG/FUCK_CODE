-- 链接 LINK: https://leetcode-cn.com/problems/game-play-analysis-v/
-- 标题 TITLE: 1097. 游戏玩法分析 V
-- 日期 DATE: 2022-04-13 14:04:27

/* 设计思路
Q: 玩家在不同设备上再次安装，加不加入统计
A：只有首次安装算作第一个登陆日
**/

-- 题解 SQL
SELECT first_event install_dt 
        , COUNT(player_id) installs
        , ROUND(COUNT(IF(TIMESTAMPDIFF(DAY, first_event, next_event) = 1, 1, NULL)) / COUNT(player_id), 2) Day1_retention
FROM (
    SELECT event_date, player_id
            , MIN(event_date) OVER(PARTITION BY player_id) first_event
            , LEAD(event_date, 1) OVER(PARTITION BY player_id ORDER BY event_date) next_event
    FROM Activity 
    GROUP BY event_date, player_id
) TRESULT
WHERE event_date = first_event
GROUP BY first_event
ORDER BY first_event
;

-- 题解 SQL 【推荐】
SELECT first_event install_dt
        , COUNT(DISTINCT player_id) installs
        , ROUND(COUNT(IF(TIMESTAMPDIFF(DAY, first_event, event_date) = 1, 1, NULL)) / COUNT(DISTINCT player_id), 2) Day1_retention
FROM (
    SELECT event_date, player_id
            , MIN(event_date) OVER(PARTITION BY player_id) first_event
    FROM Activity
    GROUP BY event_date, player_id
) TRESULT
GROUP BY first_event
ORDER BY first_event
;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-01', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');