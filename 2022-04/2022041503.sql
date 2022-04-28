-- 链接 LINK: https://leetcode-cn.com/problems/total-sales-amount-by-year/
-- 标题 TITLE: 1384. 按年度列出销售总额
-- 日期 DATE: 2022-04-19 11:33:16

/* 设计思路

**/

-- 题解 SQL
SELECT T1.product_id, T3.product_name, T2.report_year
        , (CASE report_year 
                WHEN '2018' THEN amount_2018
                WHEN '2019' THEN amount - amount_2020 - amount_2018
                WHEN '2020' THEN amount_2020
            ELSE 0 END ) total_amount
FROM (
    SELECT *
            , (CASE WHEN YEAR(period_start) = '2018' AND YEAR(period_end) = '2018' 
                        THEN average_daily_sales * (TIMESTAMPDIFF(DAY, period_start , period_end) + 1)
                    WHEN YEAR(period_start) = '2018'
                        THEN average_daily_sales * (TIMESTAMPDIFF(DAY, period_start , '2018-12-31') + 1)
                ELSE 0 END ) amount_2018
            , (CASE WHEN YEAR(period_end) = '2020' 
                        THEN average_daily_sales * (TIMESTAMPDIFF(DAY, '2020-01-01', period_end) + 1)
                ELSE 0 END ) amount_2020
            , average_daily_sales * (TIMESTAMPDIFF(DAY, period_start, period_end) + 1) amount
    FROM Sales
    WHERE '2018' <= YEAR(period_start) AND YEAR(period_end) <= '2020'
) T1
LEFT JOIN (
    SELECT '2018' report_year
    UNION SELECT '2019' report_year
    UNION SELECT '2020' report_year
) T2 ON report_year BETWEEN YEAR(period_start) AND YEAR(period_end)
INNER JOIN Product T3 ON T3.product_id = T1.product_id
ORDER BY T1.product_id, T2.report_year



;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Sales;
Create table If Not Exists Product (product_id int, product_name varchar(30));
Create table If Not Exists Sales (product_id varchar(30), period_start date, period_end date, average_daily_sales int);
Truncate table Product;
insert into Product (product_id, product_name) values ('1', 'LC Phone ');
insert into Product (product_id, product_name) values ('2', 'LC T-Shirt');
insert into Product (product_id, product_name) values ('3', 'LC Keychain');
Truncate table Sales;
insert into Sales (product_id, period_start, period_end, average_daily_sales) values ('1', '2019-01-25', '2019-02-28', '100');
insert into Sales (product_id, period_start, period_end, average_daily_sales) values ('2', '2018-12-01', '2020-01-01', '10');
insert into Sales (product_id, period_start, period_end, average_daily_sales) values ('3', '2019-12-01', '2020-01-31', '1');