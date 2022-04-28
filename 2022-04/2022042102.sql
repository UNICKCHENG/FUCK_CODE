-- 链接 LINK: https://leetcode-cn.com/problems/the-number-of-seniors-and-juniors-to-join-the-company-ii/
-- 标题 TITLE: 2010. 职员招聘人数 II
-- 日期 DATE: 2022-04-21 14:55:34

-- 累加求和

-- 题解 SQL
SELECT employee_id
FROM (
    SELECT T1.employee_id
            , (CASE WHEN @all_salary + T1.salary <= 70000 THEN @all_salary := @all_salary + T1.salary ELSE NULL END) all_salary
    FROM Candidates T1, (SELECT @all_salary := 0) T2
    ORDER BY T1.experience, T1.salary
) TRESULT
WHERE all_salary IS NOT NULL
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Candidates;
Create table If Not Exists Candidates (employee_id int, experience ENUM('Senior', 'Junior'), salary int);
Truncate table Candidates;
insert into Candidates (employee_id, experience, salary) values ('1', 'Junior', '10000');
insert into Candidates (employee_id, experience, salary) values ('9', 'Junior', '15000');
insert into Candidates (employee_id, experience, salary) values ('2', 'Senior', '20000');
insert into Candidates (employee_id, experience, salary) values ('11', 'Senior', '16000');
insert into Candidates (employee_id, experience, salary) values ('13', 'Senior', '50000');
insert into Candidates (employee_id, experience, salary) values ('4', 'Junior', '40000');