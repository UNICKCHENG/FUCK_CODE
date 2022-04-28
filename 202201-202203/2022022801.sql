-- 链接 LINK: https://www.nowcoder.com/practice/715dd44c994f45cb871afa98f1b77538?tpId=268&tqId=2285871&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj%3Ftab%3DSQL%25E7%25AF%2587%26topicId%3D268
-- 标题 TITLE: SQL28 某宝店铺动销率与售罄率
-- 日期 DATE: 2022-02-28 09:23:00

/* NOTE 几个定义

- GMV(Gross Merchandise Volume) 商品交易总额, 即成交总额
- SKU(Stock Keeping Unit) 库存量单位，即非常具体的一个产品（不可再细分）, 如 iphone 13 mini + 午夜色 + 512 GB + 公开版
- SPU(Standard Product Unit) 标准化产品单元, 描述一个产品的特性, 即特性相同的商品可以称为一个SPU。如 iphone 13 mini

- 动销率
    - 关注数量：动销率=已经销售的数量 / 剩余库存的数量
    - 关注种类：动销率=有销售记录的产品种类 / 所有库存产品种类
- 滞销率=1-动销率
- 售罄率=GMV / 备货值 （备货值=吊牌价*库存数）
    
**/

-- 题解 SQL
SELECT style_id,
        ROUND(SUM(T2.sales_num)*100/(SUM(T1.inventory)-SUM(T2.sales_num)), 2) `pin_rate(%)`,
        ROUND(SUM(T2.sales_price)*100/SUM(T1.price), 2) `sell-through_rate(%)`
FROM (
    SELECT item_id, style_id, (tag_price*inventory) price, inventory FROM product_tb
) T1
LEFT JOIN (
    SELECT item_id, SUM(sales_price) sales_price, SUM(sales_num) sales_num
    FROM sales_tb WHERE DATE_FORMAT(sales_date, '%Y-%m') = '2021-11'
    GROUP BY item_id
) T2 ON T2.item_id = T1.item_id
GROUP BY style_id
ORDER BY style_id
;


-- 数据 DATA ===================================================

drop table if exists product_tb;
CREATE TABLE product_tb(
item_id char(10) NOT NULL,
style_id char(10) NOT NULL,
tag_price int(10) NOT NULL,
inventory int(10) NOT NULL
);
INSERT INTO product_tb VALUES('A001', 'A', 100,  20);
INSERT INTO product_tb VALUES('A002', 'A', 120, 30);
INSERT INTO product_tb VALUES('A003', 'A', 200,  15);
INSERT INTO product_tb VALUES('B001', 'B', 130, 18);
INSERT INTO product_tb VALUES('B002', 'B', 150,  22);
INSERT INTO product_tb VALUES('B003', 'B', 125, 10);
INSERT INTO product_tb VALUES('B004', 'B', 155,  12);
INSERT INTO product_tb VALUES('C001', 'C', 260, 25);
INSERT INTO product_tb VALUES('C002', 'C', 280,  18);

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