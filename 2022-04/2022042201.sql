-- 链接 LINK: https://leetcode-cn.com/problems/find-the-subtasks-that-did-not-execute/
-- 标题 TITLE: 1767. 寻找没有被执行的任务对
-- 日期 DATE: 2022-04-22 11:07:13


-- 题解 SQL
SELECT T1.task_id, T2.subtask_id
FROM Tasks T1
LEFT JOIN (
    SELECT @num := @num + 1 subtask_id 
    FROM INFORMATION_SCHEMA.TABLES TA, (SELECT @num := 0) T2
    LIMIT 20
) T2 ON T2.subtask_id <= T1.subtasks_count
WHERE NOT EXISTS (
    SELECT 1 FROM Executed
    WHERE task_id = T1.task_id AND subtask_id = T2.subtask_id
)


;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Executed;
Create table If Not Exists Tasks (task_id int, subtasks_count int);
Create table If Not Exists Executed (task_id int, subtask_id int);
Truncate table Tasks;
insert into Tasks (task_id, subtasks_count) values ('1', '3');
insert into Tasks (task_id, subtasks_count) values ('2', '2');
insert into Tasks (task_id, subtasks_count) values ('3', '4');
Truncate table Executed;
insert into Executed (task_id, subtask_id) values ('1', '2');
insert into Executed (task_id, subtask_id) values ('3', '1');
insert into Executed (task_id, subtask_id) values ('3', '2');
insert into Executed (task_id, subtask_id) values ('3', '3');
insert into Executed (task_id, subtask_id) values ('3', '4');