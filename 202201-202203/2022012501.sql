-- 链接 LINK: https://www.nowcoder.com/practice/dbbc9b03794a48f6b34f1131b1a903eb?tpId=268&tqId=2285346&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL11 每天的日活数及新用户占比
-- 日期 DATE: 2022-01-25 10:32:35

-- 题解 SQL
SELECT time dt, COUNT(uid) dau,
       ROUND(SUM(CASE WHEN time = min_time THEN 1 ELSE 0 END)/COUNT(1), 2) uv_new_ratio
FROM (
    SELECT uid, time, min(time) OVER(PARTITION BY uid) min_time
    FROM (
        SELECT uid, DATE_FORMAT(in_time, '%Y-%m-%d') time FROM tb_user_log
        UNION
        SELECT uid, DATE_FORMAT(out_time, '%Y-%m-%d') time FROM tb_user_log
    ) TA
    GROUP BY uid, time
) TB
GROUP BY time
ORDER BY dt
;



-- 数据 DATA ===================================================
DROP TABLE IF EXISTS tb_user_log;
CREATE TABLE tb_user_log (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    uid INT NOT NULL COMMENT '用户ID',
    artical_id INT NOT NULL COMMENT '视频ID',
    in_time datetime COMMENT '进入时间',
    out_time datetime COMMENT '离开时间',
    sign_in TINYINT DEFAULT 0 COMMENT '是否签到'
) CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_user_log(uid, artical_id, in_time, out_time, sign_in) VALUES
  (101, 9001, '2021-10-31 10:00:00', '2021-10-31 10:00:09', 0),
  (102, 9001, '2021-10-31 10:00:00', '2021-10-31 10:00:09', 0),
  (101, 0, '2021-11-01 10:00:00', '2021-11-01 10:00:42', 1),
  (102, 9001, '2021-11-01 10:00:00', '2021-11-01 10:00:09', 0),
  (108, 9001, '2021-11-01 10:00:01', '2021-11-01 10:01:50', 0),
  (108, 9001, '2021-11-02 10:00:01', '2021-11-02 10:01:50', 0),
  (104, 9001, '2021-11-02 10:00:28', '2021-11-02 10:00:50', 0),
  (106, 9001, '2021-11-02 10:00:28', '2021-11-02 10:00:50', 0),
  (108, 9001, '2021-11-03 10:00:01', '2021-11-03 10:01:50', 0),
  (109, 9002, '2021-11-03 11:00:55', '2021-11-03 11:00:59', 0),
  (104, 9003, '2021-11-03 11:00:45', '2021-11-03 11:00:55', 0),
  (105, 9003, '2021-11-03 11:00:53', '2021-11-03 11:00:59', 0),
  (106, 9003, '2021-11-03 11:00:45', '2021-11-03 11:00:55', 0);