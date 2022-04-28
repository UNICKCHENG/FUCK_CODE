-- 链接 LINK: https://www.nowcoder.com/practice/e9e7dc4c8623467793f6999cbfee9360?tpId=268&tqId=2286189&ru=/practice/dcc4adafd0fe41b5b2fc03ad6a4ac686&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL32 牛客直播各科目平均观看时长
-- 日期 DATE: 2022-03-04 10:29:51

-- 题解 SQL 本题答案
-- 不考虑课程开始时间和结束时间, 即用户进出课程的在线时长
SELECT T1.course_name, T2.avg_Len
FROM course_tb T1
INNER JOIN (
    SELECT course_id, 
        ROUND(avg(TIMESTAMPDIFF(MINUTE, in_datetime, out_datetime)), 2) avg_Len
    FROM attend_tb
    GROUP BY course_id
) T2 ON T1.course_id = T2.course_id
ORDER BY T2.avg_Len DESC
;

-- SQL 扩展思维: 每个科目每人平均观看时长
-- 考虑课程开始时间和结束时间, 即只有在课程时间段内才计算观看时长
SELECT T1.course_name, 
        ROUND(SUM(
                TIMESTAMPDIFF(MINUTE, 
                                IF(in_datetime >= start_time, in_datetime, start_time), 
                                IF(out_datetime <= end_time, out_datetime, end_time))) 
            / COUNT(DISTINCT T2.user_id), 2) avg_len
FROM (
    SELECT course_id, course_name, 
            str_to_date(course_datetime, '%Y-%m-%d %H:%i') start_time,
            str_to_date(course_datetime, '%Y-%m-%d %H:%i-%H:%i') end_time
    FROM course_tb 
) T1
INNER JOIN attend_tb T2 ON T1.course_id = T2.course_id 
        AND T2.in_datetime <= T1.end_time AND T2.out_datetime >= T1.start_time
GROUP BY T1.course_name
ORDER BY avg_len DESC
;


-- 数据 DATA ===================================================
drop table if exists course_tb;
CREATE TABLE course_tb(
course_id int(10) NOT NULL, 
course_name char(10) NOT NULL,
course_datetime char(30) NOT NULL);

INSERT INTO course_tb VALUES(1, 'Python', '2021-12-1 19:00-21:00');
INSERT INTO course_tb VALUES(2, 'SQL', '2021-12-2 19:00-21:00');
INSERT INTO course_tb VALUES(3, 'R', '2021-12-3 19:00-21:00');

drop table if exists attend_tb;
CREATE TABLE attend_tb(
user_id int(10) NOT NULL, 
course_id int(10) NOT NULL,
in_datetime datetime NOT NULL,
out_datetime datetime NOT NULL
);
INSERT INTO attend_tb VALUES(100, 1, '2021-12-1 19:00:00', '2021-12-1 19:28:00');
INSERT INTO attend_tb VALUES(100, 1, '2021-12-1 19:30:00', '2021-12-1 19:53:00');
INSERT INTO attend_tb VALUES(101, 1, '2021-12-1 19:00:00', '2021-12-1 20:55:00');
INSERT INTO attend_tb VALUES(102, 1, '2021-12-1 19:00:00', '2021-12-1 19:05:00');
INSERT INTO attend_tb VALUES(104, 1, '2021-12-1 19:00:00', '2021-12-1 20:59:00');
INSERT INTO attend_tb VALUES(101, 2, '2021-12-2 19:05:00', '2021-12-2 20:58:00');
INSERT INTO attend_tb VALUES(102, 2, '2021-12-2 18:55:00', '2021-12-2 21:00:00');
INSERT INTO attend_tb VALUES(104, 2, '2021-12-2 18:57:00', '2021-12-2 20:56:00');
INSERT INTO attend_tb VALUES(107, 2, '2021-12-2 19:10:00', '2021-12-2 19:18:00');
INSERT INTO attend_tb VALUES(100, 3, '2021-12-3 19:01:00', '2021-12-3 21:00:00');
INSERT INTO attend_tb VALUES(102, 3, '2021-12-3 18:58:00', '2021-12-3 19:05:00');
INSERT INTO attend_tb VALUES(108, 3, '2021-12-3 19:01:00', '2021-12-3 19:56:00');