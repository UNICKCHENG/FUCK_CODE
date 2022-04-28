-- 链接 LINK: https://leetcode-cn.com/problems/second-highest-salary/
-- 标题 TITLE: 176. 第二高的薪水
-- 日期 DATE: 2022-04-22 11:26:44


-- 题解 SQL 第N高的常规解法
SELECT salary SecondHighestSalary
FROM (
    SELECT salary, DENSE_RANK() OVER(ORDER BY salary DESC) ranks
    FROM Employee
) TRESULT
WHERE ranks = 2
UNION SELECT NULL SecondHighestSalary
LIMIT 1
;

-- 题解 SQL
SELECT salary SecondHighestSalary
FROM (
    SELECT salary FROM Employee
    GROUP BY salary
    ORDER BY salary DESC
    LIMIT 1, 1
) TRESULT
UNION SELECT NULL SecondHighestSalary
LIMIT 1

;

-- 题解 SQL
SELECT (
    SELECT salary FROM Employee
    GROUP BY salary
    ORDER BY salary DESC
    LIMIT 1, 1
) SecondHighestSalary

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Employee;
Create table If Not Exists Employee (id int, salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '100');
insert into Employee (id, salary) values ('3', '300');