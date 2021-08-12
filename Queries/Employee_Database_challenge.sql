-- Deliverable 1: The Number of Retiring Employees by Title
-- Create a Retirement Titles table for employees
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

--create a Retiring Titles table that contains the number of titles 
--filled by employees who are retiring
SELECT DISTINCT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC ;

--Deliverable 2: The Employees Eligible for the Mentorship Program
-- create a Mentorship Eligibility table for current employees 
-- DROP TABLE mentorship_eligibilty
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
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
AND d.to_date = ('9999-01-01')
ORDER by e.emp_no, d.to_date DESC;

-- select count(*) from mentorship_eligibilty

---NEW Tables
--Total employees with titles
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
	date_part('year', e.birth_date) as birth_year,
    t.title,
    t.from_date,
    t.to_date
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
ORDER by e.emp_no ;

--Total employees by title
SELECT DISTINCT COUNT(e.emp_no), title
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
GROUP BY title
ORDER BY COUNT(e.emp_no) desc;

--Non-Retiring employees by title
SELECT DISTINCT COUNT(e.emp_no), title
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
WHERE e.birth_date NOT BETWEEN '1965-01-01' AND '1965-12-31'
GROUP BY title
ORDER BY COUNT(e.emp_no) desc;

--Non-Retiring current employees by title
SELECT DISTINCT COUNT(e.emp_no), title
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
INNER JOIN dept_emp as d ON (e.emp_no=d.emp_no)
WHERE e.birth_date NOT BETWEEN '1952-01-01' AND '1955-12-31'
AND d.to_date = ('9999-01-01')
GROUP BY title
ORDER BY COUNT(e.emp_no) desc;

--- Look at salaries of retiring people
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date,
	s.salary
INTO retirement_salaries
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
INNER JOIN salaries as s ON (e.emp_no = s.emp_no)
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER by e.emp_no ;

select avg(salary), title
from retirement_salaries
group by title ;
