/*

1951. All the Pairs With the Maximum Number of Common Followers
Level
Medium

Description
Table: Relations

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key for this table.
Each row of this table indicates that the user with ID follower_id is following the user with ID user_id.
Write an SQL query to find all the pairs of users with the maximum number of common followers. In other words, if the maximum number of common followers between any two users is maxCommon, then you have to return all pairs of users that have maxCommon common followers.

The result table should contain the pairs user1_id and user2_id where user1_id < user2_id.

Return the result table in any order.

The query result format is in the following example:

Relations table:
+---------+-------------+
| user_id | follower_id |
+---------+-------------+
| 1       | 3           |
| 2       | 3           |
| 7       | 3           |
| 1       | 4           |
| 2       | 4           |
| 7       | 4           |
| 1       | 5           |
| 2       | 6           |
| 7       | 5           |
+---------+-------------+

Result table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 7        |
+----------+----------+

Users 1 and 2 have 2 common followers (3 and 4).
Users 1 and 7 have 3 common followers (3, 4, and 5).
Users 2 and 7 have 2 common followers (3 and 4).
Since the maximum number of common followers between any two users is 3, we return all pairs of users with 3 common followers, which is only the pair (1, 7). We return the pair as (1, 7), not as (7, 1).
Note that we do not have any information about the users that follow users 3, 4, and 5, so we consider them to have 0 followers.

*/


CREATE TABLE Relations (
    user_id INT,
    follower_id INT
);

INSERT INTO Relations (user_id, follower_id) VALUES
(1, 3),
(2, 3),
(7, 3),
(1, 4),
(2, 4),
(7, 4),
(1, 5),
(2, 6),
(7, 5);




with cte1 as (SELECT a.user_id as u1, b.user_id as u2,
count(*) as count_new,
rank() over(order by count(*) desc) as rnk
FROM Relations a , Relations b
where a.follower_id = b.follower_id and a.user_id <> b.user_id and a.user_id<b.user_id
group by u1, u2) 
select u1, u2
from cte1 
where rnk=1;
