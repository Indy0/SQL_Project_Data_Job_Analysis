/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS average_skill_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_skill_salary DESC;


/*
Insights:
- AI, ML, and Data Engineering skills (TensorFlow, PyTorch, Hugging Face, Databricks)
    are consistently among the top earners.

- Cloud & DevOps tools (Terraform, VMware, Ansible, GitLab, GCP) command high salaries, 
    reflecting demand for scalable infrastructure skills.

- Specialized or niche technologies (Solidity, Couchbase, MXNet, Datarobot)
    often top the list due to low supply and emerging use cases.

Key Takeaway:
- Combining core data skills with high-demand, specialized tech (especially in AI and cloud)
    boosts earning potential for data analysts.
*/