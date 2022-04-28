-- 链接 LINK: https://www.nowcoder.com/practice/69c85db3e59245efb7cee51996fe2273?tpId=268&tqId=2286312&ru=/practice/f022c9ec81044d4bb7e0711ab794531a&qru=/ta/sql-factory-interview/question-ranking
-- 标题 TITLE: SQL36 某乎问答高质量的回答中用户属于各级别的数量
-- 日期 DATE: 2022-02-02 13:52:14

-- 题解 SQL
SELECT (CASE WHEN author_level = '5' OR author_level = '6' THEN '5-6级'
            WHEN author_level = '3' OR author_level = '4' THEN '3-4级'
            WHEN author_level = '1' OR author_level = '2' THEN '1-2级'
            ELSE '-' END) level_cut,
        COUNT(issue_id) num
FROM (
    SELECT issue_id, author_id FROM answer_tb
    WHERE char_len >= 100
) T1
INNER JOIN author_tb T2 ON T2.author_id = T1.author_id
GROUP BY level_cut
ORDER BY num DESC
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