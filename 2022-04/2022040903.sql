-- 链接 LINK: https://leetcode-cn.com/problems/market-analysis-ii/
-- 标题 TITLE: 1159. 市场分析 II
-- 日期 DATE: 2022-04-09 09:21:26


/* 设计思路 简单题
注意 Items 表 相同的item_bran可能有多个item_id
**/

-- 题解 SQL
SELECT T1.user_id seller_id
        , IF(T3.2nd_item_fav_brand_flg = 1 AND T1.favorite_brand = T2.item_brand, 'yes', 'no') 2nd_item_fav_brand
FROM Users T1
LEFT JOIN (
    SELECT item_id, seller_id
            ,  ROW_NUMBER() OVER(PARTITION BY seller_id ORDER BY order_date, order_id) num
            , IF(COUNT(1) OVER(PARTITION BY seller_id) = 1, 0, 1)  2nd_item_fav_brand_flg
    FROM Orders
) T3 ON ((T3.2nd_item_fav_brand_flg, T3.num) = (1, 2) OR T3.2nd_item_fav_brand_flg = 0) 
    AND T3.seller_id = T1.user_id
LEFT JOIN Items T2 ON T2.item_id = T3.item_id
ORDER BY T1.user_id

;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Items;
Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
insert into Users (user_id, join_date, favorite_brand) values ('1', '2019-01-01', 'Lenovo');
insert into Users (user_id, join_date, favorite_brand) values ('2', '2019-02-09', 'Samsung');
insert into Users (user_id, join_date, favorite_brand) values ('3', '2019-01-19', 'LG');
insert into Users (user_id, join_date, favorite_brand) values ('4', '2019-05-21', 'HP');
Truncate table Orders;
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('1', '2019-08-01', '4', '1', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('2', '2019-08-02', '2', '1', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('3', '2019-08-03', '3', '2', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('4', '2019-08-04', '1', '4', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('5', '2019-08-04', '1', '3', '4');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
insert into Items (item_id, item_brand) values ('1', 'Samsung');
insert into Items (item_id, item_brand) values ('2', 'Lenovo');
insert into Items (item_id, item_brand) values ('3', 'LG');
insert into Items (item_id, item_brand) values ('4', 'HP');