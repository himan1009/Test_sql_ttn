/*

Table: Ads

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ad_id         | int     |
| user_id       | int     |
| action        | enum    |
+---------------+---------+
(ad_id, user_id) is the primary key for this table.
Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').
A company is running Ads and wants to calculate the performance of each Ad.

Performance of the Ad is measured using Click-Through Rate (CTR) where:

Leetcode: Ads Performance

Write an SQL query to find the ctr of each Ad.

Round ctr to 2 decimal points. Order the result table by ctr in descending order and by ad_id in ascending order in case of a tie.

The query result format is in the following example:

Ads table:
+-------+---------+---------+
| ad_id | user_id | action  |
+-------+---------+---------+
| 1     | 1       | Clicked |
| 2     | 2       | Clicked |
| 3     | 3       | Viewed  |
| 5     | 5       | Ignored |
| 1     | 7       | Ignored |
| 2     | 7       | Viewed  |
| 3     | 5       | Clicked |
| 1     | 4       | Viewed  |
| 2     | 11      | Viewed  |
| 1     | 2       | Clicked |
+-------+---------+---------+
Result table:
+-------+-------+
| ad_id | ctr   |
+-------+-------+
| 1     | 66.67 |
| 3     | 50.00 |
| 2     | 33.33 |
| 5     | 0.00  |
+-------+-------+
for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
for ad_id = 5, ctr = 0.00, Note that ad_id has no clicks or views.
Note that we don't care about Ignored Ads.
Result table is ordered by the ctr. in case of a tie we order them by ad_id

*/


-- Create the Ads table
CREATE TABLE Ads (
    ad_id INT,
    user_id INT,
    action VARCHAR(10)
);

-- Insert data into Ads table
INSERT INTO Ads (ad_id, user_id, action) VALUES
(1, 1, 'Clicked'),
(2, 2, 'Clicked'),
(3, 3, 'Viewed'),
(5, 5, 'Ignored'),
(1, 7, 'Ignored'),
(2, 7, 'Viewed'),
(3, 5, 'Clicked'),
(1, 4, 'Viewed'),
(2, 11, 'Viewed'),
(1, 2, 'Clicked');


--with cte1 as (select ad_id,
--count(ad_id) over(partition by ad_id order by ad_id) as total_count
--from Ads),
--cte2 as (select distinct ad_id, count(action) over(partition by ad_id) as click_count
--from Ads
--where action='Clicked'),
--cte3 as (select distinct ad_id, count(action) over(partition by ad_id) as view_count
--from Ads
--where action='Viewed')
--select distinct c1.ad_id, ROUND(COALESCE(
--        CAST(c2.click_count AS DECIMAL(10,2)) * 100.0 / 
--        NULLIF(c2.click_count + c3.view_count, 0), 
--        0.00
--    ), 2) AS ctr
--from cte1 as c1
--left join cte2 as c2
--on c1.ad_id=c2.ad_id
--left join cte3 as c3
--on c1.ad_id=c3.ad_id;


WITH cte1 AS (
    SELECT 
        ad_id,
        COUNT(ad_id) OVER (PARTITION BY ad_id ORDER BY ad_id) AS total_count
    FROM Ads
),
cte2 AS (
    SELECT DISTINCT 
        ad_id, 
        COUNT(action) OVER (PARTITION BY ad_id) AS click_count
    FROM Ads
    WHERE action = 'Clicked'
),
cte3 AS (
    SELECT DISTINCT 
        ad_id, 
        COUNT(action) OVER (PARTITION BY ad_id) AS view_count
    FROM Ads
    WHERE action = 'Viewed'
)
SELECT DISTINCT 
    c1.ad_id, 
    ROUND(
        COALESCE(
            CAST(c2.click_count AS DECIMAL(10,2)) * 100.0 / 
            NULLIF(c2.click_count + c3.view_count, 0), 
            0.00
        ), 
        2
    ) AS ctr
FROM cte1 AS c1
LEFT JOIN cte2 AS c2 ON c1.ad_id = c2.ad_id
LEFT JOIN cte3 AS c3 ON c1.ad_id = c3.ad_id
order by ctr desc;

