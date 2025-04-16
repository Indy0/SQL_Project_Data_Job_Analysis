# Introduction
This project focuses on analysing the job market for data analyst roles. It explores top paying jobs, high-demand skills, and where high demand meets high salary in data analytics.

SQL queries can be found here: [project_sql](/project_sql/)

# Background
I chose to analyze the data analyst job market as a way to understand the most optimal learning path in my journey to become a data analyst.
By understanding the most in-demand skills and top-paying roles I am able to learn what the most valuable skills in the market are. I then choose what to spend time learning and mastering in order to effectively navigate the job market.

The data comes from Luke Barousse's [SQL Course](https://www.lukebarousse.com/sql), whom I learned all about SQL from.

### The questions I answered through my SQL queries and analysis:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

I also filtered the data to only include  data analyst roles in Orlando or offered remotely as these are the positions I want to pursue.

# Tools I Used
Through analyzing the data analyst job market I used and gained experience using several relevant tools:
- **SQL**: The core of the analysis, SQL allowed me to query the database and create insights.
- **PostgreSQL**: The relational database management system I used, chosen for it's capability in handling the job posting data and it's relevance in the job market.
- **Visual Studio Code**: My primary code editor I used to write SQL scripts, manage project files, and query the database.
- **Git & GitHub**: Essential for version control, tracking the progress of the project over time, and sharing my SQL scripts and analysis.

# The Analysis
Each query gains specific insight into different areas of the data analyst job market. Here is how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest paying roles I filtered data analyst positions by average yearly salary and location, including only jobs in Orlando or remote. This query highlights the highest paying roles in the field, allowing me to do further analysis later on and is a strong motivator for me to continue my studies!

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%Orlando%' OR job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here are some insights into some of the top data analyst jobs:
- **Wide Salary Range:** The top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among the highest salaries, showing broad interest across differing industries.
- **Job Title Variety:** There is a high diversity of job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specilizations within the field.

![Top Paying Roles](assets\top_paying_data_jobs_2023_short.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts, created in google sheets*

### 2. Skills Required For Top-Paying Jobs
To identify the most relevant skills required for the top paying data analyst positions, I created a CTE to isolate the top 10 paying jobs (from query 1) and joined the skills tables. This join allowed me to list the skills associated with each of the top-paying jobs. I filtered the data to only include data analyst positions and created two seperate queries for each location, Orlando and remote. This allows me to compare which skills are more valuable in the Orlando and remote job markets.
```sql
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
```
Some insights into the top-paying skills:
- **Core Technical Skills:** Tools like SQL, Python, and Excel consistently appear across top-paying listings.

- **Visualization Tools:** High-paying jobs often require experience with Power BI, Tableau, or other BI tools.

- **Market Comparison:** Orlando has a stronger emphasis on Microsoft's database ecosystem and Power BI while the remote market emphasizes data science and engineeering tools reflecting more advanced analytics roles.

![Skills Required In Top Paying Roles](assets\top_10_skills_required_in_top_paying_roles.png)
*Bar graph visualizing the frequency of skills in the top data analyst roles for Orlando and remote markets, created in google sheets*


### 3. In-Demand Skills for Data Analysts
This query identified the most frequently requested skills in job postings, allows me to see the skills with the highest demand in the market.
```sql
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
```
Here is a breakdown of the most in-demand skills for 2023:
- **SQL** and **Excel** are fundamental, topping both Orlando and remote markets, emphasizing strong foundational skills in data processing.
- **Programming** and **Visualization Tools** Python, Tableau, and Power BI are essential in both markets, but the Orlando market prefers visualization tools more while the remote market prefers python.

| Skills    | Demand Count |
|-----------|--------------|
| SQL       | 7,644        |
| Excel     | 4,898        |
| Python    | 4,457        |
| Tableau   | 3,924        |
| Power BI  | 2,743        |
*Table of the demand for the top 5 skills in data analyst job postings for Orlando and remote markets*

### 4. Skills Based on Salary
This query explores the average salaries associated with each skill, gaining insight into which skills are the highest paying in the Orlando and remote markets.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS average_skill_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_work_from_home = TRUE OR job_location LIKE '%Orlando%')
GROUP BY
    skills
ORDER BY
    average_skill_salary DESC;
```
Here is a breakdown of the top paying skills for data analysts in both job markets:
- **High Demand for Big Data & ML Skills:** Top salaries are associated with skills in big data technologies, machine learning tools, and python libraries, reflecting the industry's high value on predictive modeling.
- **Software Development and Deployment:** Knowledge on development and deployment tools provides high pay indicating a value on the crossover between data analysis and engineering.
- **Cloud Computing Expertise:** Familiarity with cloud engineering tools shows the growing importance of cloud-based analytical environments and in-turns increases pay potential.

| Skill          | Average Salary  |
|----------------|-----------------|
| PySpark        | $208,172        |
| Bitbucket      | $189,155        |
| Watson         | $160,515        |
| Couchbase      | $160,515        |
| DataRobot      | $155,486        |
| GitLab         | $154,500        |
| Swift          | $153,750        |
| Jupyter        | $152,777        |
| Pandas         | $151,821        |
| Elasticsearch  | $145,000        |
*Table of the average salary for each of the top 10 paying skills for data analysts in Orlando and remotely.*

### 5. Most Optimal Skills to Learn
To combine all of the data and insights I gathered, I used this query to find skills that have both high demand and high salaries. This provides me the most optimal skills for skill and career development.
```sql
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
```
Here are some interesting insights into the most optimal skills for data analysts in 2023:
- **High-Demand Programming Languages:** Python and R stand out with high demand counts but lower average salaries, indicating that language profiency is highly valued but widely available.
- **Cloud Tools and Technology:** Skills in cloud technologies such asd azure, aws, and snowflake show high demand and high salaries, emphasizing the importance of cloud tools.
- **Orlando vs. Remote Market:** Orlando has a stronger emphasis on Microsoft technologies, pointing towards a more traditional BI environment while the remote market has a higher salary range for more technical roles.

| Skill        | Demand    | Avg. Salary |
|--------------|-----------|-------------|
| Power BI     | 7         | $105,000    |
| SQL Server   | 6         | $101,428    |
| T-SQL        | 5         | $111,000    |
| Azure        | 3         | $106,667    |
| AWS          | 3         | $106,667    |
| GCP          | 3         | $106,667    |
| Snowflake    | 1         | $108,567    |
| C++          | 1         | $106,700    |
| SAP          | 1         | $103,700    |
| SharePoint   | 1         | $103,700    |
*Table of the 10 most optimal skills for data analysts in 2023 for the Orlando market, sorted by demand.*

# What I Learned
Throughout this project, I learned many aspects of data analysis and now feel confident to continue analyzing real-world data and developing my skills. By being able to think on my own, make mistakes, and learn from those mistakes I feel I have gained valuable experience in these areas:

- **Asking Good Questions:** Throughout this project I found myself being curious about certain relationships in the data and asking myself questions about it. Then I would create complex queries to be able to gain some insights, which would lead to more questions, tweaking queries, refinement, and analysis. Being curious about the data, asking questions, and telling a story is one of the strongest skills I have strengthened.
- **Complex Query Making:** Created advanced SQL queries with table merging, subqueries and CTEs, and WITH clauses to harbor advanced insights in the data. 
- **Data Aggregation:** Gained experience in aggregating large data sets with tools like GROUP BY, COUNT(), and AVG(), combining multiple aggregations to answer questions.
- **Real-World Analysis:** Gained experience and comfort working with real-world data sets while also improving real-world problem solving skills, turning questions into actionable and insightful SQL queries.

# Conclusions

### Insights
1. **Data Analyst Pay and Employer Range:** Data Analyst roles are wide and varied across the market. There is a wide range of salaries, a very diverse range of employers in every industry, and many job titles within the Data Analysis field. This indicates a promising, diverse field I will be joining with lots of room for growth, skill development, and opportunity!
2. **Skills for Top-Paying Jobs:** Even the highest paying jobs require strong proficiency in foundational skills like SQL, meaning it is a critical skill for earning high salaries. In order to earn the highest salaries, advanced specialization into certain areas and skillsets is required.
3. **Most In-Demand Skills:** SQL is the most demanded skill in the market, making it essential for job seekers and offering many opportunities across the market.
4. **Skills With Higher Salaries:** Specialization into areas such as Big Data, Machine Learning, Software Development, and Cloud Computing are associated with higher salaries, indicating strong value on niche expertise.
5. **Optimal Skills for Job Market:** SQL has high demand and offers above average salaries, positioning the skill as one of the most optimal skills for data analysts to learn to maximize their market value. SQL combined with Business Intelligence tools offer a variety of roles across the Orlando and remote markets and offer above average salaries, indicating a solid synergy essential for job seekers to learn.

### Closing Thoughts

This project was both valuable for my learning journey and also very enjoyable! To be able to work on one data set and become familiar with it over a long period of time allowed me to develop a curiosity about the data and think of challenging, insightful questions I could then investigate. This led me to want to come back and work on the data more and more to create deeper insights which would create more questions which was quite fun!

This project greatly enhanced my SQL skills and confidence in my ability to use SQL to answer real-world questions. I also gained valuable insight into the data analyst job market tailored to my specific location. The findings from this analysis serve as a guide in my learning path and job seek journey by prioriting certain skill developments. Aspiring data analysts can better position themselves in a competitive market by choosing to learn high-demand, high-salary skills with their valuable time. Further exploration highlights the importance of lifelong learning and adaptation to trends in the field of data analytics.