-- 链接 LINK: https://www.nowcoder.com/practice/aef5adcef574468c82659e8911bb297f?tpId=268&tqId=2285347&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL12 连续签到领金币
-- 日期 DATE: 2022-01-30 16:34:42

-- 题解 SQL CASE 1
SELECT uid, DATE_FORMAT(dt, '%Y%m') month, 
        SUM(CASE cnt 
                WHEN 3 THEN 3
                WHEN 7 THEN 7
                ELSE 1 END) coin
FROM (
    -- 每名用户连续签到情况, cnt 表示已经连续签到次数, last_day 表示连续签到前一次日期
    SELECT
            (CASE WHEN T1.uid = @uid AND TIMESTAMPDIFF(day, @last_day, T1.dt) = 1 THEN @cnt := @cnt % 7 + 1 ELSE @cnt := 1 END) cnt,
            (CASE WHEN T1.uid = @uid AND TIMESTAMPDIFF(day, @last_day, T1.dt) = 1 THEN @last_day ELSE '' END) last_day,
            (@last_day := T1.dt) dt,
            (CASE WHEN T1.uid = @uid THEN @uid ELSE @uid := T1.uid END) uid
    FROM (
        -- 源数据格式调整和数据去重
        SELECT uid, DATE_FORMAT(in_time, '%Y-%m-%d') dt
        FROM tb_user_log
        WHERE DATE_FORMAT(in_time, '%Y-%m-%d') BETWEEN '2021-07-07' AND '2021-10-31' 
                AND artical_id = 0 AND sign_in = 1
        GROUP BY uid, dt
        ORDER BY uid, dt
    ) T1, (SELECT @uid:=0, @cnt:=1, @last_day:='') T2
) TA
GROUP BY uid, month
ORDER BY month, uid
;

-- 题解 SQL CASE 2
SELECT uid, DATE_FORMAT(dt, '%Y%m') month, 
        SUM(CASE cnt 
                WHEN 3 THEN 3
                WHEN 7 THEN 7
                ELSE 1 END) coin
FROM (
    -- 每名用户连续签到情况, cnt 表示已经连续签到次数. 核心思想: 日期(dt)减去序号(ranks), 相等的值表示连续签到
    SELECT uid, dt,
            (ROW_NUMBER() OVER(PARTITION BY uid, DATE_SUB(dt, interval ranks day) ORDER BY dt) - 1)%7+1 cnt
    FROM (
        -- 源数据格式调整和数据去重
        SELECT uid, DATE_FORMAT(in_time, '%Y-%m-%d') dt,
                ROW_NUMBER() OVER(PARTITION BY uid ORDER BY DATE_FORMAT(in_time, '%Y-%m-%d')) ranks
        FROM tb_user_log
        WHERE DATE_FORMAT(in_time, '%Y-%m-%d') BETWEEN '2021-07-07' AND '2021-10-31' 
                AND artical_id = 0 AND sign_in = 1
        GROUP BY uid, DATE_FORMAT(in_time, '%Y-%m-%d')
        ORDER BY uid, dt
    ) T1
) TA
GROUP BY uid, month
ORDER BY month, uid
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
  (101, 0, '2021-07-07 10:00:00', '2021-07-07 10:00:09', 1),
  (101, 0, '2021-07-08 10:00:00', '2021-07-08 10:00:09', 1),
  (101, 0, '2021-07-09 10:00:00', '2021-07-09 10:00:42', 1),
  (101, 0, '2021-07-10 10:00:00', '2021-07-10 10:00:09', 1),
  (101, 0, '2021-07-11 23:59:55', '2021-07-11 23:59:59', 1),
  (101, 0, '2021-07-12 10:00:28', '2021-07-12 10:00:50', 1),
  (101, 0, '2021-07-13 10:00:28', '2021-07-13 10:00:50', 1),
  (102, 0, '2021-10-01 10:00:28', '2021-10-01 10:00:50', 1),
  (102, 0, '2021-10-02 10:00:01', '2021-10-02 10:01:50', 1),
  (102, 0, '2021-10-03 11:00:55', '2021-10-03 11:00:59', 1),
  (102, 0, '2021-10-04 11:00:45', '2021-10-04 11:00:55', 0),
  (102, 0, '2021-10-05 11:00:53', '2021-10-05 11:00:59', 1),
  (102, 0, '2021-10-06 11:00:45', '2021-10-06 11:00:55', 1);