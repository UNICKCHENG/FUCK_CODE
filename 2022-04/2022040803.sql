-- 链接 LINK: https://leetcode-cn.com/problems/number-of-transactions-per-visit/comments/
-- 标题 TITLE: 1336. 每次访问的交易次数
-- 日期 DATE: 2022-04-08 15:33:07

-- 题解 SQL
SELECT transactions_count, visits_count
FROM (
    SELECT TB.cnt transactions_count
            , IFNULL(TA.visits_count, 0) visits_count
            , MAX(TA.transactions_count) OVER() max_transactions_count
    FROM (
        -- 核心代码
        SELECT IFNULL(transactions_count, 0) transactions_count, COUNT(1) visits_count 
        FROM (
            SELECT user_id, visit_date FROM Visits 
            GROUP BY user_id, visit_date
        ) T1
        LEFT JOIN (
            SELECT user_id, transaction_date, COUNT(1) transactions_count 
            FROM Transactions 
            GROUP BY user_id, transaction_date
        ) T2 ON (T2.user_id, T2.transaction_date) = (T1.user_id, T1.visit_date)
        GROUP BY IFNULL(transactions_count, 0)
    ) TA
    RIGHT JOIN (
        -- 补全 transactions_count 不连续问题, 注意 Transactions 可能为空, 所以这里至少保证有一条数据显示
        SELECT (@cnt := @cnt + 1) cnt
        FROM (SELECT @cnt := -1) T2
        LEFT JOIN Transactions T1 ON 1 = 1
    ) TB ON TB.cnt = TA.transactions_count
    ORDER BY TB.cnt
) TRESULT
WHERE transactions_count <= max_transactions_count
;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Visits;
DROP TABLE IF EXISTS Transactions;
Create table If Not Exists Visits (user_id int, visit_date date);
Create table If Not Exists Transactions (user_id int, transaction_date date, amount int);
Truncate table Visits;
insert into Visits (user_id, visit_date) values ('1', '2020-01-01');
insert into Visits (user_id, visit_date) values ('2', '2020-01-02');
insert into Visits (user_id, visit_date) values ('12', '2020-01-01');
insert into Visits (user_id, visit_date) values ('19', '2020-01-03');
insert into Visits (user_id, visit_date) values ('1', '2020-01-02');
insert into Visits (user_id, visit_date) values ('2', '2020-01-03');
insert into Visits (user_id, visit_date) values ('1', '2020-01-04');
insert into Visits (user_id, visit_date) values ('7', '2020-01-11');
insert into Visits (user_id, visit_date) values ('9', '2020-01-25');
insert into Visits (user_id, visit_date) values ('8', '2020-01-28');
Truncate table Transactions;
insert into Transactions (user_id, transaction_date, amount) values ('1', '2020-01-02', '120');
insert into Transactions (user_id, transaction_date, amount) values ('2', '2020-01-03', '22');
insert into Transactions (user_id, transaction_date, amount) values ('7', '2020-01-11', '232');
insert into Transactions (user_id, transaction_date, amount) values ('1', '2020-01-04', '7');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '33');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '66');
insert into Transactions (user_id, transaction_date, amount) values ('8', '2020-01-28', '1');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '99');