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