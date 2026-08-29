SELECT *
FROM( -- Subquery starts here - a query inside another query
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- subquery ends here 


-- CTEs -- Common table expressions
WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1  
) --  CTE definition ends here

SELECT *
FROM january_jobs


-- before
SELECT 
    company_id,
    job_no_degree_mention
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = true    

-- subquery version
SELECT name AS company_name
FROM company_dim
WHERE company_id IN (   
    SELECT 
    company_id,
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = true    

)