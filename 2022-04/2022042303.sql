-- 链接 LINK: https://leetcode-cn.com/problems/active-users/
-- 标题 TITLE: 1454. 活跃用户
-- 日期 DATE: 2022-04-23 10:13:44


-- 题解 SQL 内连接
SELECT T2.id, T2.name
FROM (
    SELECT DISTINCT id 
    FROM (
        SELECT id
            , TIMESTAMPADD(DAY, - ROW_NUMBER() OVER(PARTITION BY id ORDER BY login_date), login_date) tag
        FROM Logins
        GROUP BY id, login_date
    ) TL
    GROUP BY id, tag
    HAVING COUNT(1) >= 5
) T1
INNER JOIN Accounts T2 ON T2.id = T1.id
ORDER BY T2.id
;


-- 题解 SQL 子查询
SELECT id, name 
FROM Accounts TA
WHERE EXISTS (
    SELECT 1
    FROM (
        SELECT id
            , TIMESTAMPADD(DAY, - ROW_NUMBER() OVER(PARTITION BY id ORDER BY login_date), login_date) tag
        FROM Logins
        GROUP BY id, login_date
    ) TL
    WHERE TA.id = id
    GROUP BY id, tag
    HAVING COUNT(1) >= 5
)
ORDER BY id
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Logins;
Create table If Not Exists Accounts (id int, name varchar(10));
Create table If Not Exists Logins (id int, login_date date);
Truncate table Accounts;
insert into Accounts (id, name) values ('1', 'Winston');
insert into Accounts (id, name) values ('7', 'Jonathan');
Truncate table Logins;
insert into Logins (id, login_date) values ('7', '2020-05-30');
insert into Logins (id, login_date) values ('1', '2020-05-30');
insert into Logins (id, login_date) values ('7', '2020-05-31');
insert into Logins (id, login_date) values ('7', '2020-06-01');
insert into Logins (id, login_date) values ('7', '2020-06-02');
insert into Logins (id, login_date) values ('7', '2020-06-02');
insert into Logins (id, login_date) values ('7', '2020-06-03');
insert into Logins (id, login_date) values ('1', '2020-06-07');
insert into Logins (id, login_date) values ('7', '2020-06-10');