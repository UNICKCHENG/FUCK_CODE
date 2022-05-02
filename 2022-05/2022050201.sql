-- 链接 LINK: https://leetcode-cn.com/problems/page-recommendations-ii/
-- 标题 TITLE: 1892. 页面推荐Ⅱ
-- 日期 DATE: 2022-05-02 13:52:32


-- 题解 SQL 反连接（NOT EXISTS）
SELECT T1.u1 user_id, T2.page_id, COUNT(DISTINCT T1.u2) friends_likes
FROM (
    SELECT user1_id u1, user2_id u2 FROM Friendship
    UNION ALL
    SELECT user2_id u1, user1_id u2 FROM Friendship
) T1
INNER JOIN Likes T2 ON T2.user_id = T1.u2
WHERE NOT EXISTS (
    SELECT 1 FROM Likes
    WHERE user_id = T1.u1 AND page_id = T2.page_id
)
GROUP BY T1.u1, T2.page_id
;

-- [推荐]题解 SQL JOIN 连接
SELECT T1.u1 user_id, T2.page_id, COUNT(DISTINCT T1.u2) friends_likes
FROM (
    SELECT user1_id u1, user2_id u2 FROM Friendship
    UNION ALL
    SELECT user2_id u1, user1_id u2 FROM Friendship
) T1
INNER JOIN Likes T2 ON T2.user_id = T1.u2
LEFT JOIN Likes T3 ON (T3.user_id,T3.page_id) = (T1.u1, T2.page_id)
WHERE T3.user_id IS NULL
GROUP BY T1.u1, T2.page_id
;

-- 题解 SQL JOIN 连接 + INSTR
SELECT T1.u1 user_id, T2.page_id, COUNT(1) friends_likes
FROM (
    SELECT user1_id u1, user2_id u2 FROM Friendship
    UNION 
    SELECT user2_id u1, user1_id u2 FROM Friendship
) T1 
INNER JOIN Likes T2 ON T2.user_id = T1.u2
INNER JOIN (
    SELECT page_id, group_concat(CONCAT("userid='", user_id, "'")) all_user_id
    FROM Likes
    GROUP BY page_id
) T3 ON T3.page_id = T2.page_id AND INSTR(T3.all_user_id, CONCAT("userid='", T1.u1, "'")) = 0
GROUP BY T1.u1, T2.page_id
;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Friendship;
DROP TABLE IF EXISTS Likes;
Create table If Not Exists Friendship (user1_id int, user2_id int);
Create table If Not Exists Likes (user_id int, page_id int);
insert into Friendship (user1_id, user2_id) values ('1', '2');
insert into Friendship (user1_id, user2_id) values ('1', '3');
insert into Friendship (user1_id, user2_id) values ('1', '4');
insert into Friendship (user1_id, user2_id) values ('2', '3');
insert into Friendship (user1_id, user2_id) values ('2', '4');
insert into Friendship (user1_id, user2_id) values ('2', '5');
insert into Friendship (user1_id, user2_id) values ('6', '1');
insert into Likes (user_id, page_id) values ('1', '88');
insert into Likes (user_id, page_id) values ('2', '23');
insert into Likes (user_id, page_id) values ('3', '24');
insert into Likes (user_id, page_id) values ('4', '56');
insert into Likes (user_id, page_id) values ('5', '11');
insert into Likes (user_id, page_id) values ('6', '33');
insert into Likes (user_id, page_id) values ('2', '77');
insert into Likes (user_id, page_id) values ('3', '77');
insert into Likes (user_id, page_id) values ('6', '88');