-- 链接 LINK: https://leetcode-cn.com/problems/sales-by-day-of-the-week/
-- 标题 TITLE: 1479. 周内每天的销售情况
-- 日期 DATE: 2022-04-15 13:33:41

-- 题解 SQL
SELECT item_category Category
        , SUM(IF(WEEKDAY(order_date) = 0, quantity, 0)) Monday
        , SUM(IF(WEEKDAY(order_date) = 1, quantity, 0)) Tuesday
        , SUM(IF(WEEKDAY(order_date) = 2, quantity, 0)) Wednesday
        , SUM(IF(WEEKDAY(order_date) = 3, quantity, 0)) Thursday
        , SUM(IF(WEEKDAY(order_date) = 4, quantity, 0)) Friday
        , SUM(IF(WEEKDAY(order_date) = 5, quantity, 0)) Saturday
        , SUM(IF(WEEKDAY(order_date) = 6, quantity, 0)) Sunday
FROM Orders T1
RIGHT JOIN Items T2 ON T1.item_id = T2.item_id
GROUP BY item_category
ORDER BY Category

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Items;
Create table If Not Exists Orders (order_id int, customer_id int, order_date date, item_id varchar(30), quantity int);
Create table If Not Exists Items (item_id varchar(30), item_name varchar(30), item_category varchar(30));
Truncate table Orders;
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('1', '1', '2020-06-01', '1', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('2', '1', '2020-06-08', '2', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('3', '2', '2020-06-02', '1', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('4', '3', '2020-06-03', '3', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('5', '4', '2020-06-04', '4', '1');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('6', '4', '2020-06-05', '5', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('7', '5', '2020-06-05', '1', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('8', '5', '2020-06-14', '4', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('9', '5', '2020-06-21', '3', '5');
Truncate table Items;
insert into Items (item_id, item_name, item_category) values ('1', 'LC Alg. Book', 'Book');
insert into Items (item_id, item_name, item_category) values ('2', 'LC DB. Book', 'Book');
insert into Items (item_id, item_name, item_category) values ('3', 'LC SmarthPhone', 'Phone');
insert into Items (item_id, item_name, item_category) values ('4', 'LC Phone 2020', 'Phone');
insert into Items (item_id, item_name, item_category) values ('5', 'LC SmartGlass', 'Glasses');
insert into Items (item_id, item_name, item_category) values ('6', 'LC T-Shirt XL', 'T-shirt');