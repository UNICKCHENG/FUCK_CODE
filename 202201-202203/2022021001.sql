-- 链接 LINK: https://www.nowcoder.com/practice/b02cf9ee7b9f4cdda308f8155ff3415d?tpId=268&tqId=2286344&ru=/exam/oj&qru=/ta/sql-factory-interview/question-ranking&sourceUrl=%2Fexam%2Foj
-- 标题 TITLE: SQL38 某乎问答回答过教育类问题的用户里有多少用户回答过职场类问题
-- 日期 DATE: 2022-02-10 10:30:58

-- 题解 SQL
SELECT COUNT(author_id) num 
FROM (
    -- 找到两种类型的问题都回答的用户
    SELECT author_id, COUNT(DISTINCT issue_type) type_num
    FROM answer_tb T1
    INNER JOIN (
        SELECT * FROM issue_tb WHERE issue_type IN ('Education', 'Career')
    ) T2 ON T1.issue_id = T2.issue_id
    GROUP BY author_id
    HAVING type_num > 1
) TMP
;


-- 数据 DATA ===================================================

drop table if exists issue_tb;
CREATE TABLE issue_tb(
issue_id char(10) NOT NULL, 
issue_type char(10) NOT NULL);
INSERT INTO issue_tb VALUES('E001' ,'Education');
INSERT INTO issue_tb VALUES('E002' ,'Education');
INSERT INTO issue_tb VALUES('E003' ,'Education');
INSERT INTO issue_tb VALUES('C001', 'Career');
INSERT INTO issue_tb VALUES('C002', 'Career');
INSERT INTO issue_tb VALUES('C003', 'Career');
INSERT INTO issue_tb VALUES('C004', 'Career');
INSERT INTO issue_tb VALUES('P001' ,'Psychology');
INSERT INTO issue_tb VALUES('P002' ,'Psychology');

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