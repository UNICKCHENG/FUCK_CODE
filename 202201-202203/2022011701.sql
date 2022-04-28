-- 链接:https://www.nowcoder.com/practice/cbf582d28b794722becfc680847327be?tpId=268&tqId=2285516&ru=/activity/oj&qru=/ta/sql-factory-interview/question-ranking
-- 标题:SQL14 统计2021年10月每个退货率不大于0.5的商品各项指标

/* NOTE 空值或者zero值作为分母
空值或者zero值作为分母, 返回 NULL
在处理商和取余问题上，要考虑分母为0的情况
注: NULL 值与任何值做四则运算都为 NULL
**/

-- 题解 SQL
SELECT product_id, 
    ROUND(IF(count(1) = 0, 0, sum(if_click)/count(1)), 3) AS ctr, 
    ROUND(IF(sum(if_click) = 0, 0, sum(if_cart)/sum(if_click)), 3) AS cart_rate,
    ROUND(IF(sum(if_cart) = 0, 0, sum(if_payment)/sum(if_cart)), 3) AS payment_rate, 
    ROUND(IF(sum(if_payment) = 0, 0, sum(if_refund)/sum(if_payment)), 3) AS refund_rate
FROM tb_user_event 
WHERE DATE_FORMAT(event_time, '%Y-%m') = "2021-10"
GROUP BY product_id
HAVING refund_rate <= 0.5
ORDER BY product_id;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS tb_user_event;
CREATE TABLE tb_user_event (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    uid INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    event_time datetime COMMENT '行为时间',
    if_click TINYINT COMMENT '是否点击',
    if_cart TINYINT COMMENT '是否加购物车',
    if_payment TINYINT COMMENT '是否付款',
    if_refund TINYINT COMMENT '是否退货退款'
) CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_user_event(uid, product_id, event_time, if_click, if_cart, if_payment, if_refund) VALUES
  (101, 8001, '2021-10-01 10:00:00', 0, 0, 0, 0),
  (102, 8001, '2021-10-01 10:00:00', 1, 0, 0, 0),
  (103, 8001, '2021-10-01 10:00:00', 1, 1, 0, 0),
  (104, 8001, '2021-10-02 10:00:00', 1, 1, 1, 0),
  (105, 8001, '2021-10-02 10:00:00', 1, 1, 1, 0),
  (101, 8002, '2021-10-03 10:00:00', 1, 1, 1, 0),
  (109, 8001, '2021-10-04 10:00:00', 1, 1, 1, 1);

