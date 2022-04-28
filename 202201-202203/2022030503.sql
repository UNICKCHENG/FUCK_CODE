-- 链接 LINK: https://www.nowcoder.com/practice/b3a0731dfd654361943916d8d85699cd?tpId=268&tqId=2285791&ru=/practice/b3a0731dfd654361943916d8d85699cd&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL26 某宝店铺的实际销售额与客单价
-- 日期 DATE: 2022-03-05 10:27:31

-- 题解 SQL
SELECT SUM(sales_price) sales_total,
        ROUND(SUM(sales_price)/COUNT(DISTINCT user_id), 2) per_trans
FROM sales_tb
WHERE DATE_FORMAT(sales_date, '%Y-%m') = '2021-11'
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