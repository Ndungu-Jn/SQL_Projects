/*
What are the top_paying data analysis jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focus on job postings with specified salaries(remove nulls)
- why? Highlight the top-paying opportunities for data analysts, offering insights
*/

SELECT  
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
    
FROM     
    job_postings_fact
left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id   
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL

ORDER BY
    salary_year_avg DESC

LIMIT 10    