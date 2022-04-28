-- 链接 LINK: https://leetcode-cn.com/problems/department-top-three-salaries/
-- 标题 TITLE:185. 部门工资前三高的所有员工 
-- 日期 DATE: 2022-04-10 11:54:51

/* 设计思路

**/

-- 题解 SQL
SELECT T2.name Department, T1.name Employee, T1.salary Salary
FROM (
    SELECT *, DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) ranks
    FROM Employee
) T1
INNER JOIN Department T2 ON T2.id = T1.departmentId
WHERE T1.ranks <= 3

;


-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Max', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (id, name, salary, departmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');