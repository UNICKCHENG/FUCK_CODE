-- 链接 LINK: https://www.nowcoder.com/practice/2b6ea6b8fe634d2cbc39be46db411ca4?tpId=268&tqId=2285758&ru=/practice/bdd30e83d47043c99def6d9671bb6dbf&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL25 某宝店铺的SPU数量
-- 日期 DATE: 2022-02-03 17:38:05

-- 题解 SQL
SELECT style_id, COUNT(item_id) SPU_num
FROM product_tb
GROUP BY style_id
ORDER BY SPU_num DESC
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