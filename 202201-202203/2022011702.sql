-- 链接 LINK: https://www.nowcoder.com/practice/65de67f666414c0e8f9a34c08d4a8ba6?tpId=268&tags=&title=&difficulty=0&judgeStatus=0&rp=0
-- 标题 TITLE: SQL15 某店铺的各商品毛利率及店铺整体毛利率
-- 日期 DATE: 2022-01-17 15:36:35

-- DATE_FORMAT 参数格式
-- SELECT DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%Y-%M-%D');

-- 题解 SQL
SELECT "店铺汇总" product_id, 
       CONCAT(ROUND((1 - IFNULL(SUM(T1.in_price * T2.cnt)/SUM(T2.price * T2.cnt), 0))*100, 1), '%') AS profit_rate
FROM (SELECT product_id, in_price FROM tb_product_info WHERE shop_id = '901') T1
INNER JOIN tb_order_detail T2 ON T2.product_id = T1.product_id
INNER JOIN (SELECT order_id FROM tb_order_overall WHERE status = 1 AND event_time >= '2021-10-01') T3 ON T3.order_id = T2.order_id
UNION
SELECT product_id, profit_rate FROM (
    SELECT T1.product_id,
            CONCAT(ROUND((1 - IFNULL(AVG(T1.in_price)/AVG(T2.price), 0))*100, 1), '%') AS profit_rate
    FROM (SELECT product_id, in_price FROM tb_product_info WHERE shop_id = '901') T1
    INNER JOIN tb_order_detail T2 ON T2.product_id = T1.product_id
    INNER JOIN (SELECT order_id FROM tb_order_overall  WHERE status = 1 AND event_time >= '2021-10-01') T3 ON T3.order_id = T2.order_id
    GROUP BY T1.product_id
    HAVING (1 - IFNULL(AVG(T1.in_price)/AVG(T2.price), 0))*100 > 24.9
    ORDER BY product_id 
) T4
;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS tb_order_overall;
CREATE TABLE tb_order_overall (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
order_id INT NOT NULL COMMENT '订单号',
uid INT NOT NULL COMMENT '用户ID',
event_time datetime COMMENT '下单时间',
total_amount DECIMAL NOT NULL COMMENT '订单总金额',
total_cnt INT NOT NULL COMMENT '订单商品总件数',
`status` TINYINT NOT NULL COMMENT '订单状态'
) CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_order_overall(order_id, uid, event_time, total_amount, total_cnt, `status`) VALUES
(301001, 101, '2021-09-30 10:00:00', 30000, 3, 1),
(301002, 102, '2021-10-01 11:00:00', 23900, 2, 1),
(301003, 103, '2021-11-02 10:00:00', 31000, 2, 1),
(301004, 103, '2021-10-03 10:00:00', 17000, 1, 1);

DROP TABLE IF EXISTS tb_product_info;
CREATE TABLE tb_product_info (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
product_id INT NOT NULL COMMENT '商品ID',
shop_id INT NOT NULL COMMENT '店铺ID',
tag VARCHAR(12) COMMENT '商品类别标签',
in_price DECIMAL NOT NULL COMMENT '进货价格',
quantity INT NOT NULL COMMENT '进货数量',
release_time datetime COMMENT '上架时间'
) CHARACTER SET utf8 COLLATE utf8_bin;

DROP TABLE IF EXISTS tb_order_detail;
CREATE TABLE tb_order_detail (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
order_id INT NOT NULL COMMENT '订单号',
product_id INT NOT NULL COMMENT '商品ID',
price DECIMAL NOT NULL COMMENT '商品单价',
cnt INT NOT NULL COMMENT '下单数量'
) CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_product_info(product_id, shop_id, tag, in_price, quantity, release_time) VALUES
(8001, 901, '家电', 6000, 100, '2020-01-01 10:00:00'),
(8002, 901, '家电', 14000, 50, '2020-01-01 10:00:00'),
(8003, 901, '3C数码', 16000, 50, '2020-01-01 10:00:00'),
(8004, 902, '3C数码', 13000, 50, '2020-01-01 10:00:00');

INSERT INTO tb_order_detail(order_id, product_id, price, cnt) VALUES
(301001, 8001, 8500, 2),
(301001, 8002, 15000, 1),
(301002, 8001, 8500, 1),
(301002, 8002, 16000, 1),
(301003, 8002, 14000, 1),
(301003, 8003, 18000, 1),
(301004, 8004, 18000, 1);