-- 链接 LINK: https://www.nowcoder.com/practice/bdd30e83d47043c99def6d9671bb6dbf?tpId=268&tqId=2286094&ru=/practice/73bf143cfc7f452a8569c6d7eca380f9&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL31 牛客直播开始时各直播间在线人数
-- 日期 DATE: 2022-02-03 08:55:54

/* NOTE 
将时间段拆分为开始时间和结束时间（本题不需要, 但可以发散下思维）
- 【推荐】str_to_date(datetime, format) 函数 
- substring(str, pos, length) 字符串拆分
- substring_index(str,delim,count) 键字截取字符串

e.g. 
SELECT str_to_date('2022年2月3日 19点31分50秒', '%Y年%m月%d日 %H点%i分%s秒');
**/

-- 题解 SQL
SELECT T1.course_id, T1.course_name, COUNT(DISTINCT user_id) online_num
FROM (
    SELECT course_id, course_name,
    str_to_date(course_datetime, '%Y-%m-%d %H:%i') start_time,
    str_to_date(course_datetime, '%Y-%m-%d %H:%i-%H:%i') end_time
    FROM course_tb
) T1
INNER JOIN attend_tb T2 ON T2.in_datetime <= T1.start_time AND T1.start_time <= T2.out_datetime
GROUP BY T1.course_id, T1.course_name
ORDER BY course_id

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