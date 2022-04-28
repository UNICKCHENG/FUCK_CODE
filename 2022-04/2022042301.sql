-- 链接 LINK: https://leetcode-cn.com/problems/movie-rating/
-- 标题 TITLE: 1341. 电影评分
-- 日期 DATE: 2022-04-23 09:50:08


-- 题解 SQL
(
    SELECT TU.name result
    FROM MovieRating TM
    INNER JOIN Users TU ON TU.user_id = TM.user_id
    GROUP BY TU.user_id, TU.name
    ORDER BY COUNT(1) DESC, TU.name
    LIMIT 1
) 
UNION ALL
(
    SELECT  TV.title result
    FROM MovieRating TM
    INNER JOIN Movies TV ON TV.movie_id = TM.movie_id
    WHERE DATE_FORMAT(TM.created_at, '%Y-%m') = '2020-02'
    GROUP BY TV.movie_id, TV.title
    ORDER BY AVG(TM.rating) DESC, TV.title
    LIMIT 1
) 
;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS MovieRating;
Create table If Not Exists Movies (movie_id int, title varchar(30));
Create table If Not Exists Users (user_id int, name varchar(30));
Create table If Not Exists MovieRating (movie_id int, user_id int, rating int, created_at date);
Truncate table Movies;
insert into Movies (movie_id, title) values ('1', 'Avengers');
insert into Movies (movie_id, title) values ('2', 'Frozen 2');
insert into Movies (movie_id, title) values ('3', 'Joker');
Truncate table Users;
insert into Users (user_id, name) values ('1', 'Daniel');
insert into Users (user_id, name) values ('2', 'Monica');
insert into Users (user_id, name) values ('3', 'Maria');
insert into Users (user_id, name) values ('4', 'James');
Truncate table MovieRating;
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '1', '3', '2020-01-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '2', '4', '2020-02-11');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '3', '2', '2020-02-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '4', '1', '2020-01-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '1', '5', '2020-02-17');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '2', '2', '2020-02-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '3', '2', '2020-03-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '1', '3', '2020-02-22');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '2', '4', '2020-02-25');