-- 链接 LINK: https://leetcode-cn.com/problems/hopper-company-queries-i/
-- 标题 TITLE: 1635. Hopper 公司查询 I
-- 日期 DATE: 2022-04-14 10:14:42

/* 设计思路 缺失月份补全
- 通过 UNION 将缺失月份补全, 需要去重
- 通过窗口函数对每月份drivers进行累加求和
- 计算出accepted_rides量
**/

-- 题解 SQL
SELECT T1.month, T1.active_drivers, IFNULL(T2.accepted_rides, 0) accepted_rides
FROM (
    SELECT year, month, SUM(SUM(driver_num)) OVER(ORDER BY year, month) active_drivers
    FROM (
        SELECT YEAR(join_date) year, MONTH(join_date) month, COUNT(driver_id) driver_num
        FROM Drivers
        GROUP BY YEAR(join_date), MONTH(join_date)
        UNION ALL 
        SELECT * FROM (
            SELECT '2020' year, (@month := @month + 1) month, 0 driver_num
            FROM information_schema.tables a, (SELECT @month := 0) b
            LIMIT 12
        ) TMP
    ) T1A
    GROUP BY year, month
) T1
LEFT JOIN (
    SELECT month(T2A.requested_at) month, COUNT(1) accepted_rides FROM Rides T2A
    INNER JOIN AcceptedRides T2B ON YEAR(T2A.requested_at) = '2020' AND T2A.ride_id = T2B.ride_id
    GROUP BY month(T2A.requested_at)
) T2 ON T1.year = '2020' AND T2.month = T1.month
WHERE T1.year = '2020'
ORDER BY T1.month

;
-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Drivers;
DROP TABLE IF EXISTS Rides;
DROP TABLE IF EXISTS AcceptedRides;
Create table If Not Exists Drivers (driver_id int, join_date date);
Create table If Not Exists Rides (ride_id int, user_id int, requested_at date);
Create table If Not Exists AcceptedRides (ride_id int, driver_id int, ride_distance int, ride_duration int);
Truncate table Drivers;
insert into Drivers (driver_id, join_date) values ('10', '2019-12-10');
insert into Drivers (driver_id, join_date) values ('8', '2020-1-13');
insert into Drivers (driver_id, join_date) values ('5', '2020-2-16');
insert into Drivers (driver_id, join_date) values ('7', '2020-3-8');
insert into Drivers (driver_id, join_date) values ('4', '2020-5-17');
insert into Drivers (driver_id, join_date) values ('1', '2020-10-24');
insert into Drivers (driver_id, join_date) values ('6', '2021-1-5');
Truncate table Rides;
insert into Rides (ride_id, user_id, requested_at) values ('6', '75', '2019-12-9');
insert into Rides (ride_id, user_id, requested_at) values ('1', '54', '2020-2-9');
insert into Rides (ride_id, user_id, requested_at) values ('10', '63', '2020-3-4');
insert into Rides (ride_id, user_id, requested_at) values ('19', '39', '2020-4-6');
insert into Rides (ride_id, user_id, requested_at) values ('3', '41', '2020-6-3');
insert into Rides (ride_id, user_id, requested_at) values ('13', '52', '2020-6-22');
insert into Rides (ride_id, user_id, requested_at) values ('7', '69', '2020-7-16');
insert into Rides (ride_id, user_id, requested_at) values ('17', '70', '2020-8-25');
insert into Rides (ride_id, user_id, requested_at) values ('20', '81', '2020-11-2');
insert into Rides (ride_id, user_id, requested_at) values ('5', '57', '2020-11-9');
insert into Rides (ride_id, user_id, requested_at) values ('2', '42', '2020-12-9');
insert into Rides (ride_id, user_id, requested_at) values ('11', '68', '2021-1-11');
insert into Rides (ride_id, user_id, requested_at) values ('15', '32', '2021-1-17');
insert into Rides (ride_id, user_id, requested_at) values ('12', '11', '2021-1-19');
insert into Rides (ride_id, user_id, requested_at) values ('14', '18', '2021-1-27');
Truncate table AcceptedRides;
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('10', '10', '63', '38');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('13', '10', '73', '96');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('7', '8', '100', '28');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('17', '7', '119', '68');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('20', '1', '121', '92');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('5', '7', '42', '101');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('2', '4', '6', '38');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('11', '8', '37', '43');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('15', '8', '108', '82');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('12', '8', '38', '34');
insert into AcceptedRides (ride_id, driver_id, ride_distance, ride_duration) values ('14', '1', '90', '74');