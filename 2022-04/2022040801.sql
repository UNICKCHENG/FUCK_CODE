-- 链接 LINK: https://leetcode-cn.com/problems/the-number-of-seniors-and-juniors-to-join-the-company/
-- 标题 TITLE: 2004. 职员招聘人数
-- 日期 DATE: 2022-04-08 14:40:28

-- 设计思路 基础题
-- 1. 核心是按照 experience, salary 排序
-- 2. 先从 Senior 找到满足条件的, 然后再找 Junior 中的
-- 3. 推荐使用 CASE 2 通过变量依次遍历, CASE 1 窗口函数方法稍微有点绕


-- 题解 SQL CASE 1
SELECT experience, COUNT(employee_id) accepted_candidates
FROM (
    -- 再找 Junior 满足条件的
    SELECT employee_id, experience
            , SUM(salary) OVER(ORDER BY experience, salary, employee_id) salary
    FROM (
        -- 先找 Senior 满足条件的
        SELECT employee_id, experience, salary
                , SUM(salary) OVER(PARTITION BY experience ORDER BY salary, employee_id) sum_salary
        FROM Candidates
        WHERE salary <= 70000
    ) TA
    WHERE sum_salary <= 70000
    UNION SELECT NULL employee_id, 'Senior' experience, 0 salary
    UNION SELECT NULL employee_id, 'Junior' experience, 0 salary
) T1
WHERE salary <= 70000
GROUP BY experience
ORDER BY experience
; 

-- 题解 SQL CASE 2(推荐)
SELECT experience, COUNT(employee_id) accepted_candidates
FROM (
    SELECT  employee_id, experience
            , IF(@sum + salary > 70000, 0, 1) is_choice
            , IF(@sum + salary > 70000, @sum := @sum, @sum := @sum + salary) sum_salary
    FROM (
        SELECT employee_id, experience, salary
        FROM Candidates
        WHERE salary <= 70000
        ORDER BY experience, salary, employee_id
    ) T1, (SELECT @sum := 0) T2
    UNION SELECT NULL employee_id, 'Senior' experience, 1 is_choice, 0 sum_salary
    UNION SELECT NULL employee_id, 'Junior' experience, 1 is_choice, 0 sum_salary
) TRESULT
WHERE is_choice = 1
GROUP BY experience
ORDER BY experience
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Candidates;
Create table If Not Exists Candidates (employee_id int, experience ENUM('Senior', 'Junior'), salary int);
Truncate table Candidates;
insert into Candidates (employee_id, experience, salary) values ('1', 'Junior', '10000');
insert into Candidates (employee_id, experience, salary) values ('9', 'Junior', '10000');
insert into Candidates (employee_id, experience, salary) values ('2', 'Senior', '20000');
insert into Candidates (employee_id, experience, salary) values ('11', 'Senior', '20000');
insert into Candidates (employee_id, experience, salary) values ('13', 'Senior', '50000');
insert into Candidates (employee_id, experience, salary) values ('4', 'Junior', '40000');