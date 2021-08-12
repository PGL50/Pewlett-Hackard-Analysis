# Overview of the Pewlett-Hackard-Analysis. 

### A manager at this company has requested some information on retiring employees as well as employess who are eligible for a mentorship program. Eligibility in both of these are base on the birth date of the employees. The PostGreSQL database created contains tables with infomration on employees, managers, department, employees department, titles and salaries. The analyses will be used to help the company prepare for the large number of retiring employees.

## Deliverable 1: The Number of Retiring Employees by Title

### The following code selects info from joined employees and titles tables with DOB in 1952 and creates a new table - retirement_titles
``` SQL
-- Create a Retirement Titles table for employees
-- Eligibility for retirement based on DOB in 1952
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