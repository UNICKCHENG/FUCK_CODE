-- 链接 LINK: https://www.nowcoder.com/practice/d15ee0798e884f829ae8bd27e10f0d64?tpId=268&tqId=2286131&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL17 10月的新户客单价和获客成本
-- 日期 DATE: 2022-01-31 13:29:47

-- 题解 SQL
SELECT ROUND(AVG(total_amount), 1) avg_amount, 
        ROUND(AVG(total_price-total_amount), 1) avg_cost
FROM (
    SELECT order_id, uid, total_amount, event_time,
            MIN(event_time) OVER(PARTITION BY uid) first_event_time
    FROM tb_order_overall
) T1
INNER JOIN (
    SELECT order_id, SUM(price*cnt) total_price
    FROM tb_order_detail
    GROUP BY order_id
) T2 ON DATE_FORMAT(first_event_time, '%Y-%m') = '2021-10' 
        AND event_time = first_event_time
        AND T2.order_id = T1.order_id 

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
  (8001, 901, '日用', 60, 1000, '2020-01-01 10:00:00'),
  (8002, 901, '零食', 140, 500, '2020-01-01 10:00:00'),
  (8003, 901, '零食', 160, 500, '2020-01-01 10:00:00'),
  (8004, 902, '零食', 130, 500, '2020-01-01 10:00:00');

INSERT INTO tb_order_overall(order_id, uid, event_time, total_amount, total_cnt, `status`) VALUES
  (301002, 102, '2021-10-01 11:00:00', 235, 2, 1),
  (301003, 101, '2021-10-02 10:00:00', 300, 2, 1),
  (301005, 104, '2021-10-03 10:00:00', 160, 1, 1);

INSERT INTO tb_order_detail(order_id, product_id, price, cnt) VALUES
  (301002, 8001, 85, 1),
  (301002, 8003, 180, 1),
  (301003, 8004, 140, 1),
  (301003, 8003, 180, 1),
  (301005, 8003, 180, 1);