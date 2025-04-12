/*
Question: What are the most optimal skills to learn (highest demand and highest paying skills)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on positions in Oralndo with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data anlaysis
*/


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skillS_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location LIKE '%Orlando%'
GROUP BY
    skills_dim.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;