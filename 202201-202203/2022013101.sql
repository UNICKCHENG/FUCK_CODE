-- 链接 LINK: https://www.nowcoder.com/practice/0226c7b2541c41e59c3b8aec588b09ff?tpId=268&tqId=2285071&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL6 近一个月发布的视频中热度最高的top3视频
-- 日期 DATE: 2022-01-31 08:08:13

/* NOTE
DATEDIFF() 计算俩时间相差的天数（俩日期相差）
TIMESTAMPDIFF() 计算俩时间相差多少天数（相差时间折算出来的）.
e.g. 
SELECT TIMESTAMPDIFF(DAY, '2022-01-30 17:00:00', '2022-01-31 08:00:00'), 
        DATEDIFF('2022-01-31 08:00:00', '2022-01-30 17:00:00');
**/

-- 题解 SQL
SELECT video_id, 
        ROUND((100*finish_view_rate + 5*like_cnt + 3*comment_cnt + 2*retweet_cnt)
        / (no_view_day + 1)) hot_index
FROM (
    SELECT T1.video_id,
            AVG(CASE WHEN T2.view_time < T1.duration THEN 0 ELSE 1 END) finish_view_rate,
            SUM(T2.if_like) like_cnt,
            SUM(T2.if_comment) comment_cnt,
            SUM(T2.if_retweet) retweet_cnt,
            TIMESTAMPDIFF(DAY, MAX(T2.dt), today) no_view_day
    FROM (
        SELECT video_id, duration, release_time FROM tb_video_info
    ) T1
    INNER JOIN (
        -- 调整数据格式
        SELECT video_id, DATE_FORMAT(end_time, '%Y-%m-%d') dt, 
                timestampdiff(second, start_time, end_time) view_time,
                if_like, if_retweet, 
                (CASE WHEN comment_id IS NULL THEN 0 ELSE 1 END) if_comment,
                MAX(DATE_FORMAT(end_time, '%Y-%m-%d')) OVER() today
        FROM tb_user_video_log
    ) T2 ON TIMESTAMPDIFF(DAY, DATE_FORMAT(T1.release_time, '%Y-%m-%d'), today) < 30 AND T2.video_id = T1.video_id
    GROUP BY T1.video_id, T2.today
) TA
ORDER BY hot_index DESC
LIMIT 3
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
(101, 2001, '2021-09-24 10:00:00', '2021-09-24 10:00:30', 1, 1, 1, null)
,(101, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:31', 1, 1, 0, null)
,(102, 2001, '2021-10-01 10:00:00', '2021-10-01 10:00:35', 0, 1, 1, null)
,(103, 2001, '2021-10-03 23:59:50', '2021-10-04 00:00:35', 1, 1, 0, 1732526)
,(106, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:04', 2, 0, 1, null)
,(107, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:06', 1, 0, 0, null)
,(108, 2002, '2021-10-02 10:59:05', '2021-10-02 11:00:05', 1, 1, 1, null)
,(109, 2002, '2021-10-03 10:59:05', '2021-10-03 11:00:01', 0, 1, 0, null)
,(105, 2002, '2021-09-25 11:00:00', '2021-09-25 11:00:30', 1, 0, 1, null)
,(101, 2003, '2021-09-26 11:00:00', '2021-09-26 11:01:29', 1, 1, 1, null)
,(101, 2003, '2021-09-30 11:00:00', '2021-09-30 11:01:30', 1, 1, 0, null)
;

INSERT INTO tb_video_info(video_id, author, tag, duration, release_time) VALUES
(2001, 901, '旅游', 30, '2021-09-05 7:00:00')
,(2002, 901, '旅游', 60, '2021-09-04 17:00:00')
,(2003, 902, '影视', 90, '2021-09-05 7:00:00')
,(2004, 902, '影视', 90, '2021-09-05 8:00:00');