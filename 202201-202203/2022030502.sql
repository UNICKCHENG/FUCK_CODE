-- 链接 LINK: https://www.nowcoder.com/practice/63ac3be0e4b44cce8dd2619d2236c3bf?tpId=268&tqId=2285906&ru=/practice/d1f5a1e50d0b49f3a39eb01c4fdb621f&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL29 某宝店铺连续2天及以上购物的用户及其对应的天数
-- 日期 DATE: 2022-03-05 09:31:36

-- 题解 SQL 牛客官网数据存在缺陷
-- 正常存在的数据格式如下
-- 1. 没有一条数据满足连续2天及以上购物
-- 2. 有一名或多名用户连续2天及以上购物, 且每名用户只有一次连续. 如 user_id = 20, 在日期 [2021-11-01, 2021-11-03] 区间内进行购物, 且该用户无其他符合条件的数据
-- 3. 有一名或多名用户连续2天及以上购物, 且每名用户有多次连续. 如 user_id = 20, 在日期 [2021-11-01, 2021-11-03] 区间内进行购物, 且该用户还在 [2021-11-11, 2021-11-20] 区间内进行购物
SELECT DISTINCT user_id, sum(count(1)) OVER(PARTITION BY user_id) days_count
FROM (
    -- 清洗数据: 每个交易日(sales_date)下有哪些用户进行交易(user_id), flg 表示为连续日期交易的标志
    SELECT sales_date, user_id,
        DATE_SUB(sales_date, interval ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY sales_date) day) flg
    FROM sales_tb
    WHERE DATE_FORMAT(sales_date, '%Y-%m') = '2021-11'
    GROUP BY user_id, sales_date
) TA
GROUP BY user_id, flg
HAVING count(1) >= 2
ORDER BY user_id
;

-- 数据 DATA ===================================================
drop table if exists sales_tb;
CREATE TABLE sales_tb(
sales_date date NOT NULL,
user_id int(10) NOT NULL,
item_id char(10) NOT NULL,
sales_num int(10) NOT NULL,
sales_price int(10) NOT NULL
);

INSERT INTO sales_tb VALUES('2021-11-1', 1, 'A001',  1, 90);
INSERT INTO sales_tb VALUES('2021-11-1', 2, 'A002',  2, 220);
INSERT INTO sales_tb VALUES('2021-11-1', 2, 'B001',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-2', 3, 'C001',  2, 500);
INSERT INTO sales_tb VALUES('2021-11-2', 4, 'B001',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-3', 5, 'C001',  1, 240);
INSERT INTO sales_tb VALUES('2021-11-3', 6, 'C002',  1, 270);
INSERT INTO sales_tb VALUES('2021-11-4', 7, 'A003',  1, 180);
INSERT INTO sales_tb VALUES('2021-11-4', 8, 'B002',  1, 140);
INSERT INTO sales_tb VALUES('2021-11-4', 9, 'B001',  1, 125);
INSERT INTO sales_tb VALUES('2021-11-5', 10, 'B003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-5', 10, 'B004',  1, 150);
INSERT INTO sales_tb VALUES('2021-11-5', 10, 'A003',  1, 180);
INSERT INTO sales_tb VALUES('2021-11-6', 11, 'B003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-6', 10, 'B004',  1, 150);
-- 补充样例
INSERT INTO sales_tb VALUES('2021-11-10', 20, 'B004',  1, 150);
INSERT INTO sales_tb VALUES('2021-11-10', 20, 'B004',  1, 150);
INSERT INTO sales_tb VALUES('2021-11-11', 20, 'A003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-12', 20, 'A003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-20', 20, 'B004',  1, 150);
INSERT INTO sales_tb VALUES('2021-11-21', 20, 'A003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-22', 20, 'A003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-21', 21, 'A003',  1, 120);
INSERT INTO sales_tb VALUES('2021-11-22', 21, 'A003',  1, 120);