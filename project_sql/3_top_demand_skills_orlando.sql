/*
Question: What are the most in-demand skills for data analysts in Orlando?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst
- Focus on job postings in Orlando
- Why? Retrieves the top 5 skills with the highest demand in the Orlando job market,
    providing insights into the most valuable skills for job seeekers.
- Can be compared to remote job market skills to provide insights
*/


SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Orlando%'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;



/*
Comparing the Orlando and remote job markets:
- SQL and Excel are highly in-demand and dominate both markets
- Python, Power BI, and Tableau are the next three in demand skills in
    both markets
- In the Orlando market, Tableau and Power BI exceed Python,
    while in the remote market Python is more valuable
*/