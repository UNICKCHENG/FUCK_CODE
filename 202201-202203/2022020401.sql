-- 链接 LINK: https://www.nowcoder.com/practice/2b330aa6cc994ec2a988704a078a0703?tpId=268&tqId=2299819&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL22 国庆期间近7日日均取消订单量
-- 日期 DATE: 2022-02-04 08:19:05

-- 题解 SQL
SELECT dt, finish_num_7d, CANCEL_num_7d
FROM (
    SELECT T1.dt,
            ROUND(AVG(finish_cnt) OVER(ORDER BY T1.dt ROWS 6 PRECEDING), 2) finish_num_7d,
            ROUND(AVG(cancel_cnt) OVER(ORDER BY T1.dt ROWS 6 PRECEDING), 2) CANCEL_num_7d
    FROM (
        -- 补全从 2021-09-25 - 2021-10-03 全部日期, 避免数据表中缺失部分天数的数据
        SELECT (@start_date := TIMESTAMPADD(day, 1, @start_date)) dt
        FROM information_schema.tables, (SELECT @start_date:= '2021-09-24') T
        LIMIT 9
    ) T1
    LEFT JOIN (
        -- 数据表中按日期分组, 计算每天取消单数和完成单数
        SELECT DATE_FORMAT(order_time, '%Y-%m-%d') dt,
                SUM(CASE WHEN start_time IS NULL THEN 1 ELSE 0 END) cancel_cnt,
                SUM(CASE WHEN start_time IS NOT NULL THEN 1 ELSE 0 END) finish_cnt
        FROM tb_get_car_order
        WHERE DATE_FORMAT(order_time, '%Y-%m-%d') BETWEEN '2021-09-25' AND '2021-10-03' AND finish_time IS NOT NULL
        GROUP BY dt
    ) T2 ON T2.dt = T1.dt
) TA
WHERE dt BETWEEN '2021-10-01' AND '2021-10-03'

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
 (101, '北京', '2021-09-25 08:28:10', '2021-09-25 08:30:00', 9011),
 (102, '北京', '2021-09-25 09:00:30', '2021-09-25 09:01:00', 9012),
 (103, '北京', '2021-09-26 07:59:00', '2021-09-26 08:01:00', 9013),
 (104, '北京', '2021-09-26 07:59:00', '2021-09-26 08:01:00', 9023),
 (104, '北京', '2021-09-27 07:59:20', '2021-09-27 08:01:00', 9014),
 (105, '北京', '2021-09-28 08:00:00', '2021-09-28 08:02:10', 9015),
 (106, '北京', '2021-09-29 17:58:00', '2021-09-29 18:01:00', 9016),
 (107, '北京', '2021-09-30 11:00:00', '2021-09-30 11:01:00', 9017),
 (108, '北京', '2021-09-30 21:00:00', '2021-09-30 21:01:00', 9018),
 (102, '北京', '2021-10-01 09:00:30', '2021-10-01 09:01:00', 9002),
 (106, '北京', '2021-10-01 17:58:00', '2021-10-01 18:01:00', 9006),
 (101, '北京', '2021-10-02 08:28:10', '2021-10-02 08:30:00', 9001),
 (107, '北京', '2021-10-02 11:00:00', '2021-10-02 11:01:00', 9007),
 (108, '北京', '2021-10-02 21:00:00', '2021-10-02 21:01:00', 9008),
 (103, '北京', '2021-10-02 07:59:00', '2021-10-02 08:01:00', 9003),
 (104, '北京', '2021-10-03 07:59:20', '2021-10-03 08:01:00', 9004),
 (109, '北京', '2021-10-03 18:00:00', '2021-10-03 18:01:00', 9009);

INSERT INTO tb_get_car_order(order_id, uid, driver_id, order_time, start_time, finish_time, mileage, fare, grade) VALUES
 (9011, 101, 211, '2021-09-25 08:30:00', '2021-09-25 08:31:00', '2021-09-25 08:54:00', 10, 35, 5),
 (9012, 102, 211, '2021-09-25 09:01:00', '2021-09-25 09:01:50', '2021-09-25 09:28:00', 11, 32, 5),
 (9013, 103, 212, '2021-09-26 08:01:00', '2021-09-26 08:03:00', '2021-09-26 08:27:00', 12, 31, 4),
 (9023, 104, 213, '2021-09-26 08:01:00', null, '2021-09-26 08:27:00', null, null, null),
 (9014, 104, 212, '2021-09-27 08:01:00', '2021-09-27 08:04:00', '2021-09-27 08:21:00', 11, 31, 5),
 (9015, 105, 212, '2021-09-28 08:02:10', '2021-09-28 08:04:10', '2021-09-28 08:25:10', 12, 31, 4),
 (9016, 106, 213, '2021-09-29 18:01:00', '2021-09-29 18:02:10', '2021-09-29 18:23:00', 11, 39, 4),
 (9017, 107, 213, '2021-09-30 11:01:00', '2021-09-30 11:01:40', '2021-09-30 11:31:00', 11, 38, 5),
 (9018, 108, 214, '2021-09-30 21:01:00', '2021-09-30 21:02:50', '2021-09-30 21:21:00', 14, 38, 5),
 (9002, 102, 202, '2021-10-01 09:01:00', '2021-10-01 09:06:00', '2021-10-01 09:31:00', 10.0, 41.5, 5),
 (9006, 106, 203, '2021-10-01 18:01:00', '2021-10-01 18:09:00', '2021-10-01 18:31:00', 8.0, 25.5, 4),
 (9001, 101, 202, '2021-10-02 08:30:00', null, '2021-10-02 08:31:00', null, null, null),
 (9007, 107, 203, '2021-10-02 11:01:00', '2021-10-02 11:07:00', '2021-10-02 11:31:00', 9.9, 30, 5),
 (9008, 108, 204, '2021-10-02 21:01:00', '2021-10-02 21:10:00', '2021-10-02 21:31:00', 13.2, 38, 4),
 (9003, 103, 202, '2021-10-02 08:01:00', '2021-10-02 08:15:00', '2021-10-02 08:31:00', 11.0, 41.5, 4),
 (9004, 104, 202, '2021-10-03 08:01:00', '2021-10-03 08:13:00', '2021-10-03 08:31:00', 7.5, 22, 4),
 (9009, 109, 204, '2021-10-03 18:01:00', null, '2021-10-03 18:51:00', null, null, null);