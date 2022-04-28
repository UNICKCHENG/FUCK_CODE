-- 链接 LINK: https://leetcode-cn.com/problems/second-degree-follower/
-- 标题 TITLE: 614. 二级关注者
-- 日期 DATE: 2022-04-22 11:48:28


-- 题解 SQL
SELECT followee follower, COUNT(1) num
FROM Follow T1
WHERE EXISTS (
    SELECT 1 FROM Follow WHERE follower = T1.followee
)
GROUP BY followee
ORDER BY followee

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Follow;
Create table If Not Exists Follow (followee varchar(255), follower varchar(255));
Truncate table Follow;
insert into Follow (followee, follower) values ('Alice', 'Bob');
insert into Follow (followee, follower) values ('Bob', 'Cena');
insert into Follow (followee, follower) values ('Bob', 'Donald');
insert into Follow (followee, follower) values ('Donald', 'Edward');