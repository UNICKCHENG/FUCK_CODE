-- 链接 LINK: https://leetcode-cn.com/problems/find-median-given-frequency-of-numbers/
-- 标题 TITLE: 571. 给定数字的频率查询中位数
-- 日期 DATE: 2022-04-09 09:53:37

/* 设计思路
核心思想是中位数序号是在 [ceil(n/2), ceil((n+1)/2)]（左闭右闭）。不论奇数偶数都适用。
**/

-- 题解 SQL
SELECT ROUND(AVG(num), 1) median
FROM (
    SELECT num, frequency
            , SUM(frequency) OVER(ORDER BY num) sum_num
            , SUM(frequency) OVER() all_num
    FROM Numbers 
) T1
WHERE (CEILING(all_num/2) BETWEEN sum_num - frequency + 1 AND sum_num)
        OR (CEILING((all_num+1)/2) BETWEEN sum_num - frequency + 1 AND sum_num)
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Numbers;
Create table If Not Exists Numbers (num int, frequency int);
Truncate table Numbers;
insert into Numbers (num, frequency) values ('0', '7');
insert into Numbers (num, frequency) values ('1', '1');
insert into Numbers (num, frequency) values ('2', '3');
insert into Numbers (num, frequency) values ('3', '1');