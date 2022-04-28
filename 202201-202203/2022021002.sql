-- 链接 LINK: https://www.nowcoder.com/practice/e080f8a685bc4af3b47749ca3310f1fd?tpId=268&tqId=2286361&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL39 某乎问答最大连续回答问题天数大于等于3天的用户及其对应等级
-- 日期 DATE: 2022-02-10 10:43:47

-- 题解 SQL CASE 1
SELECT T2.author_id, T2.author_level, T1.days_cnt
FROM (
    SELECT author_id, COUNT(1) days_cnt
    FROM (
        SELECT author_id, answer_date,
            ROW_NUMBER() OVER(PARTITION BY author_id ORDER BY answer_date) ranks,
            DATE_SUB(answer_date, interval ROW_NUMBER() OVER(PARTITION BY author_id ORDER BY answer_date) day) flg
        FROM answer_tb
    ) TA
    GROUP BY author_id, flg
    HAVING COUNT(1) >= 3
) T1
INNER JOIN author_tb T2 ON T2.author_id = T1.author_id
;

-- 数据 DATA ===================================================
drop table if exists author_tb;
CREATE TABLE author_tb(
author_id int(10) NOT NULL, 
author_level int(10) NOT NULL,
sex char(10) NOT NULL);
INSERT INTO author_tb VALUES(101 , 6, 'm');
INSERT INTO author_tb VALUES(102 , 1, 'f');
INSERT INTO author_tb VALUES(103 , 1, 'm');
INSERT INTO author_tb VALUES(104 , 3, 'm');
INSERT INTO author_tb VALUES(105 , 4, 'f');
INSERT INTO author_tb VALUES(106 , 2, 'f');
INSERT INTO author_tb VALUES(107 , 2, 'm');
INSERT INTO author_tb VALUES(108 , 5, 'f');
INSERT INTO author_tb VALUES(109 , 6, 'f');
INSERT INTO author_tb VALUES(110 , 5, 'm');

drop table if exists answer_tb;
CREATE TABLE answer_tb(
answer_date date NOT NULL, 
author_id int(10) NOT NULL,
issue_id char(10) NOT NULL,
char_len int(10) NOT NULL);
INSERT INTO answer_tb VALUES('2021-11-1', 101, 'E001' ,150);
INSERT INTO answer_tb VALUES('2021-11-1', 101, 'E002', 200);
INSERT INTO answer_tb VALUES('2021-11-1',102, 'C003' ,50);
INSERT INTO answer_tb VALUES('2021-11-1' ,103, 'P001', 35);
INSERT INTO answer_tb VALUES('2021-11-1', 104, 'C003', 120);
INSERT INTO answer_tb VALUES('2021-11-1' ,105, 'P001', 125);
INSERT INTO answer_tb VALUES('2021-11-1' , 102, 'P002', 105);
INSERT INTO answer_tb VALUES('2021-11-2',  101, 'P001' ,201);
INSERT INTO answer_tb VALUES('2021-11-2',  110, 'C002', 200);
INSERT INTO answer_tb VALUES('2021-11-2',  110, 'C001', 225);
INSERT INTO answer_tb VALUES('2021-11-2' , 110, 'C002', 220);
INSERT INTO answer_tb VALUES('2021-11-3', 101, 'C002', 180);
INSERT INTO answer_tb VALUES('2021-11-4' ,109, 'E003', 130);
INSERT INTO answer_tb VALUES('2021-11-4', 109, 'E001',123);
INSERT INTO answer_tb VALUES('2021-11-5', 108, 'C001',160);
INSERT INTO answer_tb VALUES('2021-11-5', 108, 'C002', 120);
INSERT INTO answer_tb VALUES('2021-11-5', 110, 'P001', 180);
INSERT INTO answer_tb VALUES('2021-11-5' , 106, 'P002' , 45);
INSERT INTO answer_tb VALUES('2021-11-5' , 107, 'E003', 56);