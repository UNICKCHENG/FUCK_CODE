-- 链接 LINK: https://www.nowcoder.com/practice/6765b4a4f260455bae513a60b6eed0af?tpId=268&tqId=2285345&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj%3Ftab%3DSQL%25E7%25AF%2587%26topicId%3D268
-- 标题 TITLE: SQL10 统计活跃间隔对用户分级结果
-- 日期 DATE: 2022-01-24 08:31:44 

/* NOTE 让表基于已有数据来新增列的方法(常见)
- group by 
- windows function
- join
- string split
**/

-- 题解 SQL CASE 1
SELECT T1.user_grade, 
        (CASE WHEN T2.num IS NULL THEN 0 ELSE ROUND(T2.num / SUM(T2.num) OVER(), 2) END) ratio
FROM (
    -- 字典，用户等级名称及其对应的编码
    SELECT '忠实用户' user_grade, 1 code
    UNION
    SELECT '新晋用户' user_grade, 0 code
    UNION
    SELECT '沉睡用户' user_grade, 2 code
    UNION
    SELECT '流失用户' user_grade, 3 code
) T1
LEFT JOIN (
    -- 统计每个编码值有多少位用户
    SELECT (CASE WHEN code >= 10 THEN 0 ELSE code END) code,
            COUNT(1) num
    FROM (
        -- 编码用户，且每名用户仅有一条编码数据，编码值对应用户等级
        SELECT uid, SUM(CASE 
                    WHEN ranks = 1 AND timediff < 7 THEN 10
                    WHEN ranks = num AND timediff < 7 THEN 1
                    WHEN ranks = num AND timediff < 30 THEN 2
                    WHEN ranks = num THEN 3
                    ELSE 0 END) code
        FROM (
            SELECT uid, time, 
                    TIMESTAMPDIFF(day, time, MAX(time) OVER()) timediff,
                    row_number() OVER(PARTITION BY uid ORDER BY time) ranks, 
                    COUNT(1) OVER(PARTITION BY uid) num
            FROM (
                SELECT uid, DATE_FORMAT(in_time, '%Y-%m-%d') time FROM tb_user_log
                UNION
                SELECT uid, DATE_FORMAT(out_time, '%Y-%m-%d') time FROM tb_user_log
            ) TA
            GROUP BY uid, time
        ) TB
        -- 找到每名用户最早的注册时间和最新的活跃时间
        WHERE ranks = 1 OR ranks = num
        GROUP BY uid
    ) TC
    GROUP BY (CASE WHEN code >= 10 THEN 0 ELSE code END) 
) T2 ON T2.code = T1.code 
;

-- 题解 SQL CASE 2
SELECT T1.user_grade, 
        (CASE WHEN T2.num IS NULL THEN 0 ELSE ROUND(T2.num / SUM(T2.num) OVER(), 2) END) ratio
FROM (
    -- 字典，用户等级名称及其对应的编码,
    SELECT '忠实用户' user_grade, 1 code
    UNION
    SELECT '新晋用户' user_grade, 0 code
    UNION
    SELECT '沉睡用户' user_grade, 2 code
    UNION
    SELECT '流失用户' user_grade, 3 code
) T1
LEFT JOIN (
    SELECT code, COUNT(1) num
    FROM (
        SELECT uid,
            (CASE 
                WHEN MAX(timediff) < 7 THEN 0
                WHEN MIN(timediff) < 7 THEN 1
                WHEN MIN(timediff) < 30 THEN 2
            ELSE 3 END) code 
        FROM (
            SELECT uid,
                    TIMESTAMPDIFF(day, time, MAX(time) OVER()) timediff
            FROM (
                SELECT uid, DATE_FORMAT(in_time, '%Y-%m-%d') time FROM tb_user_log
                UNION
                SELECT uid, DATE_FORMAT(out_time, '%Y-%m-%d') time FROM tb_user_log
            ) TA
            GROUP BY uid, time
        ) TB
        GROUP BY uid
    ) TC
    GROUP BY code
) T2 ON T2.code = T1.code
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

-- 最新日期为 2021-11-04
INSERT INTO tb_user_log(uid, artical_id, in_time, out_time, sign_in) VALUES
  (109, 9001, '2021-08-31 10:00:00', '2021-08-31 10:00:09', 0),
  (109, 9002, '2021-11-04 11:00:55', '2021-11-04 11:00:59', 0),
  (108, 9001, '2021-09-01 10:00:01', '2021-09-01 10:01:50', 0),
  (108, 9001, '2021-11-03 10:00:01', '2021-11-03 10:01:50', 0),
  (104, 9001, '2021-11-02 10:00:28', '2021-11-02 10:00:50', 0),
  (104, 9003, '2021-09-03 11:00:45', '2021-09-03 11:00:55', 0),
  (105, 9003, '2021-11-03 11:00:53', '2021-11-03 11:00:59', 0),
  (102, 9001, '2021-10-30 10:00:00', '2021-10-30 10:00:09', 0),
  (103, 9001, '2021-10-21 10:00:00', '2021-10-21 10:00:09', 0),
--   (101, 9001, '2021-10-01 10:00:00', '2021-10-01 10:00:42', 1),
  (110, 0, '2021-11-01 10:00:00', '2021-11-01 10:00:42', 1),
  (110, 9001, '2021-11-03 10:00:00', '2021-11-03 10:00:42', 1),
  (110, 9001, '2021-11-02 00:00:00', '2021-11-03 00:00:42', 1),
  (111, 9001, '2021-05-01 10:00:00', '2021-05-01 10:00:42', 1),
  (111, 9002, '2021-10-04 11:00:55', '2021-10-04 11:00:59', 0),
  (111, 9002, '2021-10-28 10:00:00', '2021-10-28 10:00:42', 0),
  (112, 9002, '2021-11-03 00:00:00', '2021-11-04 00:00:42', 0),
  (113, 9002, '2021-10-05 00:00:00', '2021-10-06 00:00:42', 0),
  (113, 9002, '2021-11-03 00:00:00', '2021-11-04 00:00:42', 0),
  (114, 9002, '2021-10-05 00:00:00', '2021-10-06 00:00:42', 0),
  (114, 9002, '2021-11-03 00:00:00', '2021-11-04 00:00:42', 0),
  (115, 9002, '2021-05-06 00:00:00', '2021-05-06 00:00:42', 0),
  (115, 9002, '2021-10-28 10:00:00', '2021-10-28 10:00:42', 0);
