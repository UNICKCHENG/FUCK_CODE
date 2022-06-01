-- 链接 LINK: https://leetcode.cn/problems/longest-winning-streak/
-- 标题 TITLE: 2173. 最多连胜的次数
-- 日期 DATE: 2022-05-26 12:43:15


-- 题解 SQL 窗口函数
SELECT DISTINCT player_id
        , MAX(SUM(CASE WHEN result = 'Win' THEN 1 ELSE 0 END)) OVER(PARTITION BY player_id) longest_streak
FROM (
    SELECT player_id, match_day, result
        , ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_day) all_ranks
        , SUM(CASE WHEN result = 'Win' THEN 1 ELSE 0 END) OVER(PARTITION BY player_id ORDER BY match_day) win_ranks
    FROM Matches
) TRESULT
GROUP BY player_id, all_ranks - win_ranks
;

-- 变量实现



;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Matches;
Create table If Not Exists Matches (player_id int, match_day date, result ENUM('Win', 'Draw', 'Lose'));
insert into Matches (player_id, match_day, result) values ('1', '2022-01-17', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-18', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-25', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-31', 'Draw');
insert into Matches (player_id, match_day, result) values ('1', '2022-02-08', 'Win');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-06', 'Lose');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-08', 'Lose');
insert into Matches (player_id, match_day, result) values ('3', '2022-03-30', 'Win');