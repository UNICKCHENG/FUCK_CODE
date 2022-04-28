-- 链接 LINK: https://leetcode-cn.com/problems/hopper-company-queries-iii/
-- 标题 TITLE: 1651. Hopper 公司查询 III
-- 日期 DATE: 2022-04-21 15:05:21


-- 题解 SQL

SELECT T1.month
        , ROUND(SUM(IFNULL(ride_distance, 0)) OVER(ORDER BY T1.month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) / 3, 2) average_ride_distance
        , ROUND(SUM(IFNULL(ride_duration, 0)) OVER(ORDER BY T1.month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) / 3, 2) average_ride_duration
FROM (
    SELECT @num := @num + 1 month
    FROM INFORMATION_SCHEMA.TABLES TA, (SELECT @num := 0) TB
    LIMIT 12
) T1 
LEFT JOIN (
    SELECT month, SUM(ride_distance) ride_distance, SUM(ride_duration) ride_duration 
    FROM (
        SELECT ride_id, MONTH(requested_at) month FROM Rides 
        WHERE requested_at BETWEEN '2020-01-01' AND '2020-12-31'
    ) TA
    INNER JOIN AcceptedRides TB ON TB.ride_id = TA.ride_id
    GROUP BY month
) T2 ON T2.month = T1.month
ORDER BY T1.month
LIMIT 10


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