-- 链接 LINK: https://www.nowcoder.com/practice/73bf143cfc7f452a8569c6d7eca380f9?tpId=268&tqId=2286010&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL30 牛客直播转换率
-- 日期 DATE: 2022-02-03 08:43:28

-- 题解 SQL
SELECT T2.course_id, T2.course_name, T1.sign_rate 'sign_rate(%)'
FROM (
    SELECT course_id, ROUND(SUM(if_sign)*100/SUM(if_vw), 2) sign_rate
    FROM behavior_tb
    GROUP BY course_id
) T1
INNER JOIN course_tb T2 ON T2.course_id = T1.course_id
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