SELECT *
FROM january_jobs;

SELECT *
FROM february_jobs;

SELECT *
FROM march_jobs;

-- Learning Unions -- Combines results from two or more SELECT statements
-- needs to have the same amount of columns, and the data types must match

/*
i.e
SELECT column_name
FROM table_one;

UNION -- COMBINES THE TWO TABLES

SELECT column_name
FROM table_two;
*/

-- Getting jobs and companies from January
SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    january_jobs  

UNION

-- Getting jobs and companies from February 
SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    february_jobs

UNION    

-- Getting jobs and companies from March
SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    
    
-- UNION ALL -- Return all rows, even duplicates. so whenever union all is used, data returned is more

SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    january_jobs  

UNION ALL

-- Getting jobs and companies from February 
SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    february_jobs

UNION ALL  

-- Getting jobs and companies from March
SELECT 
    job_title_short,
    company_id,
    job_location
FROM  
    march_jobs