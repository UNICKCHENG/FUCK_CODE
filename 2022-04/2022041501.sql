-- 链接 LINK: https://leetcode-cn.com/problems/find-the-quiet-students-in-all-exams/
-- 标题 TITLE: 1412. 查找成绩处于中游的学生
-- 日期 DATE: 2022-04-15 12:39:47

-- 子查询类问题

-- 题解 SQL 【推荐】CASE 1 子查询
SELECT T2.student_id, T2.student_name
FROM Exam T1
INNER JOIN Student T2 ON T2.student_id = T1.student_id
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT exam_id, student_id, score
            , MAX(score) OVER(PARTITION BY exam_id) max_score
            , MIN(score) OVER(PARTITION BY exam_id) min_score
        FROM Exam
    ) TMP 
    WHERE (score = max_score OR score = min_score) AND (student_id = T1.student_id)
) 
GROUP BY T2.student_id, T2.student_name
ORDER BY T2.student_id
;


-- 题解 SQL CASE 2
SELECT T2.student_id, T2.student_name
FROM (
    SELECT student_id
        , IF(DENSE_RANK() OVER(PARTITION BY exam_id ORDER BY score) = 1, 1 , 0) ranks1
        , IF(DENSE_RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) = 1, 1, 0) ranks2
    FROM Exam
) T1
INNER JOIN Student T2 ON T2.student_id = T1.student_id
GROUP BY T2.student_id, T2.student_name
HAVING SUM(ranks1) = 0 AND SUM(ranks2) = 0
ORDER BY T2.student_id

;

-- 题解 SQL CASE 3
SELECT T1.student_id, T1.student_name
FROM Student T1
WHERE EXISTS (
    SELECT 1
    FROM (
        SELECT student_id
            , IF(MAX(score) OVER(PARTITION BY exam_id) = score, 1 , 0) ranks1
            , IF(MIN(score) OVER(PARTITION BY exam_id) = score, 1, 0) ranks2
        FROM Exam
    ) TMP
    WHERE T1.student_id = student_id
    GROUP BY student_id
    HAVING SUM(ranks1) = 0 AND SUM(ranks2) = 0
) 
GROUP BY T1.student_id, T1.student_name
ORDER BY T1.student_id
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Exam;
Create table If Not Exists Student (student_id int, student_name varchar(30));
Create table If Not Exists Exam (exam_id int, student_id int, score int);
Truncate table Student;
insert into Student (student_id, student_name) values ('1', 'Daniel');
insert into Student (student_id, student_name) values ('2', 'Jade');
insert into Student (student_id, student_name) values ('3', 'Stella');
insert into Student (student_id, student_name) values ('4', 'Jonathan');
insert into Student (student_id, student_name) values ('5', 'Will');
Truncate table Exam;
insert into Exam (exam_id, student_id, score) values ('10', '1', '70');
insert into Exam (exam_id, student_id, score) values ('10', '2', '80');
insert into Exam (exam_id, student_id, score) values ('10', '3', '90');
insert into Exam (exam_id, student_id, score) values ('20', '1', '80');
insert into Exam (exam_id, student_id, score) values ('30', '1', '70');
insert into Exam (exam_id, student_id, score) values ('30', '3', '80');
insert into Exam (exam_id, student_id, score) values ('30', '4', '90');
insert into Exam (exam_id, student_id, score) values ('40', '1', '60');
insert into Exam (exam_id, student_id, score) values ('40', '2', '70');
insert into Exam (exam_id, student_id, score) values ('40', '4', '80');