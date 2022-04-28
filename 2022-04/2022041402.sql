-- 链接 LINK: https://leetcode-cn.com/problems/report-contiguous-dates/
-- 标题 TITLE: 1225. 报告系统状态的连续日期
-- 日期 DATE: 2022-04-14 10:52:55

/* 设计思路 连续签到类

**/

-- 题解 SQL CASE 1 变量依次遍历，类似于 FOR 循环
SELECT (CASE tag WHEN 1 THEN 'succeeded' WHEN 0 THEN 'failed' ELSE '-' END) period_state
        , start_dt start_date
        , MAX(dt) end_date
FROM (
    SELECT tag, dt
            , (CASE WHEN @flg != tag THEN @start_dt := dt ELSE @start_dt := @start_dt END) start_dt
            , (CASE WHEN @flg != tag THEN @flg := tag ELSE NULL END)
    FROM (
        SELECT * FROM (
            SELECT fail_date dt, 0 tag FROM Failed WHERE YEAR(fail_date) = '2019'
            UNION ALL
            SELECT success_date dt, 1 tag FROM Succeeded WHERE YEAR(success_date) = '2019'
        ) TMP
        ORDER BY dt
    ) T1, (SELECT @start_dt := NULL, @flg := -1) T2
) TRESULT
GROUP BY tag, start_dt
ORDER BY start_date
;


-- 题解 SQL CASE 2【推荐】窗口函数 组内分组, 类似连续签到打卡
SELECT period_state, MIN(dt) start_date, MAX(dt) end_date
FROM (
    SELECT fail_date dt, 'failed' period_state
            , TIMESTAMPADD(DAY, -ROW_NUMBER() OVER(ORDER BY fail_date), fail_date) flg
    FROM Failed WHERE YEAR(fail_date) = '2019'
    UNION ALL
    SELECT success_date dt, 'succeeded' period_state 
            , TIMESTAMPADD(DAY, -ROW_NUMBER() OVER(ORDER BY success_date), success_date) flg
    FROM Succeeded WHERE YEAR(success_date) = '2019'
) T1
GROUP BY period_state, flg
ORDER BY start_date
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Failed;
DROP TABLE IF EXISTS Succeeded;
Create table If Not Exists Failed (fail_date date);
Create table If Not Exists Succeeded (success_date date);
Truncate table Failed;
insert into Failed (fail_date) values ('2018-12-28');
insert into Failed (fail_date) values ('2018-12-29');
insert into Failed (fail_date) values ('2019-01-04');
insert into Failed (fail_date) values ('2019-01-05');
Truncate table Succeeded;
insert into Succeeded (success_date) values ('2018-12-30');
insert into Succeeded (success_date) values ('2018-12-31');
insert into Succeeded (success_date) values ('2019-01-01');
insert into Succeeded (success_date) values ('2019-01-02');
insert into Succeeded (success_date) values ('2019-01-03');
insert into Succeeded (success_date) values ('2019-01-06');