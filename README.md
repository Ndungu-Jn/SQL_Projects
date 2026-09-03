# Introduction
Dive into the data job market! This project focuses on data analyst roles, exploring 💰 top-paying jobs, 🔥 in-demand skills, and where high demand meets high salary in data analytics.

SQL queries: [The_project folder](/The_project/)

# Background
This project was born from a desire to navigate the data analyst job market more effectively. It aims to pinpoint top-paid and in-demand skills, streamlining the job search for others looking to find optimal jobs.

Data comes from a SQL course job postings dataset, packed with details on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn (high demand **and** high salary)?

# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job postings data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs (`job_location = 'Anywhere'`).

```sql
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
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

**Results:**

| Job Title | Company | Salary (yr avg) | Schedule |
|---|---|---:|---|
| Data Analyst | Mantys | $650,000 | Full-time |
| Director of Analytics | Meta | $336,500 | Full-time |
| Associate Director- Data Insights | AT&T | $255,830 | Full-time |
| Data Analyst, Marketing | Pinterest Job Advertisements | $232,423 | Full-time |
| Data Analyst (Hybrid/Remote) | Uclahealthcareers | $217,000 | Full-time |
| Principal Data Analyst (Remote) | SmartAsset | $205,000 | Full-time |
| Director, Data Analyst - HYBRID | Inclusively | $189,309 | Full-time |
| Principal Data Analyst, AV Performance Analysis | Motional | $189,000 | Full-time |
| Principal Data Analyst | SmartAsset | $186,000 | Full-time |
| ERM Data Analyst | Get It Recruit - Information Technology | $184,000 | Full-time |


**Insight:** Salaries vary dramatically at the top end — the #1 role (Mantys) pays nearly double the #2 role (Meta), and almost 3.5x the #10 role. Beyond that outlier, most top-10 roles cluster between $184K–$256K, largely senior/principal/director-level positions rather than entry-level Data Analyst titles.

### 2. Skills for Top Paying Jobs
Joining the top 10 highest-paying jobs with the skills data shows what employers value for top-dollar positions.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```



**Insight:** Among the 10 highest-paying jobs, **SQL** appears in 8 of them, **Python** in 7, and **Tableau** in 6 — confirming these three as the core toolkit even at the senior/leadership level. Cloud and data-engineering-adjacent skills (**Snowflake**, **AWS**, **Azure**) also show up, suggesting the highest-paid analysts increasingly work close to data infrastructure, not just dashboards.

### 3. In-Demand Skills for Data Analysts
This query identifies the skills most frequently requested across **all** data analyst job postings (not just top-paying ones).

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

| Skill | Demand Count |
|---|---:|
| SQL | 92,628 |
| Excel | 67,031 |
| Python | 57,326 |
| Tableau | 46,554 |
| Power BI | 39,468 |


**Insight:** SQL is requested in nearly 93,000 postings — well ahead of Excel and Python. SQL and Excel together dominate demand, showing that even as Python/Tableau/Power BI grow in importance, foundational query and spreadsheet skills remain baseline requirements for the vast majority of data analyst roles.

### 4. Skills Based on Salary
Average salary associated with each skill for Data Analyst positions, regardless of location.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```


**Insight:** Niche and specialized tools top the salary list — **SVN** ($400,000, likely driven by a very small sample size of postings), **Solidity** ($179,000, reflecting blockchain/web3 demand), and **Couchbase** ($160,515). Big-data and ML-engineering-adjacent skills (**DataRobot**, **Kafka**, **PyTorch**, **TensorFlow**) also pay well above the market median, suggesting analysts who branch into engineering or ML tooling command a real salary premium.

### 5. Most Optimal Skills to Learn
Combining demand and salary data pinpoints skills that are both frequently requested **and** well paid — filtered to skills appearing in more than 10 postings among salaried remote roles for Data Analyst.

```sql
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
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
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
LIMIT 25;
```

| Skill | Demand Count | Avg Salary |
|---|---:|---:|
| SQL | 3,083 | $96,435 |
| Excel | 2,143 | $86,419 |
| Python | 1,840 | $101,512 |
| Tableau | 1,659 | $97,978 |
| R | 1,073 | $98,708 |
| Power BI | 1,044 | $92,324 |
| Snowflake | 241 | $111,578 |
| Spark | 187 | $113,002 |
| AWS | 291 | $106,440 |
| Azure | 319 | $105,400 |
| Looker | 260 | $103,855 |



**Insight:** **SQL, Excel, Python, Tableau, R,** and **Power BI** form the "high demand" cluster (top-right region by volume), while **Python** stands out as rare among that group in also paying well above average ($101,512). Lower-volume but high-salary skills like **Spark** ($113,002) and **Snowflake** ($111,578) represent a smaller but lucrative niche — a good "level-up" target once core skills are covered.

# What I learned
Throughout this project, I strengthened my SQL toolkit with:

- 🧩 **Complex Query Building**: Mastered advanced SQL, merging tables and using WITH clauses (CTEs) for temporary, reusable result sets.
- 📊 **Data Aggregation**: Got comfortable with `GROUP BY` and turned aggregate functions like `COUNT()` and `AVG()` into effective summarizing tools.
- 💡 **Analytical Wizardry**: Leveled up my real-world problem-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusion

### Insights
1. **Top-paying jobs**: Remote data analyst salaries range widely, from $184K up to $650K, with senior/director-level titles dominating the top 10.
2. **Skills for top-paying jobs**: SQL (8/10), Python (7/10), and Tableau (6/10) are the most common requirements among the highest-paid roles.
3. **Most in-demand skills**: SQL leads by a wide margin (92,628 postings), followed by Excel and Python — these remain the non-negotiable baseline skills.
4. **Skills with higher salaries**: Specialized skills like SVN, Solidity, and Couchbase command the highest average salaries, showing a premium on niche/technical expertise.
5. **Optimal skills**: SQL sits at the intersection of high demand and solid pay, while Python offers an unusually strong demand-to-salary ratio — making both smart priorities for skill development.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills like SQL and Python, while considering niche additions (Snowflake, Spark, cloud platforms) to stand out further.
