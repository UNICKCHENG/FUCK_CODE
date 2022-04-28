-- 链接 LINK: https://www.nowcoder.com/practice/d69677e41f9a4bf3b3ed7a42573e9490?tpId=268&tqId=2286245&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj%3Ftab%3DSQL%25E7%25AF%2587%26topicId%3D268
-- 标题 TITLE: SQL34 牛客直播各科目同时在线人数
-- 日期 DATE: 2022-02-28 13:07:38

-- 题解 SQL
SELECT T2.course_id, T2.course_name, MAX(T1.num) max_num
FROM (
    SELECT course_id, 
            SUM(tag) OVER(PARTITION BY course_id ORDER BY time, tag DESC) num
    FROM (
        SELECT user_id, course_id, in_datetime time, 1 tag FROM attend_tb
        UNION
        SELECT user_id, course_id, out_datetime time, -1 tag FROM attend_tb
    ) TA
) T1
INNER JOIN course_tb T2 ON T2.course_id = T1.course_id
GROUP BY T2.course_id, T2.course_name
ORDER BY T2.course_id
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