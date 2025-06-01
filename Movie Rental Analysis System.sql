-- Movie Rental Analysis System  -- 
CREATE DATABASE Movierental_DB
use Movierental_DB

-- MOVIE RENTAL TABLE --

CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(6, 2)
)

INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE)
VALUES
(100, 1, 'Action', '2025-02-01', '2025-02-03', 5),
(101, 2, 'Drama', '2025-02-05', '2025-02-06', 4),
(102, 1, 'Comedy', '2025-03-01', '2025-03-02', 3),
(103, 3, 'Action', '2025-03-10', '2025-03-12', 5),
(104, 2, 'Drama', '2025-03-15', '2025-03-17', 4),
(105, 4, 'Sci-Fi', '2025-04-01', '2025-04-03', 3),
(106, 3, 'Comedy', '2025-04-05', '2025-04-06', 2),
(107, 5, 'Action', '2025-04-10', '2025-04-11', 5),
(108, 4, 'Drama', '2025-04-15', '2025-04-17', 4),
(109, 5, 'Horror', '2025-04-20', '2025-04-22', 3),
(110, 1, 'Action', '2025-05-01', '2025-05-02', 4); 

SELECT * FROM RENTAL_DATA


-- Drill Down: Analyze rentals from genre to individual movie level --

SELECT GENRE, MOVIE_ID, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Rollup: Summarize total rental fees by genre and then overall --

SELECT
    GENRE,
    SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data
GROUP BY GENRE

UNION ALL

-- Get the grand total
SELECT
    'TOTAL' AS GENRE,
    SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data;

-- Cube: Analyze total rental fees across combinations of genre, rental date, and customer --

SELECT GENRE, SUM(RENTAL_FEE) AS total_fee
FROM   rental_data
GROUP  BY GENRE WITH ROLLUP;

-- Cube: Analyze total rental fees across combinations of genre, rental date, and customer --

SELECT GENRE,
       DATE_FORMAT(RENTAL_DATE, '%Y-%m') AS month,
       CUSTOMER_ID,
       SUM(RENTAL_FEE)                  AS total_fee
FROM   rental_data
GROUP  BY GENRE, month, CUSTOMER_ID
UNION ALL
SELECT GENRE,
       DATE_FORMAT(RENTAL_DATE, '%Y-%m'),
       NULL,
       SUM(RENTAL_FEE)
FROM   rental_data
GROUP  BY GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m')
UNION ALL
SELECT NULL, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM   rental_data
GROUP  BY CUSTOMER_ID
UNION ALL
SELECT NULL, NULL, NULL, SUM(RENTAL_FEE)
FROM   rental_data;

-- Slice: Extract rentals only from the ‘Action’ genre --

SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE is in 
the last 3 months --


SELECT *
FROM   rental_data
WHERE  GENRE IN ('Action', 'Drama')
  AND  RENTAL_DATE >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
