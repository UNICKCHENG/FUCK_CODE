-- 链接 LINK: https://leetcode-cn.com/problems/the-number-of-passengers-in-each-bus-ii/
-- 标题 TITLE: 2153. The Number of Passengers in Each Bus II
-- 日期 DATE: 2022-04-20 21:18:25

/* 设计思路
本题属于在「同时在线人数题」上的扩展，以下为代码逻辑思路

「同时在线人数题」将上线记为1，下线记为-1，使用窗口函数进行累加求和即可
本题将乘客到达车站等车人数记为正数，乘客可上车人数记为负数，但本题多了一个条件，即可上车人数与车剩余容量（capacity）有关
问题：通常「同时在线人数题」在线人数一定是非负数，但本题因为多了这个条件，将导致计算时乘客到达车站等车人数可能存在负数
解决：如果使用窗口函数进行累加求和，负数将会被加入计算，而这并不是我们想看到的，那么此时只能尝试使用变量进行自定义累加求和
**/

-- 题解 SQL
SELECT bus_id
        , IF(left_passengers_num < 0, left_passengers_num - capacity, -capacity) passengers_cnt
FROM (
    -- 统计每次车站剩余乘客数 left_passengers_num, 若值为非正数, 表示无剩余乘客且最近上一班次车还剩空位数
    SELECT bus_id, capacity
            , IF(@left_passengers_num < 0, @left_passengers_num := capacity, @left_passengers_num := @left_passengers_num + capacity) left_passengers_num 
            , COUNT(1) OVER() nums -- 避免left_passengers_num索引失效
    FROM (
        SELECT bus_id, arrival_time, -capacity capacity FROM Buses 
        UNION ALL
        SELECT -1 bus_id, arrival_time, 1 capacity FROM Passengers
    ) T1, (SELECT @left_passengers_num := 0) T2
    ORDER BY arrival_time, bus_id
) T
WHERE bus_id > 0
ORDER BY bus_id


;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Buses;
DROP TABLE IF EXISTS Passengers;
Create table If Not Exists Buses (bus_id int, arrival_time int, capacity int);
Create table If Not Exists Passengers (passenger_id int, arrival_time int);
Truncate table Buses;
insert into Buses (bus_id, arrival_time, capacity) values ('1', '2', '1');
insert into Buses (bus_id, arrival_time, capacity) values ('2', '4', '10');
insert into Buses (bus_id, arrival_time, capacity) values ('3', '7', '2');
Truncate table Passengers;
insert into Passengers (passenger_id, arrival_time) values ('11', '1');
insert into Passengers (passenger_id, arrival_time) values ('12', '1');
insert into Passengers (passenger_id, arrival_time) values ('13', '5');
insert into Passengers (passenger_id, arrival_time) values ('14', '6');
insert into Passengers (passenger_id, arrival_time) values ('15', '7');