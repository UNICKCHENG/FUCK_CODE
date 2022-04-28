-- 链接 LINK: https://leetcode-cn.com/problems/finding-the-topic-of-each-post/
-- 标题 TITLE: 2199. Finding the Topic of Each Post
-- 日期 DATE: 2022-04-13 13:08:29

/* 设计思路 简单题 涉及字符串知识

**/

-- 题解 SQL
SELECT  T1.post_id, GROUP_CONCAT(DISTINCT IFNULL(T2.topic_id, 'Ambiguous!') ORDER BY T2.topic_id) topic
FROM Posts T1
LEFT JOIN Keywords T2 ON LOWER(T1.content) = LOWER(T2.word)
                        OR LOWER(LEFT(T1.content, LENGTH(T2.word) + 1)) = CONCAT(LOWER(T2.word), ' ')
                        OR LOWER(RIGHT(T1.content, LENGTH(T2.word) + 1)) = CONCAT(' ', LOWER(T2.word))
                        OR INSTR(LOWER(T1.content), CONCAT(' ', LOWER(T2.word), ' ')) != 0
GROUP BY T1.post_id

;

-- 数据 DATA ===================================================
DROP TABLE IF EXISTS Keywords;
DROP TABLE IF EXISTS Posts;
Create table If Not Exists Keywords (topic_id int, word varchar(25));
Create table If Not Exists Posts (post_id int, content varchar(100));
Truncate table Keywords;
insert into Keywords (topic_id, word) values ('1', 'handball');
insert into Keywords (topic_id, word) values ('1', 'football');
insert into Keywords (topic_id, word) values ('3', 'WAR');
insert into Keywords (topic_id, word) values ('2', 'Vaccine');
Truncate table Posts;
insert into Posts (post_id, content) values ('1', 'We call it soccer They call it football hahaha');
insert into Posts (post_id, content) values ('2', 'Americans prefer basketball while Europeans love handball and football');
insert into Posts (post_id, content) values ('3', 'stop the war and play handball');
insert into Posts (post_id, content) values ('4', 'warning I planted some flowers this morning and then got vaccinated');