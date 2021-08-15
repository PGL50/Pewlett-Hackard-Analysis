---NEW Tables for Deliverable 3

select count(emp_no) as "Total Employees" from employees

-- Find remaining employees not retirement age
--DROP TABLE non_retirement_employees
SELECT 
 	e.emp_no,
    e.first_name,
    e.last_name,
	e.birth_date,
	date_part('year',e.birth_date) as DOBYear,
	e.gender,
	e.hire_date
-INTO non_retirement_employees
FROM employees as e
WHERE emp_no NOT IN
  (SELECT emp_no 
   FROM unique_titles);

select count(emp_no) as "Total Employees" from non_retirement_employees

--Total non retiring employees by title
--DROP TABLE nonretirement_titles
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date,
	d.to_date as emp_to_date
INTO nonretirement_titles
FROM non_retirement_employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
INNER JOIN dept_emp as d ON (e.emp_no=d.emp_no)
ORDER by e.emp_no ;

select count(*) from nonretirement_titles

-- Get lst Title for non-retiring employees
--DROP TABLE unique_titles_nonretiring
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles_nonretiring
FROM nonretirement_titles rt
ORDER BY rt.emp_no, rt.to_date DESC;

select count(*) from unique_titles_nonretiring

--create a Non-Retiring Titles table that contains the number of titles 
--filled by current employees who are not retiring
--DROP TABLE nonretiring_titles
SELECT DISTINCT COUNT(title) as "Total Employees", title
INTO nonretiring_titles
FROM unique_titles_nonretiring
GROUP BY title
ORDER BY COUNT(title) DESC ;

select * from nonretiring_titles


--- Look at mentorship totals for bullet list Deliverable 3
select count(*) as "Mentees" from mentorship_eligibilty ;

select title, count(emp_no) as "Total Mentorship Employees"
from mentorship_eligibilty
group by title
order by count(emp_no) desc ;

--------------------------------
select * from unique_titles
--- Look at salaries of retiring people
--DROP TABLE retirement_salaries
SELECT u.emp_no,
    u.first_name,
    u.last_name,
    u.title,
	e.birth_date,
	date_part('year',e.birth_date) as DOBYear,
	e.gender,
	e.hire_date,
	s.salary
INTO retirement_salaries
FROM unique_titles as u
INNER JOIN employees as e ON (u.emp_no = e.emp_no)
INNER JOIN salaries as s ON (u.emp_no = s.emp_no)
ORDER by u.emp_no ;

select count(*) from retirement_salaries ;

-- select DOByear, round(avg(salary),0) as "Average Salary", count(emp_no) as "number of Employees"
select DOByear, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Average Salary"
from retirement_salaries
group by DOByear
order by DOByear ;

select DOByear, title, cast(round(avg(salary),0) as money) as "Average Salary", count(emp_no) as "number of Employees"
-- into retirement_salaries_out
from retirement_salaries
group by title ,DOByear
order by title ,DOByear ;

select gender, title, cast(round(avg(salary),0) as money) as "Average Salary", count(emp_no) as "number of Employees"
from retirement_salaries
group by title ,gender
order by title ,gender ;

select gender, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Salary"
from retirement_salaries
group by gender ;

select DOByear, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Salary"
from retirement_salaries
group by DOByear , gender ;


--- Look at salaries of non retiring people
select count(*) from unique_titles_nonretiring
--- Look at salaries of non retiring people
--DROP TABLE non_retirement_salaries
SELECT u.emp_no,
    u.first_name,
    u.last_name,
    u.title,
	e.birth_date,
	date_part('year',e.birth_date) as DOBYear,
	e.gender,
	s.salary,
	s.to_date,
	s.from_date
INTO non_retirement_salaries
FROM unique_titles_nonretiring as u
INNER JOIN employees as e ON (u.emp_no = e.emp_no)
INNER JOIN salaries as s ON (u.emp_no = s.emp_no)
ORDER by u.emp_no ;

select count(*) from non_retirement_salaries ; 

select Gender, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Average Salary"
from non_retirement_salaries
-- where dobyear != 1965
group by Gender
order by Gender ;

select DOByear, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Average Salary"
from non_retirement_salaries
-- where dobyear != 1965
group by DOByear
order by DOByear ;

select title, --salary, --count(emp_no) as "number of Employees", 
cast(round(avg(salary),0) as money) as "Average Salary"--, 
--age(to_date, from_date) as years_on_job
from non_retirement_salaries
-- where dobyear != 1965
group by  title
order by  title ;

select title, --dobyear, --salary, --count(emp_no) as "number of Employees", 
cast(round(avg(salary),0) as money) as "Average Salary", 
avg(age(to_date, from_date)) as years_on_job, min(age(to_date, from_date)) as min,max(age(to_date, from_date)) as max
from non_retirement_salaries
-- where dobyear != 1965
group by title--,dobyear
order by title--, dobyear ;

select DOByear, title,cast(round(avg(salary),0) as money) as "Average Salary", count(emp_no) as "Number of Employees"
into non_retirement_salaries_out
from non_retirement_salaries
group by title ,DOByear
order by title ,DOByear ;

select gender, title, cast(round(avg(salary),0) as money) as "Average Salary", count(emp_no) as "number of Employees"
from non_retirement_salaries
group by title ,gender
order by title ,gender ;

select gender, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Salary"
from non_retirement_salaries
group by gender ;

select DOByear, --count(emp_no) as "number of Employees", 
cast(round(avg(salary),0) as money) as "Salary"
from non_retirement_salaries
-- where dobyear != 1965
group by DOByear ;


--- Look at salaries of mentees
select count(*) from mentorship_eligibilty
select * from mentorship_eligibilty
--- Look at salaries of non retiring people
--DROP TABLE mentorship_salaries
SELECT u.emp_no,
    u.first_name,
    u.last_name,
    u.title,
	e.birth_date,
	date_part('year',e.birth_date) as DOBYear,
	e.gender,
	s.salary
INTO mentorship_salaries
FROM mentorship_eligibilty as u
INNER JOIN employees as e ON (u.emp_no = e.emp_no)
INNER JOIN salaries as s ON (u.emp_no = s.emp_no)
ORDER by u.emp_no ;

select count(*) from mentorship_salaries ; 
select * from mentorship_salaries ; 

select gender, title,round(avg(salary),0) as "Average Salary", count(emp_no) as "number of Employees"
from mentorship_salaries
group by title ,gender
order by title ,gender ;

select gender, count(emp_no) as "number of Employees", round(avg(salary),0) as "Salary"
from mentorship_salaries
group by gender ;


---Start from beginning to create full employee table
---DROP TABLE emp_all_data
SELECT e.emp_no,
    e.first_name,
    e.last_name,
	e.birth_date,
	e.gender,
	e.hire_date,
    t.title,
    t.from_date as title_from_date,
    t.to_date as title_to_date,
	s.salary,
	s.from_date as salary_from_date,
	s.to_date as salary_to_date,
	d.from_date as emp_from_date,
	d.to_date as emp_to_date,
	d.dept_no,
	de.dept_name as department
INTO emp_all_data
FROM employees as e
INNER JOIN titles as t ON (e.emp_no = t.emp_no)
INNER JOIN salaries as s ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as d ON (e.emp_no=d.emp_no)
INNER JOIN departments as de ON (d.dept_no=de.dept_no)
ORDER by e.emp_no ;

update emp_all_data
set emp_to_date = '2021-08-13'
where emp_to_date = '9999-01-01'

select *, 
date_part('year',age(emp_to_date, hire_date)) as years_on_job,
age(emp_to_date, hire_date) as years
from emp_all_data



---DROP TABLE emp_all_data_unique
-- Get distinct most recent title
SELECT DISTINCT ON (rt.emp_no)
    rt.*,
	date_part('year',age(emp_to_date, hire_date)) as years_on_job
INTO emp_all_data_unique
FROM emp_all_data rt
ORDER BY rt.emp_no, rt.title_to_date DESC;

select count(*) from emp_all_data_unique ;                     

SELECT distinct COUNT(title) as "Total Retiring Employees", title, avg(years_on_job) as years_on_job, cast(round(avg(salary),0) as money) as "Average Salary"
FROM emp_all_data_unique
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
GROUP BY title
ORDER BY COUNT(title) DESC ;

SELECT distinct COUNT(title) as "Total Retiring Employees", title, avg(years_on_job) as years_on_job, cast(round(avg(salary),0) as money) as "Average Salary"
FROM emp_all_data_unique
WHERE birth_date NOT BETWEEN '1952-01-01' AND '1955-12-31'
GROUP BY title
ORDER BY COUNT(title) DESC ;

SELECT distinct COUNT(emp_no) as "Total Retiring Employees", gender , avg(years_on_job) as years_on_job, cast(round(avg(salary),0) as money) as "Average Salary"
FROM emp_all_data_unique
WHERE birth_date NOT BETWEEN '1952-01-01' AND '1955-12-31'
GROUP BY gender
ORDER BY COUNT(emp_no) DESC ;


SELECT DISTINCT ON (emp_no) 
	emp_no,
    first_name,
    last_name,
	birth_date,
	emp_from_date,
	emp_to_date,
    title
FROM emp_all_data 
WHERE emp_to_date = ('9999-01-01')
AND birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER by emp_no, emp_to_date DESC;

SELECT DISTINCT ON (emp_no) 
	emp_no,
    first_name,
    last_name,
	birth_date,
	emp_from_date,
	emp_to_date,
    title
FROM emp_all_data 
WHERE emp_to_date = ('9999-01-01')
AND birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER by emp_no, emp_to_date DESC;

SELECT count(emp_no), title
FROM emp_all_data 
WHERE emp_to_date = ('9999-01-01')
AND birth_date BETWEEN '1965-01-01' AND '1965-12-31'
group by title
ORDER by title DESC ;



