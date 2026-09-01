/*
Find the companies that have the most job openings
-Get the total number of job postings per company id (job_posting_fact)
-Return the total number of jobs with the company name(company_dim)
*/

-- Find the companies that have the most job openings
WITH company_job_count AS(
    SELECT  
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY  
        company_id
)

SELECT company_dim.name AS company_name,
       company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN 
    company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC    

/*
Find the count of the number of remote job posting per skill
    - Display the top 5 skills by their demand in remote jobs
    -Include skills ID, name, and count of postings requiring the skill
*/    

WITH remote_job_skills AS(
SELECT
    skill_id,
    COUNT(*) AS skill_count
   
FROM
    skills_job_dim AS skills_to_job 
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id    
WHERE
    job_postings.job_work_from_home = True and
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;   