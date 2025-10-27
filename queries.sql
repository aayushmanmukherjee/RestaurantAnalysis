-- SETUP --------

-- Create database
CREATE DATABASE IF NOT EXISTS zomato CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
USE zomato;

-- Create table guwahati_restaurants
DROP TABLE IF EXISTS guwahati_restaurants;
CREATE TABLE guwahati_restaurants (
    res_id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(100),
    locality VARCHAR(255),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    zipcode VARCHAR(20),
    cuisines VARCHAR(255),
    average_cost_for_two DECIMAL(10,2),
    aggregate_rating DECIMAL(2,1)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Loading data into table
-- LOAD DATA LOCAL INFILE '/path/to/file.csv'
-- INTO TABLE guwahati_restaurants
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n';
-- IGNORE 1 ROWS;

-- Setting permissions
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

-- KPI QUERIES ---------

-- Total restaurants in Guwahati
SELECT COUNT(*) AS total_restros_in_guwahati FROM guwahati_restaurants;

-- Average rating overall
SELECT FORMAT(SUM(aggregate_rating)/COUNT(*),1) AS avg_overall_rating FROM guwahati_restaurants;

-- Median cost for two
SELECT FLOOR(COUNT(*)/2) FROM guwahati_restaurants; -- Gives the middle row value
SELECT average_cost_for_two
FROM guwahati_restaurants
ORDER BY average_cost_for_two
LIMIT 1 OFFSET 363; -- 363 is calculated using the prior statement which is the middle row value

-- CHART QUERIES ----------------

-- Average cost for two by locality
SELECT locality, FORMAT(AVG(average_cost_for_two),2) AS avg_cost_for_two 
FROM guwahati_restaurants 
GROUP BY locality 
ORDER BY avg_cost_for_two DESC;

-- Average rating by cuisine
SELECT cuisines, FORMAT(AVG(aggregate_rating),1) AS avg_rating
FROM guwahati_restaurants
GROUP BY cuisines
ORDER BY avg_rating DESC;

-- Top 10 restros and their location
SELECT name, cuisines, latitude, longitude
FROM guwahati_restaurants
ORDER BY aggregate_rating LIMIT 10;

-- Cost VS Rating
SELECT locality, FORMAT(AVG(average_cost_for_two),2) AS avg_cost_by_locality, FORMAT(AVG(aggregate_rating),1) AS avg_rating_by_locality
FROM guwahati_restaurants
GROUP BY locality
ORDER BY avg_rating_by_locality DESC;

-- Localities with high rating but low average cost (good opportunities)
SELECT locality, FORMAT(AVG(aggregate_rating),1) AS avg_rating,  FORMAT(AVG(average_cost_for_two),2) AS avg_cost, COUNT(name) AS number_of_restaurants
FROM guwahati_restaurants
GROUP BY locality
HAVING AVG(aggregate_rating) > 3.5 
   AND AVG(average_cost_for_two) < 1000
ORDER BY AVG(aggregate_rating) DESC;