-- 链接 LINK: https://leetcode-cn.com/problems/longest-winning-streak/
-- 标题 TITLE: 2173. 最多连胜的次数
-- 日期 DATE: 2022-04-14 11:48:28

-- 连续签到类问题: 最长连续签到时间


-- 题解 SQL CASE 1 窗口函数
SELECT T1.player_id, IFNULL(T2.longest_streak, 0) longest_streak
FROM (
    SELECT player_id FROM Matches GROUP BY player_id
) T1
LEFT JOIN (
    SELECT DISTINCT player_id, MAX(COUNT(1)) OVER(PARTITION BY player_id) longest_streak
    FROM (
        SELECT player_id, (flg - ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_day)) flg
        FROM (
            SELECT *, (ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_day)) flg
            FROM Matches
        ) TA
        WHERE result = 'Win'
    ) TRESULT
    GROUP BY player_id, flg
) T2 ON T2.player_id = T1.player_id
ORDER BY T1.player_id
;


-- 题解 SQL CASE 2 【推荐】变量依次遍历
SELECT player_id, MAX(flg) longest_streak
FROM (
    SELECT player_id
            , (CASE WHEN @id = player_id THEN @flg := @flg ELSE @flg := 0 END) 
            , (CASE WHEN result = 'Win' THEN @flg := @flg + 1 ELSE @flg := 0 END) flg
            , @id := player_id
    FROM Matches A, (SELECT @flg:=0, @id:=0) B
    ORDER BY player_id, match_day
) T1
GROUP BY player_id
;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Matches;
Create table If Not Exists Matches (player_id int, match_day date, result ENUM('Win', 'Draw', 'Lose'));
Truncate table Matches;
insert into Matches (player_id, match_day, result) values ('1', '2022-01-17', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-18', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-25', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-31', 'Draw');
insert into Matches (player_id, match_day, result) values ('1', '2022-02-08', 'Win');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-06', 'Lose');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-08', 'Lose');
insert into Matches (player_id, match_day, result) values ('3', '2022-03-30', 'Win');