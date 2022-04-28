-- 链接 LINK: https://leetcode-cn.com/problems/tournament-winners/
-- 标题 TITLE: 1194. 锦标赛优胜者
-- 日期 DATE: 2022-04-13 13:48:50

-- 设计思路 前 TOP N 类题型

-- 题解 SQL
SELECT group_id, player_id
FROM (
    SELECT T2.group_id, T2.player_id
            , ROW_NUMBER() OVER(PARTITION BY T2.group_id ORDER BY SUM(score) DESC, T2.player_id) ranks
    FROM (
        SELECT first_player player_id, first_score score FROM Matches 
        UNION ALL
        SELECT second_player player_id, second_score score FROM Matches 
    ) T1
    INNER JOIN Players T2 ON T2.player_id = T1.player_id
    GROUP BY T2.group_id, T2.player_id
) TRESULT
WHERE ranks = 1

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Matches;
Create table If Not Exists Players (player_id int, group_id int);
Create table If Not Exists Matches (match_id int, first_player int, second_player int, first_score int, second_score int);
Truncate table Players;
insert into Players (player_id, group_id) values ('10', '2');
insert into Players (player_id, group_id) values ('15', '1');
insert into Players (player_id, group_id) values ('20', '3');
insert into Players (player_id, group_id) values ('25', '1');
insert into Players (player_id, group_id) values ('30', '1');
insert into Players (player_id, group_id) values ('35', '2');
insert into Players (player_id, group_id) values ('40', '3');
insert into Players (player_id, group_id) values ('45', '1');
insert into Players (player_id, group_id) values ('50', '2');
Truncate table Matches;
insert into Matches (match_id, first_player, second_player, first_score, second_score) values ('1', '15', '45', '3', '0');
insert into Matches (match_id, first_player, second_player, first_score, second_score) values ('2', '30', '25', '1', '2');
insert into Matches (match_id, first_player, second_player, first_score, second_score) values ('3', '30', '15', '2', '0');
insert into Matches (match_id, first_player, second_player, first_score, second_score) values ('4', '40', '20', '5', '2');
insert into Matches (match_id, first_player, second_player, first_score, second_score) values ('5', '35', '50', '1', '1');