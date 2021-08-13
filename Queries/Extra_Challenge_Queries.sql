---NEW Tables for Deliverable 3

select count(emp_no) as "Total Employees" from employees

-- Find remaining employees not retirement age
--DROP TABLE non_retirement_employees
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

select count(emp_no) as "Total Employees" from non_retirement_employees

--Total non retiring employees by title
--DROP TABLE nonretirement_titles
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
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
into retirement_salaries_out
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
	s.salary
INTO non_retirement_salaries
FROM unique_titles_nonretiring as u
INNER JOIN employees as e ON (u.emp_no = e.emp_no)
INNER JOIN salaries as s ON (u.emp_no = s.emp_no)
ORDER by u.emp_no ;

select count(*) from non_retirement_salaries ; 

select DOByear, count(emp_no) as "number of Employees", cast(round(avg(salary),0) as money) as "Average Salary"
from non_retirement_salaries
-- where dobyear != 1965
group by DOByear
order by DOByear ;

select DOByear, title,cast(round(avg(salary),0) as money) as "Average Salary", count(emp_no) as "number of Employees"
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

select DOByear, count(emp_no) as "number of Employees", round(avg(salary),0) as "Salary"
from non_retirement_salaries
where dobyear != 1965
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
