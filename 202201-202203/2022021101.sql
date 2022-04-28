-- 链接 LINK: https://www.nowcoder.com/practice/0cab547df4f0430b93042128f445d899?tpId=268&tqId=2286222&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj%3Ftab%3DSQL%25E7%25AF%2587%26topicId%3D268
-- 标题 TITLE: SQL33 牛客直播各科目出勤率
-- 日期 DATE: 2022-02-11 11:28:00

-- 题解 SQL
-- 加大难度: 只计算在课程时间段内的在线时间, 每次退出再登录, 则重新计算在线时间 
SELECT T1.course_id, T1.course_name,
        ROUND(COUNT(DISTINCT T2.user_id)*100/sign_cnt, 2) `attend_rate(%)`
FROM (
    SELECT course_id, course_name, 
            str_to_date(course_datetime, '%Y-%m-%d %H:%i') start_time,
            str_to_date(course_datetime, '%Y-%m-%d %H:%i-%H:%i') end_time
    FROM course_tb 
) T1
LEFT JOIN (
    SELECT * 
    FROM attend_tb
    WHERE TIMESTAMPDIFF(MINUTE, in_datetime, out_datetime) >= 10
) T2 ON T1.course_id = T2.course_id -- 这边可以再细化
LEFT JOIN (
    SELECT course_id, SUM(if_sign) sign_cnt
    FROM behavior_tb
    GROUP BY course_id
) T3 ON T3.course_id = T1.course_id
GROUP BY T1.course_id, T1.course_name, sign_cnt
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

drop table if exists behavior_tb;
CREATE TABLE behavior_tb(
user_id int(10) NOT NULL, 
if_vw int(10) NOT NULL,
if_fav int(10) NOT NULL,
if_sign int(10) NOT NULL,
course_id int(10) NOT NULL);

INSERT INTO behavior_tb VALUES(100, 1, 1, 1, 1);
INSERT INTO behavior_tb VALUES(100, 1, 1, 1, 2);
INSERT INTO behavior_tb VALUES(100, 1, 1, 1, 3);
INSERT INTO behavior_tb VALUES(101, 1, 1, 1, 1);
INSERT INTO behavior_tb VALUES(101, 1, 1, 1, 2);
INSERT INTO behavior_tb VALUES(101, 1, 0, 0, 3);
INSERT INTO behavior_tb VALUES(102, 1, 1, 1, 1);
INSERT INTO behavior_tb VALUES(102, 1, 1, 1, 2);
INSERT INTO behavior_tb VALUES(102, 1, 1, 1, 3);
INSERT INTO behavior_tb VALUES(103, 1, 1, 0, 1);
INSERT INTO behavior_tb VALUES(103, 1, 0, 0, 2);
INSERT INTO behavior_tb VALUES(103, 1, 0, 0, 3);
INSERT INTO behavior_tb VALUES(104, 1, 1, 1, 1);
INSERT INTO behavior_tb VALUES(104, 1, 1, 1, 2);
INSERT INTO behavior_tb VALUES(104, 1, 1, 0, 3);
INSERT INTO behavior_tb VALUES(105, 1, 0, 0, 1);
INSERT INTO behavior_tb VALUES(106, 1, 0, 0, 1);
INSERT INTO behavior_tb VALUES(107, 1, 0, 0, 1);
INSERT INTO behavior_tb VALUES(107, 1, 1, 1, 2);
INSERT INTO behavior_tb VALUES(108, 1, 1, 1, 3);

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