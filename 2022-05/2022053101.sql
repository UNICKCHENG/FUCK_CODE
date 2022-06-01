-- 链接 LINK: https://leetcode.cn/problems/leetcodify-friends-recommendations/
-- 标题 TITLE: 1917. Leetcodify 好友推荐
-- 日期 DATE: 2022-05-31 12:16:20

-- 题解 SQL 反连接（NOT EXISTS）
SELECT T1.user_id, T1.recommended_id
FROM (
    SELECT DISTINCT T1A.user_id, T1B.user_id recommended_id
    FROM Listens T1A
    INNER JOIN Listens T1B
        ON T1A.user_id != T1B.user_id AND (T1B.song_id, T1B.day) = (T1A.song_id, T1A.day)
    GROUP BY T1A.day, T1A.user_id, T1B.user_id
    HAVING COUNT(DISTINCT T1A.song_id) >= 3
) T1
WHERE NOT EXISTS (
    SELECT 1 FROM Friendship
    WHERE (user1_id, user2_id) = (T1.user_id, T1.recommended_id)
            OR (user2_id, user1_id) = (T1.user_id, T1.recommended_id)
)

;


-- 题解 SQL JOIN 连接
SELECT T1.user_id, T1.recommended_id
FROM (
    SELECT DISTINCT T1A.user_id, T1B.user_id recommended_id
    FROM Listens T1A
    INNER JOIN Listens T1B
        ON T1A.user_id != T1B.user_id AND (T1B.song_id, T1B.day) = (T1A.song_id, T1A.day)
    GROUP BY T1A.day, T1A.user_id, T1B.user_id
    HAVING COUNT(DISTINCT T1A.song_id) >= 3
) T1
LEFT JOIN Friendship T2 
    ON (T2.user1_id, T2.user2_id) = (T1.user_id, T1.recommended_id) 
        OR (T2.user2_id, T2.user1_id) = (T1.user_id, T1.recommended_id)
WHERE T2.user1_id IS NULL

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Listens;
DROP TABLE IF EXISTS Friendship;
Create table If Not Exists Listens (user_id int, song_id int, day date);
Create table If Not Exists Friendship (user1_id int, user2_id int);
Truncate table Listens;
insert into Listens (user_id, song_id, day) values ('1', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('1', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('1', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '13', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('5', '10', '2021-03-16');
insert into Listens (user_id, song_id, day) values ('5', '11', '2021-03-16');
insert into Listens (user_id, song_id, day) values ('5', '12', '2021-03-16');
Truncate table Friendship;
insert into Friendship (user1_id, user2_id) values ('1', '2');