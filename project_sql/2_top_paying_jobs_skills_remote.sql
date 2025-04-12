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
        job_location = 'Anywhere' AND
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
    based on Remote job postings:
- Core skills like SQL and Python are foundational and appear in 8 out of the 10 highest-paying roles.
- Data visualization tools like Tableau are highly valued, in 6 out of 10 jobs.
- Libraries like Pandas and spreadsheet proficiency (Excel) are still in demand, in 3 out of the 10 jobs.
- Other skills like R, Snowflake and Pandas show varying degrees of demand.
*/