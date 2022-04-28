-- 链接 LINK: https://leetcode-cn.com/problems/average-salary-departments-vs-company/
-- 标题 TITLE: 615. 平均工资：部门与公司比较
-- 日期 DATE: 2022-04-07 15:51:53

-- 题解 SQL
SELECT pay_month, department_id
        , (CASE WHEN avg_dep_amount < avg_com_amount THEN 'lower'
                WHEN avg_dep_amount > avg_com_amount THEN 'higher'
            ELSE 'same' END) comparison
FROM (
    SELECT DATE_FORMAT(pay_date, '%Y-%m') pay_month, department_id
            , AVG(amount) avg_dep_amount
            , SUM(SUM(amount)) OVER(PARTITION BY DATE_FORMAT(pay_date, '%Y-%m')) 
                / SUM(COUNT(1)) OVER(PARTITION BY DATE_FORMAT(pay_date, '%Y-%m')) avg_com_amount
    FROM Salary T1
    INNER JOIN Employee T2 ON T2.employee_id = T1.employee_id
    GROUP BY pay_month, department_id
    ORDER BY pay_month DESC, department_id 
) TR

;
-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Salary;
DROP TABLE IF EXISTS Employee;
Create table If Not Exists Salary (id int, employee_id int, amount int, pay_date date);
Create table If Not Exists Employee (employee_id int, department_id int);
Truncate table Salary;
insert into Salary (id, employee_id, amount, pay_date) values ('1', '1', '9000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('2', '2', '6000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('3', '3', '10000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('4', '1', '7000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('5', '2', '6000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('6', '3', '8000', '2017/02/28');
Truncate table Employee;
insert into Employee (employee_id, department_id) values ('1', '1');
insert into Employee (employee_id, department_id) values ('2', '2');
insert into Employee (employee_id, department_id) values ('3', '2');