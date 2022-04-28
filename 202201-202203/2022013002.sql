-- 链接 LINK: https://www.nowcoder.com/practice/f90ce4ee521f400db741486209914a11?tpId=268&tqId=2285070&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL5 国庆期间每类视频点赞量和转发量
-- 日期 DATE: 2022-01-30 14:50:11

-- 题解 SQL CASE 1
SELECT tag, dt, 
        (CASE dt 
            WHEN '2021-10-01' THEN like_cnt_1
            WHEN '2021-10-02' THEN like_cnt_2
            WHEN '2021-10-03' THEN like_cnt_3 
            ELSE 0 END) sum_like_cnt_7d,
        (CASE dt 
            WHEN '2021-10-01' THEN retweet_cnt_1
            WHEN '2021-10-02' THEN retweet_cnt_2
            WHEN '2021-10-03' THEN retweet_cnt_3 
            ELSE 0 END) max_retweet_cnt_7d
FROM (
    SELECT tag, dt, 
            SUM(CASE WHEN dt BETWEEN '2021-09-25' AND '2021-10-01' THEN like_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) like_cnt_1,
            SUM(CASE WHEN dt BETWEEN '2021-09-26' AND '2021-10-02' THEN like_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) like_cnt_2,
            SUM(CASE WHEN dt BETWEEN '2021-09-27' AND '2021-10-03' THEN like_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) like_cnt_3,
            MAX(CASE WHEN dt BETWEEN '2021-09-25' AND '2021-10-01' THEN retweet_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) retweet_cnt_1,
            MAX(CASE WHEN dt BETWEEN '2021-09-26' AND '2021-10-02' THEN retweet_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) retweet_cnt_2,
            MAX(CASE WHEN dt BETWEEN '2021-09-27' AND '2021-10-03' THEN retweet_cnt ELSE 0 END) OVER(PARTITION BY tag ORDER BY dt) retweet_cnt_3
    FROM (
        -- 2021-09-25到2021-10-03每类视频每天点赞总数和转发总数
        SELECT T2.tag, T1.dt, SUM(like_cnt) like_cnt, sum(retweet_cnt) retweet_cnt
        FROM (
            SELECT video_id, DATE_FORMAT(end_time, '%Y-%m-%d') dt, 
                    SUM(if_like) like_cnt, SUM(if_retweet) retweet_cnt 
            FROM tb_user_video_log
            WHERE DATE_FORMAT(end_time, '%Y-%m-%d') BETWEEN '2021-09-25' AND '2021-10-03'
            GROUP BY video_id, dt
        ) T1
        INNER JOIN (
            SELECT video_id, tag FROM tb_video_info
        ) T2 ON T2.video_id = T1.video_id
        GROUP BY T2.tag, T1.dt
    ) TA
) TB
WHERE dt BETWEEN '2021-10-01' AND '2021-10-03'
ORDER BY tag DESC, dt
;

-- 题解 SQL CASE 2
SELECT tag, dt, sum_like_cnt_7d, max_retweet_cnt_7d
FROM (
    SELECT tag, dt, 
            SUM(like_cnt) OVER(PARTITION BY tag ORDER BY dt rows 6 PRECEDING) sum_like_cnt_7d,
            MAX(retweet_cnt) OVER(PARTITION BY tag ORDER BY dt rows 6 PRECEDING) max_retweet_cnt_7d
    FROM (
        -- 2021-09-25到2021-10-03每类视频每天点赞总数和转发总数
        SELECT T2.tag, T1.dt, SUM(like_cnt) like_cnt, sum(retweet_cnt) retweet_cnt
        FROM (
            SELECT video_id, DATE_FORMAT(end_time, '%Y-%m-%d') dt, 
                    SUM(if_like) like_cnt, SUM(if_retweet) retweet_cnt 
            FROM tb_user_video_log
            WHERE DATE_FORMAT(end_time, '%Y-%m-%d') BETWEEN '2021-09-25' AND '2021-10-03'
            GROUP BY video_id, dt
        ) T1
        INNER JOIN (
            SELECT video_id, tag FROM tb_video_info
        ) T2 ON T2.video_id = T1.video_id
        GROUP BY T2.tag, T1.dt
    ) TA
) TB
WHERE dt BETWEEN '2021-10-01' AND '2021-10-03'
ORDER BY tag DESC, dt
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
   (101, 2001, '2021-09-24 10:00:00', '2021-09-24 10:00:20', 1, 1, 0, null)
  ,(105, 2002, '2021-09-25 11:00:00', '2021-09-25 11:00:30', 0, 0, 1, null)
  ,(102, 2002, '2021-09-25 11:00:00', '2021-09-25 11:00:30', 1, 1, 1, null)
  ,(101, 2002, '2021-09-26 11:00:00', '2021-09-26 11:00:30', 1, 0, 1, null)
  ,(101, 2002, '2021-09-27 11:00:00', '2021-09-27 11:00:30', 1, 1, 0, null)
  ,(102, 2002, '2021-09-28 11:00:00', '2021-09-28 11:00:30', 1, 0, 1, null)
  ,(103, 2002, '2021-09-29 11:00:00', '2021-09-29 11:00:30', 1, 0, 1, null)
  ,(102, 2002, '2021-09-30 11:00:00', '2021-09-30 11:00:30', 1, 1, 1, null)
  ,(101, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:20', 1, 1, 0, null)
  ,(102, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:15', 0, 0, 1, null)
  ,(103, 2001, '2021-10-01 11:00:50', '2021-10-01 11:01:15', 1, 1, 0, 1732526)
  ,(106, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:05', 2, 0, 1, null)
  ,(107, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:05', 1, 0, 1, null)
  ,(108, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:05', 1, 1, 1, null)
  ,(109, 2002, '2021-10-03 10:59:05', '2021-10-03 11:00:05', 0, 1, 0, null);

INSERT INTO tb_video_info(video_id, author, tag, duration, release_time) VALUES
   (2001, 901, '旅游', 30, '2020-01-01 7:00:00')
  ,(2002, 901, '旅游', 60, '2021-01-01 7:00:00')
  ,(2003, 902, '影视', 90, '2020-01-01 7:00:00')
  ,(2004, 902, '美女', 90, '2020-01-01 8:00:00');