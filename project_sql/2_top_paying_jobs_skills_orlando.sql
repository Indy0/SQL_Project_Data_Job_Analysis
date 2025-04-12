/*
Question: What are the top-paying data analyst jobs, and what skills are required? 
- Use the top 10 highest-paying Data Analyst jobs from first query.
- Add the specific skills required for these roles.
- Analyze the data by location, in Orlando or Remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
    It also allows job seekers to compare which skills are valued in Orlando and Remote job postings.
*/


WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%Orlando%' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;


/*
Here's the breakdown of the most in demand skills for data analysts in 2023,
    based on job postings in Orlando:
- SQL and its ecosystem (T-SQL, SQL Server, SSIS, SSRS) dominate the Orlando market, appearing in 8 out of the 10 postings.
- Power BI is the top data visualization tool in Orlando, more common than Tableau, in 5 out of 10 jobs.
- Cloud platforms (AWS, GCP, Azure) are mentioned, but less frequently, suggesting they're useful but not yet essential.
- The Orlando roles are slightly more focused on Microsoft technologies and BI/reporting systems compared to the remote jobs sample.
*/