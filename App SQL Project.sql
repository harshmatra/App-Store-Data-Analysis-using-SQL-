
CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--EXPLORATORY DATA ANALYSIS--

-- check the number of unique apps in both TablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined;

-- check for missing values in key fields 

SELECT COUNT (*) AS MissingValues
FROM AppleStore
WHERE track_name IS null OR user_rating IS null OR prime_genre IS null ;

SELECT COUNT (*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS null ;


-- Find out the number of apps per genre

SELECT prime_genre, COUNT(*) As NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC ;

-- Get an overview of apps rating

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
 FROM AppleStore ;      
 
 -- Determine whether paid apps have higher rating than free apps
 
SELECT CASE
            WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END As App_Type,
       avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY App_Type ;

-- Check if apps with more supported languages have higher ratings

SELECT CASE 
             WHEN lang_num < 10 THEN '<10 Languages'
             when lang_num BETWEEN 10 AND 30 then '10-30 Languages'
             ELSE '>30 Languages'
       END as language_bucket,
       avg(user_rating) As Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating Desc ;

-- Check genres with low rating

SELECT prime_genre,
       avg(user_rating) as Avg_rating
FROM AppleStore
GROUP BY prime_genre
order BY Avg_rating Asc 
LIMIT 10 ;

-- check if there is correlation between the lenght of the app description and the user rating

SELECT CASE
            WHEN length(b.app_desc) <500 THEN 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
       end as description_length_bucket,
              avg(a.user_rating) as Average_rating
       
from AppleStore as a

JOin appleStore_description_combined as b
on a.id = b.id  

GROUP By description_length_bucket
ORDER BY Average_rating DESC ;
     
-- Check top-rated apps for each genre

SELECT 
       prime_genre,
       track_name,
       user_rating
From (
      SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK ()  OVER ( PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      from 
      AppleStore
     ) as a 
WHERE
a.rank = 1 ;
