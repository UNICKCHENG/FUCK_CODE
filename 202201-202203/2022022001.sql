-- 链接 LINK: https://www.nowcoder.com/practice/34f88f6d6dc549f6bc732eb2128aa338?tpId=268&tqId=2300010&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL23 工作日各时段叫车量、等待接单时间和调度时间
-- 日期 DATE: 2022-02-20 10:38:21

/* NOTE
    * TIMESTAMPDIFF 计算两时间差多少分钟，不能精确到小数，需要进行四则运算
    * DISTINCT 会自动排序，影响表的原有顺序。e.g. 将叫车量计算改为  COUNT(DISTINCT T1.order_id)
 **/
-- 题解 SQL
SELECT T1.period
        # 叫车量. 仅计算成功叫到车（叫到车后取消也算成功）
        , COUNT(T1.order_id) get_car_num
        # 平均等待接单时间
        , ROUND(AVG(TIMESTAMPDIFF(SECOND, T1.event_time, T2.order_time)/60.0), 1) avg_wait_time
        # 平均调度时间 仅计算完成了的订单（条件 finish_time 和 start_time 都不为 NULL）
        , ROUND(
            SUM(IF(finish_time IS NULL OR start_time IS NULL, 0, TIMESTAMPDIFF(SECOND, T2.order_time, T2.start_time)/60.0)) 
            /SUM(IF(finish_time IS NULL OR start_time IS NULL, 0, 1)), 1) avg_dispatch_time
FROM (
    SELECT order_id, event_time, (CASE 
            WHEN '07:00:00' <= TIME(event_time) AND TIME(event_time) < '09:00:00' THEN '早高峰'
            WHEN '09:00:00' <= TIME(event_time) AND TIME(event_time) < '17:00:00' THEN '工作时间'
            WHEN '17:00:00' <= TIME(event_time) AND TIME(event_time) < '20:00:00' THEN '晚高峰'
            ELSE '休息时间' END) period
    FROM tb_get_car_record
    WHERE DATE_FORMAT(event_time,'%w') BETWEEN 1 and 5
) T1
INNER JOIN tb_get_car_order T2 ON T2.order_id = T1.order_id
GROUP BY period
ORDER BY get_car_num
;



-- 数据 DATA ===================================================
DROP TABLE IF EXISTS tb_get_car_record,tb_get_car_order;
CREATE TABLE tb_get_car_record (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
uid INT NOT NULL COMMENT '用户ID',
city VARCHAR(10) NOT NULL COMMENT '城市',
event_time datetime COMMENT '打车时间',
end_time datetime COMMENT '打车结束时间',
order_id INT COMMENT '订单号'
) CHARACTER SET utf8 COLLATE utf8_bin;

CREATE TABLE tb_get_car_order (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
order_id INT NOT NULL COMMENT '订单号',
uid INT NOT NULL COMMENT '用户ID',
driver_id INT NOT NULL COMMENT '司机ID',
order_time datetime COMMENT '接单时间',
start_time datetime COMMENT '开始计费的上车时间',
finish_time datetime COMMENT '订单结束时间',
mileage FLOAT COMMENT '行驶里程数',
fare FLOAT COMMENT '费用',
grade TINYINT COMMENT '评分'
) CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_get_car_record(uid, city, event_time, end_time, order_id) VALUES
(102, '北京', '2021-09-25 09:00:30', '2021-09-25 09:01:00', 9012),
(103, '北京', '2021-09-26 07:59:00', '2021-09-26 08:01:00', 9013),
(104, '北京', '2021-09-27 07:59:00', '2021-09-27 08:01:00', 9023),
(107, '北京', '2021-09-20 11:00:00', '2021-09-20 11:00:30', 9017),
(108, '北京', '2021-09-20 21:00:00', '2021-09-20 21:00:40', 9008),
(108, '北京', '2021-09-20 18:59:30', '2021-09-20 19:01:00', 9018),
(102, '北京', '2021-09-21 08:59:00', '2021-09-21 09:01:00', 9002),
(106, '北京', '2021-09-21 17:58:00', '2021-09-21 18:01:00', 9006),
(103, '北京', '2021-09-22 07:58:00', '2021-09-22 08:01:00', 9003),
(104, '北京', '2021-09-23 07:59:00', '2021-09-23 08:01:00', 9004),
(103, '北京', '2021-09-24 19:59:20', '2021-09-24 20:01:00', 9019),
(101, '北京', '2021-09-24 08:28:10', '2021-09-24 08:30:00', 9011);

INSERT INTO tb_get_car_order(order_id, uid, driver_id, order_time, start_time, finish_time, mileage, fare, grade) VALUES
(9017, 107, 213, '2021-09-20 11:00:30', '2021-09-20 11:02:10', '2021-09-20 11:31:00', 11, 38, 5),
(9018, 108, 214, '2021-09-20 19:01:00', '2021-09-20 19:04:50', '2021-09-20 19:21:00', 14, 38, 5),
(9002, 102, 202, '2021-09-21 09:01:00', '2021-09-21 09:06:00', '2021-09-21 09:31:00', 10.0, 41.5, 5),
(9006, 106, 203, '2021-09-21 18:01:00', '2021-09-21 18:09:00', '2021-09-21 18:31:00', 8.0, 25.5, 4),
(9007, 107, 203, '2021-09-22 11:01:00', '2021-09-22 11:07:00', '2021-09-22 11:31:00', 9.9, 30, 5),
(9008, 108, 204, '2021-09-20 21:00:40', '2021-09-20 21:03:00', '2021-09-20 21:31:00', 13.2, 38, 4),
(9003, 103, 202, '2021-09-22 08:01:00', '2021-09-22 08:15:00', '2021-09-22 08:31:00', 11.0, 41.5, 4),
(9004, 104, 202, '2021-09-23 08:01:00', '2021-09-23 08:13:00', '2021-09-23 08:31:00', 7.5, 22, 4),
(9005, 105, 202, '2021-09-23 10:01:00', '2021-09-23 10:13:00', '2021-09-23 10:31:00', 9, 29, 5),
(9019, 103, 202, '2021-09-24 20:01:00', '2021-09-24 20:11:00', '2021-09-24 20:51:00', 10, 39, 4),
(9011, 101, 211, '2021-09-24 08:30:00', '2021-09-24 08:31:00', '2021-09-24 08:54:00', 10, 35, 5),
(9012, 102, 211, '2021-09-25 09:01:00', '2021-09-25 09:01:50', '2021-09-25 09:28:00', 11, 32, 5),
(9013, 103, 212, '2021-09-26 08:01:00', '2021-09-26 08:03:00', '2021-09-26 08:27:00', 12, 31, 4),
(9023, 104, 213, '2021-09-27 08:01:00', null, '2021-09-27 08:27:00', null, null, null);