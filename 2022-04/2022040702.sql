-- 链接 LINK: https://leetcode-cn.com/problems/user-purchase-platform/
-- 标题 TITLE: 1127. 用户购买平台
-- 日期 DATE: 2022-04-07 16:12:47

-- 题解 SQL 
SELECT spend_date, T2.platform
        , SUM(IF(T2.platform = T1.platform, amount, 0)) total_amount
        , SUM(IF(T2.platform = T1.platform, 1, 0)) total_users
FROM (
    -- 数据按 user_id, spend_date, platform 分组, 一定要去重
    -- 此处使用 DISTINCT 和窗口函数对数据合并和去重
    SELECT DISTINCT user_id, spend_date
            , SUM(SUM(amount)) OVER(PARTITION BY spend_date, user_id)  amount
            , IF(COUNT(platform) OVER(PARTITION BY spend_date, user_id) = 1, platform, 'both') platform
    FROM Spending
    GROUP BY user_id, spend_date, platform
) T1
RIGHT JOIN (
    SELECT 'both' platform
    UNION SELECT 'mobile' platform
    UNION SELECT 'desktop' platform
) T2 ON 1 = 1
GROUP BY spend_date, T2.platform
ORDER BY spend_date, T2.platform DESC
;


-- 数据 DATA ===================================================
DROP TABLE IF Exists Spending;
Create table If Not Exists Spending (user_id int, spend_date date, platform ENUM('desktop', 'mobile'), amount int);
Truncate table Spending;
insert into Spending (user_id, spend_date, platform, amount) values ('1', '2019-07-01', 'mobile', '100');
-- insert into Spending (user_id, spend_date, platform, amount) values ('1', '2019-07-01', 'desktop', '200');
insert into Spending (user_id, spend_date, platform, amount) values ('1', '2019-07-01', 'desktop', '100');
insert into Spending (user_id, spend_date, platform, amount) values ('2', '2019-07-01', 'mobile', '100');
insert into Spending (user_id, spend_date, platform, amount) values ('2', '2019-07-02', 'mobile', '100');
insert into Spending (user_id, spend_date, platform, amount) values ('3', '2019-07-01', 'desktop', '100');
insert into Spending (user_id, spend_date, platform, amount) values ('3', '2019-07-02', 'desktop', '100');