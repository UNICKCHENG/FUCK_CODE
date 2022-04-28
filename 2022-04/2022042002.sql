-- 链接 LINK: https://leetcode-cn.com/problems/median-employee-salary/
-- 标题 TITLE: 569. 员工薪水中位数
-- 日期 DATE: 2022-04-20 11:35:29


-- 题解 SQL
SELECT id, company, salary 
FROM (
    SELECT *
            , ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) ranks
            , COUNT(1) OVER(PARTITION BY company) n
    FROM Employee
) T1
WHERE ranks BETWEEN CEILING(n/2) AND CEILING((n+1)/2)
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Employee;
Create table If Not Exists Employee (id int, company varchar(255), salary int);
Truncate table Employee;
insert into Employee (id, company, salary) values ('1', 'A', '2341');
insert into Employee (id, company, salary) values ('2', 'A', '341');
insert into Employee (id, company, salary) values ('3', 'A', '15');
insert into Employee (id, company, salary) values ('4', 'A', '15314');
insert into Employee (id, company, salary) values ('5', 'A', '451');
insert into Employee (id, company, salary) values ('6', 'A', '513');
insert into Employee (id, company, salary) values ('7', 'B', '15');
insert into Employee (id, company, salary) values ('8', 'B', '13');
insert into Employee (id, company, salary) values ('9', 'B', '1154');
insert into Employee (id, company, salary) values ('10', 'B', '1345');
insert into Employee (id, company, salary) values ('11', 'B', '1221');
insert into Employee (id, company, salary) values ('12', 'B', '234');
insert into Employee (id, company, salary) values ('13', 'C', '2345');
insert into Employee (id, company, salary) values ('14', 'C', '2645');
insert into Employee (id, company, salary) values ('15', 'C', '2645');
insert into Employee (id, company, salary) values ('16', 'C', '2652');
insert into Employee (id, company, salary) values ('17', 'C', '65');