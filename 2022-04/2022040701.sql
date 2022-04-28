-- 链接 LINK: https://leetcode-cn.com/problems/find-cumulative-salary-of-an-employee/
-- 标题 TITLE: 579. 查询员工的累计薪水
-- 日期 DATE: 2022-04-07 09:45:15

-- NOTE ROWS 和 RANGE 区别
 
-- 题解 SQL 补全缺失月份，通过窗口函数-ROWS 平滑方式
SELECT Id, Month, Salary
FROM (
    SELECT T1.Id, T2.Month
            , SUM(IF(T1.Month = T2.Month, 1, 0)) tag
            , SUM(SUM(IF(T1.Month = T2.Month, Salary, 0))) OVER(PARTITION BY T1.Id ORDER BY T2.Month ROWS 2 PRECEDING) Salary
    FROM (
        SELECT Id, Month
                , SUM(Salary) Salary 
                , MAX(Month) OVER(PARTITION BY Id) id_max_month
        FROM Employee 
        GROUP BY Month, Id
    ) T1
    RIGHT JOIN (
        -- 将缺失月份补全
        SELECT (@Month := @Month + 1) Month
        FROM information_schema.tables, (SELECT @Month:= 0) T2
        LIMIT 12
    ) T2 ON 1 = 1
    GROUP BY T1.Id, T2.Month, T1.id_max_month
    HAVING T2.Month < T1.id_max_month
) TR
WHERE tag = 1
ORDER BY id, Month DESC
;

-- 题解 SQL 通过窗口函数-RANGE 平滑方式
SELECT Id, Month
        , SUM(SUM(Salary)) OVER(PARTITION BY Id ORDER BY Month RANGE 2 PRECEDING) Salary
FROM Employee 
WHERE (Id, Month) NOT IN (SELECT Id, MAX(Month) Month FROM Employee GROUP BY Id)
GROUP BY Month, Id
ORDER BY id, Month DESC
;


-- 数据 DATA ===================================================
Create table If Not Exists Employee (id int, month int, salary int);
Truncate table Employee;
insert into Employee (id, month, salary) values ('1', '1', '20');
insert into Employee (id, month, salary) values ('2', '1', '20');
insert into Employee (id, month, salary) values ('1', '2', '30');
insert into Employee (id, month, salary) values ('2', '2', '30');
insert into Employee (id, month, salary) values ('3', '2', '40');
insert into Employee (id, month, salary) values ('1', '3', '40');
insert into Employee (id, month, salary) values ('3', '3', '60');
insert into Employee (id, month, salary) values ('1', '4', '60');
insert into Employee (id, month, salary) values ('3', '4', '70');
insert into Employee (id, month, salary) values ('1', '7', '90');
insert into Employee (id, month, salary) values ('1', '8', '90');