-- 链接 LINK: https://www.nowcoder.com/practice/f301eccab83c42ab8dab80f28a1eef98?tpId=268&tqId=2300011&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj%3Ftab%3DSQL%25E7%25AF%2587%26topicId%3D268
-- 标题 TITLE: SQL24 各城市最大同时等车人数
-- 日期 DATE: 2022-02-26 09:10:48

/* NOTE 遇到时间相同时，窗口函数逐行求和容易犯错
-- 错误写法
SUM(tag) OVER(PARTITION BY city, DATE_FORMAT(time, '%Y-%m-%d') ORDER BY time) wait_uv

-- 正确写法 
SUM(tag) OVER(PARTITION BY city, DATE_FORMAT(time, '%Y-%m-%d') ORDER BY time, tag DESC) wait_uv
-- 题目描述中会有一段描述，如「如果同一时刻有人登出，也有人登入，则人数记作先增加后减少」
 **/

-- 题解 SQL
SELECT city, MAX(wait_uv) max_wait_uv
FROM (
    SELECT city, DATE_FORMAT(time, '%Y-%m-%d') dt, time,
            SUM(tag) OVER(PARTITION BY city, DATE_FORMAT(time, '%Y-%m-%d') ORDER BY time, tag DESC) wait_uv
    FROM (
        -- 开始打车时间(等车接单)
        SELECT T1.city, T1.event_time time, 1 tag
        FROM tb_get_car_record T1
        WHERE DATE_FORMAT(event_time, '%Y-%m') = '2021-10'
        -- 结束等车时间(上车或取消), 特殊情况: 司机已接单正在赶往中
        UNION ALL
        SELECT T2.city,
                ( CASE WHEN T2.order_id IS NULL THEN end_time                                   -- 未接单前取消/等待司机接单中
                        WHEN start_time IS NULL AND finish_time IS NOT NULL THEN finish_time    -- 已经接单且未上车前取消
                        WHEN start_time IS NOT NULL THEN start_time                             -- 接单成功且上车           
                ELSE NOW() END                                                                  -- 司机已接单正在赶往中
                ) time, 
                -1 tag
        FROM (
            -- 两种状态：还在流程中(等待接单中), 结束了流程(取消或成功接单)
            SELECT city, event_time, IFNULL(end_time, NOW()) end_time, order_id 
            FROM tb_get_car_record 
            WHERE DATE_FORMAT(event_time, '%Y-%m') = '2021-10'
        ) T2
        LEFT JOIN (
            -- 三种状态：已经接单未上车、已接单被取消、完成接单
            SELECT order_id, start_time, finish_time FROM tb_get_car_order 
            WHERE DATE_FORMAT(order_time, '%Y-%m') = '2021-10'
        ) T3 ON T2.order_id = T3.order_id
    ) TA
    WHERE DATE_FORMAT(time, '%Y-%m') = '2021-10'
    ORDER BY time
) TB
GROUP BY city, dt
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
(108, '北京', '2021-10-20 08:00:00', '2021-10-20 08:00:40', 9008),
(118, '北京', '2021-10-20 08:00:10', '2021-10-20 08:00:45', 9018),
(102, '北京', '2021-10-20 08:00:30', '2021-10-20 08:00:50', 9002),
(106, '北京', '2021-10-20 08:05:41', '2021-10-20 08:06:00', 9006),
(103, '北京', '2021-10-20 08:05:50', '2021-10-20 08:07:10', 9003),
(104, '北京', '2021-10-20 08:01:01', '2021-10-20 08:01:20', 9004),
(105, '北京', '2021-10-20 08:01:15', '2021-10-20 08:01:30', 9019),
(101, '北京', '2021-10-20 08:28:10', '2021-10-20 08:30:00', 9011);

INSERT INTO tb_get_car_order(order_id, uid, driver_id, order_time, start_time, finish_time, mileage, fare, grade) VALUES
(9008, 108, 204, '2021-10-20 08:00:40', '2021-10-20 08:03:00', '2021-10-20 08:31:00', 13.2, 38, 4),
(9018, 118, 214, '2021-10-20 08:00:45', '2021-10-20 08:05:50', '2021-10-20 08:21:00', 14, 38, 5),
(9002, 102, 202, '2021-10-20 08:00:50', '2021-10-20 08:06:00', '2021-10-20 08:31:00', 10.0, 41.5, 5),
(9006, 106, 206, '2021-10-20 08:06:00', '2021-10-20 08:09:00', '2021-10-20 08:31:00', 8.0, 25.5, 4),
(9003, 103, 203, '2021-10-20 08:07:10', '2021-10-20 08:15:00', '2021-10-20 08:31:00', 11.0, 41.5, 4),
(9004, 104, 204, '2021-10-20 08:01:20', '2021-10-20 08:13:00', '2021-10-20 08:31:00', 7.5, 22, 4),
(9019, 105, 205, '2021-10-20 08:01:30', '2021-10-20 08:11:00', '2021-10-20 08:51:00', 10, 39, 4),
(9011, 101, 211, '2021-10-20 08:30:00', '2021-10-20 08:31:00', '2021-10-20 08:54:00', 10, 35, 5);