SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

--convertion :: -->is used for the convertion
SELECT
    '2023-02-19' ::DATE,
    '123' :: INTEGER,
    'true' :: BOOLEAN,
    '3.14':: REAL;

--Highlighted and retuned only the date 
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date :: DATE AS date    
FROM
    job_postings_fact;

-- get and convert the timezones due to the difference in time
--POSTGRES documentation has the timezones outlined
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'  AS date    
FROM
    job_postings_fact
LIMIT 5;    

--EXTRACT -- Gets the field from a date/time value -- used in the SELECT statement.
--extracitng the month,  the  the year and then the day.
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'  AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,  
    EXTRACT(YEAR FROM job_posted_date) AS date_year,
    EXTRACT(DAY FROM job_posted_date) AS date_day
FROM
    job_postings_fact
LIMIT 5;  

-- a query to see hoy job postings are trending month to month
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact 
WHERE 
    job_title_short = 'Data Analyst'    
GROUP BY    
    month    
ORDER BY 
    job_posted_count DESC;

-- creating tables for the 1st three months
CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 1

CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month FROM job_posted_date) = 3;

-- CASE  EXPRESSIONS
--get the number of jobs thta are onsite, local and remote for Data Analayst.

SELECT  
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;