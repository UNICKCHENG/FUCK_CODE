-- 链接 LINK: https://www.nowcoder.com/practice/d337c95650f640cca29c85201aecff84?tpId=268&tqId=2285069&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL4 每个创作者每月的涨粉率及截止当前的总粉丝量
-- 日期 DATE: 2022-01-30 10:15:26

-- 题解 SQL CASE 1
SELECT author, month, fans_growth_rate, SUM(fans) OVER(PARTITION BY author ORDER BY month) total_fans
FROM (
    SELECT T2.author, T1.month, 
            ROUND(SUM(CASE T1.if_follow WHEN 1 THEN 1 WHEN 2 THEN -1 ELSE 0 END)/COUNT(1), 3) fans_growth_rate,
            SUM(CASE T1.if_follow WHEN 1 THEN 1 WHEN 2 THEN -1 ELSE 0 END) fans
    FROM (
        SELECT uid, video_id, DATE_FORMAT(end_time, '%Y-%m') month, if_follow
        FROM tb_user_video_log
        WHERE YEAR(end_time) = 2021
        ) T1
    INNER JOIN (
        SELECT author, video_id FROM tb_video_info
        ) T2 ON T2.video_id = T1.video_id
    GROUP BY T2.author, T1.month
) TMP
ORDER BY author, total_fans
;

-- 题解 SQL CASE 2

SELECT author, month, fans_growth_rate, SUM(fans) OVER(PARTITION BY author ORDER BY month) total_fans
FROM (
    SELECT T2.author, T1.month, 
            ROUND(SUM(fans)/SUM(view), 3) fans_growth_rate,
            SUM(fans) fans
    FROM (
        -- 每条视频在2021每月的涨粉量和播放量
        SELECT video_id, DATE_FORMAT(end_time, '%Y-%m') month, 
                SUM(CASE if_follow WHEN 1 THEN 1 WHEN 2 THEN -1 ELSE 0 END) fans,
                COUNT(1) view
        FROM tb_user_video_log
        WHERE YEAR(end_time) = 2021
        GROUP BY video_id, month
        ) T1
    INNER JOIN (
        SELECT author, video_id FROM tb_video_info
        ) T2 ON T2.video_id = T1.video_id
    GROUP BY T2.author, T1.month
) TMP
ORDER BY author, total_fans
;


-- 数据 DATA ===================================================

DROP TABLE IF EXISTS tb_user_video_log, tb_video_info;
CREATE TABLE tb_user_video_log (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    uid INT NOT NULL COMMENT '用户ID',
    video_id INT NOT NULL COMMENT '视频ID',
    start_time datetime COMMENT '开始观看时间',
    end_time datetime COMMENT '结束观看时间',
    if_follow TINYINT COMMENT '是否关注',
    if_like TINYINT COMMENT '是否点赞',
    if_retweet TINYINT COMMENT '是否转发',
    comment_id INT COMMENT '评论ID'
) CHARACTER SET utf8 COLLATE utf8_bin;

CREATE TABLE tb_video_info (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    video_id INT UNIQUE NOT NULL COMMENT '视频ID',
    author INT NOT NULL COMMENT '创作者ID',
    tag VARCHAR(16) NOT NULL COMMENT '类别标签',
    duration INT NOT NULL COMMENT '视频时长(秒数)',
    release_time datetime NOT NULL COMMENT '发布时间'
)CHARACTER SET utf8 COLLATE utf8_bin;

INSERT INTO tb_user_video_log(uid, video_id, start_time, end_time, if_follow, if_like, if_retweet, comment_id) VALUES
   (101, 2001, '2021-09-01 10:00:00', '2021-09-01 10:00:20', 0, 1, 1, null)
  ,(105, 2002, '2021-09-10 11:00:00', '2021-09-10 11:00:30', 1, 0, 1, null)
  ,(101, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:20', 1, 1, 1, null)
  ,(102, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:15', 0, 0, 1, null)
  ,(103, 2001, '2021-10-01 11:00:50', '2021-10-01 11:01:15', 1, 1, 0, 1732526)
  ,(106, 2002, '2021-10-01 10:59:05', '2021-10-01 11:00:05', 2, 0, 0, null);

INSERT INTO tb_video_info(video_id, author, tag, duration, release_time) VALUES
   (2001, 901, '影视', 30, '2021-01-01 7:00:00')
  ,(2002, 901, '影视', 60, '2021-01-01 7:00:00')
  ,(2003, 902, '旅游', 90, '2020-01-01 7:00:00')
  ,(2004, 902, '美女', 90, '2020-01-01 8:00:00');