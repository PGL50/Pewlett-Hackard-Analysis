# Overview of the Pewlett-Hackard-Analysis. 

### A manager at this company has requested some information on retiring employees as well as employess who are eligible for a mentorship program. Eligibility in both of these are base on the birth date of the employees. The PostGreSQL database created contains tables with infomration on employees, managers, department, employees department, titles and salaries. The analyses will be used to help the company prepare for the large number of retiring employees.

## Deliverable 1: The Number of Retiring Employees by Title

### The following code selects info from joined employees and titles tables with DOB in 1952-55 and creates a new table - retirement_titles
``` SQL
-- Create a Retirement Titles table for employees
-- Eligibility for retirement based on DOB in 1952-55
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER by e.emp_no ;
```

### The resulting table is a list of all employees with DOB in 1952 and their job titles (Multiple titles per employee)
![Retirement Titles](./Resources/retirement_titles.png) 

### The following code selects info from the retirement_titles tables and selects the most recent title along with first and last name and saves it into a new table -- unique_tables

```SQL
-- Use Distinct with Orderby to remove duplicate rows
--create a Unique Titles table that contains the employee number, 
--first and last name, and most recent title
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles
FROM retirement_titles rt
ORDER BY rt.emp_no, rt.to_date DESC;
```

### The resulting table is a list of all retirement eligible employees and their most recent job title
![Unique Titles](./Resources/unique_titles.png) 

### The following code selects info from the unique_titles tables and counts the number of employees with each title into a new table - retiring_titles

```SQL
--create a Retiring Titles table that contains the number of titles 
--filled by employees who are retiring
SELECT DISTINCT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC ;
```
### The resulting table is a list of all job titles with the total number of retiring employees within each title
![Retiring Titles](./Resources/retiring_titles.png) 

## Deliverable 2: The Employees Eligible for the Mentorship Program

### The following code selects info from the joined employees, dept_emp and titles tables. The mentorship eligibility is based on DOB in 1965 and employment to_date = '9999-01-01' to signify current employee. The results are saved in a new table -- mentorship_eligibilty

```SQL
-- create a Mentorship Eligibility table for current employees with DOB in 1965
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
    e.first_name,
    e.last_name,
	e.birth_date,
	d.from_date,
	d.to_date,
    t.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as d ON (e.emp_no=d.emp_no)
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
WHERE d.to_date = ('9999-01-01')
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER by e.emp_no, d.to_date DESC;
```

### The resulting table is a list of all the mentorship eligible employees
![Mentorship Eligible](./Resources/mentorship_eligibilty.png) 

## Results

-   A large percentage of Total Employees are of retirement age (90,398/300,024 = 30.1%)
    - Total Employees = 300,024
    ```SQL 
    select count(emp_no) as "Total Employees" from employees 
    ```
    ![Total Employees](./Resources/total_employees.png)

    - Total Retirement Eligible Employees = 90,398

    ![Retiring Titles](./Resources/retiring_titles.png) 

-   More than 2/3 of the Retirement Eligible Employees are in Senior or Leadership positions (68.8%)
    - Senior Engineer-29,414 + Senior Staff-28,254 + Technique Leader-4,502 + Manager-2 = 62,172
        - 62,172/90,398 = 68.8%
-   There are only 1,549 Employees in the mentorship eligible category; less than 1% of the total employees (1,549/300,024 = 0.52%)
    ```SQL
    select count(*) as "Mentees" from mentorship_eligibilty ;
    ```
    ![Mentee Totals](./Resources/mentees_total.png) 

-   Only 815 on the mentees are in Senior or Leadership positions
    - Senior Engineer-169 + Senior Staff-569 + Technique Leader-77= 815
    ```SQL
    select title, count(emp_no) as "Total Mentorship Employees"
    from mentorship_eligibilty
    group by title
    order by count(emp_no) desc ;
    ```
    ![Mentee Titles](./Resources/mentees_titles.png) 

## Summary and Further Analyses

1. How many roles will need to be filled as the "silver tsunami" begins to make an impact?
- New code to look at number of retiring employees by age (DOBYear) to see how many may be leaving by year. 
    ```sql
    SELECT u.emp_no,
        u.first_name,
        u.last_name,
        u.title,
	    e.birth_date,
	    date_part('year',e.birth_date) as DOBYear,
	    e.gender,
	    s.salary
    INTO retirement_salaries
    FROM unique_titles as u
    INNER JOIN employees as e ON (u.emp_no = e.emp_no)
    INNER JOIN salaries as s ON (u.emp_no = s.emp_no)
    ORDER by u.emp_no ;

    select DOByear, count(emp_no) as "Number of Employees"
    from retirement_salaries
    group by DOByear
    order by DOByear ;
    ```
    ![Retire by Year](./Resources/retiring_by_year.png) 

- Similar code was created to look at non Retiring employees by selecting those not in the unique_titles table
    ```sql
        SELECT 
 	        e.emp_no,
            e.first_name,
            e.last_name,
	        e.birth_date,
	        date_part('year',e.birth_date) as DOBYear
        INTO non_retirement_employees
        FROM employees as e
        WHERE emp_no NOT IN
            (SELECT emp_no 
            FROM unique_titles);
   ```

    ![Non Retire by Year](./Resources/nonretiring_by_year.png) 

- The number of employees is pretty constant by age until 1965, the year mentorship eligibilty starts. At that age the number of employees drops off considerably as seen below.

    ![Number by Year](./Resources/retiring_by_year_gr.png)  

- The charts below (grey is retirement age, yellow is mentorship age and blue is all others) shows that 2 positions of leadership (Senior Engineer, Senior Staff) have consistently similar number of employees until a large drop off at mentorship age. Technique Leaders show some signs of decreasing numbers from DOB Year 1961-1964 and a very large drop off again at mentorship age. Only 2 of the Managers will be retiring but there are also very few Managers in the entire company.

    ![Retire by Title Year](./Resources/retiring_by_title_gr.png) 
    ![Retire by Title Year](./Resources/managers_by_year.png)     

- As seen above in the Results section there are 62,172 retiring employees that are in senior or leadership roles. These will have to be filled by the current employees in similar roles or by promoting from lower roles. The retirees represent a large number of employees. In the very short term there will probably be enough people to get by. The serious problem is the lack of new employees in the mentorship eligible category. If that trend continues there will not be enough people to fill all the jobs lost to retirement.  
    &nbsp;

2.  Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
&nbsp;
- There is no question that there are plenty of non-retiring employees in Leadership positions to mentor the younger employees. The problem is the lack of new employees. Many of the retirees are at the Assistant Engineer, Engineer or Staff level. These level of positions are well filled by current employees. They may not be offering much mentoring to current employees in similar positions. The biggest problem for the future is attracting new employees.

&nbsp;
### How does Pewlett Hackard attract **new** employees?

- Let's take a look at the gender breakdown of non-retiring employees

```SQL
    select gender, count(emp_no) as "Number of Employees"
    from non_retirement_salaries
    group by gender ;
```
- There are 50% more male employees than female. Much stronger recruitment of female candidates need to take place.

![Number by Gender](./Resources/nonretiring_by_sex.png)   

- Here's another issue that could be addressed by the company. The salaries by DOB Year are the same regardless of the DOBYear which could be related to time on the job. There doesn't seem to be many increases available to employees.

```SQL
    select DOByear, cast(round(avg(salary),0) as money) as "Salary"
    from non_retirement_salaries
    group by DOByear ;
```
![Salaries](./Resources/nonretiring_salaries.png)  

- Below is code and output looking at time on the job and average salaries by job title. There are a couple of issues below is that Need to be addressed. 
```SQL
select title, cast(round(avg(salary),0) as money) as "Average Salary", 
    avg(age(to_date, from_date)) as years_on_job, 
    min(age(to_date, from_date)) as min,
    max(age(to_date, from_date) as max
from non_retirement_salaries
group by title
order by title ;
```
- No employess has worked there for more than a year. Clearly they need a way to retain current employees. The average salaries for roles are basically equal within job categories. All the Engineer positions have the same average salary regardless of seniority. The same is true of Staff and Senior Staff. 

![Salaries](./Resources/nonretiring_by_title_salary_time.png)  

![Salaries](./Resources/nonretiring_titles_gr.png)  