-- 链接 LINK: https://leetcode-cn.com/problems/build-the-equation/
-- 标题 TITLE: 2118. Build the Equation
-- 日期 DATE: 2022-04-20 11:09:07


-- 题解 SQL CASE 1 通过变量依次拼接表达式
SELECT equation
FROM (
    SELECT *
            , @EXP:= CONCAT((CASE WHEN factor < 0 THEN factor ELSE CONCAT("+", factor) END)
                            , (CASE power WHEN 0 THEN "" WHEN 1 THEN "X" ELSE CONCAT("X^", power) END)
                            , @EXP
                            ) equation
    FROM Terms T1, (SELECT @EXP := "=0") T2
    ORDER BY power
) TRESULT
ORDER BY power DESC
LIMIT 1
;

-- 题解 SQL CASE 2 通过GROUP_CONCAT拼接
SELECT CONCAT(
    GROUP_CONCAT(
        CONCAT((CASE WHEN factor < 0 THEN factor ELSE CONCAT("+", factor) END), 
               (CASE power WHEN 0 THEN "" WHEN 1 THEN "X" ELSE CONCAT("X^", power) END))
        ORDER BY power DESC SEPARATOR '')
    , "=0") equation
FROM Terms
;


-- 数据 DATA ===================================================
DROP TABLE IF Exists Terms; 
Create table If Not Exists Terms (power int, factor int);
Truncate table Terms;
insert into Terms (power, factor) values ('2', '1');
insert into Terms (power, factor) values ('1', '-4');
insert into Terms (power, factor) values ('0', '2');