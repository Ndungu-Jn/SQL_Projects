/*
quiz ; What are the most optimal skills to learn(its in high demand and a high paying skill)
 -- Identify skills in high demand and associated with high average salaries for Data Analyst roles
 -- Concentrates on remote positions with specified salaries
*/

-- create a cte from 3
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS (       --- this is another cte. this is how to use if there are several ctes in a query.
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0)as avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND
        salary_year_avg IS NOT NULL
    GROUP BY
       skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id    
WHERE
    demand_count > 10
ORDER BY 
    demand_count DESC,
    avg_salary DESC

limit 25         