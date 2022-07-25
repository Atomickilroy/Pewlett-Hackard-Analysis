SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

--1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '195-01-01' AND '1954-12-31';

--1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';


-- Narrowing the search
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Addin the COUNT function
SELECT COUNT(first_name)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Create a new table by adding the into statement

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');




--Drop retirement_info
DROP TABLE retirement_info; 


-- CREATE new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Check the table

SELECT * FROM retirement_info;



-- Joining the department and dept_manager tables

SELECT departments.dept_name,
	managers.emp_no,	
	managers.from_date,	
	managers.to_date
	
FROM departments
INNER JOIN managers
ON departments.dept_no = managers.dept_no;



-- Alais Practice

SELECT dm.dept_name,
	ma.emp_no,
	ma.from_date,
	ma.to_date
	
FROM departments as dm
INNER JOIN managers as ma
ON dm.dept_no = ma.dept_no;






-- Joining retirement_info and dept_emp tables

SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date

FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no =dept_emp.emp_no;

-- Alias Practice

SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date

FROM retirement_info as ri
LEFT JOIN dept_emp as de
on ri.emp_no = de.emp_no;


-- Left join retirement_info and dept_emp


SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date

INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');


-- Employees count by department number

SELECT COUNT (ce.emp_no), de.dept_no
INTO emp_count_by_dept

FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no

GROUP BY de.dept_no
ORDER BY de.dept_no;


-- 7.3.5 Employee Information

SELECT * FROM salaries

ORDER BY to_date DESC;

-- Still not the most recent 
-- Pull dates from dept_emp tbl

SELECT emp_no,
	first_name,
last_name,	
	gender
INTO emp_info
FROM employees

WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--join it to the salaries table to add the to_date and Salary columns 

SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date

INTO emp_info
FROM employees as e

INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)

INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department

SELECT dm.dept_no,
		d.dept_name,
		dm.emp_no,
		ce.last_name,
		ce.first_name,
		dm.from_date,
		dm.to_date
INTO manager_info

FROM managers as dm
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
		
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);

-- List 3

SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
	
INTO dept_info

FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

--7.3.6 Skill Drill Sales

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	di.dept_name
	
INTO sales_info
FROM retirement_info as ri
	INNER JOIN dept_info as di
		ON (ri.emp_no = di.emp_no)
		
WHERE (di.dept_name = 'Sales');

--7.3.6 Skill Drill Sales/Development

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	di.dept_name
	
INTO sales_dev_info
FROM retirement_info as ri
	INNER JOIN dept_info as di
		ON (ri.emp_no = di.emp_no)
		
WHERE di.dept_name IN('Sales','Development');

--SALES/DEV COUNT

SELECT COUNT (sd.emp_no), sd.dept_name

INTO sale_dev_count

FROM sales_dev_info AS sd

GROUP BY sd.dept_name;



-- Challenge 7 Delieverable 1
--The Number of Retiring Employees by Title

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.titles, 
	ti.from_date,
	ti.to_date
	
INTO retirement_titles 
FROM employees as e
	LEFT JOIN titles as ti
		ON (e.emp_no = ti.emp_no)

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) ri.emp_no,
ri.first_name,
ri.last_name,
ri.titles

INTO unique_titles
FROM retirement_titles AS ri

WHERE (ri.to_date = '9999-01-01')

ORDER BY emp_no , ri.to_date DESC;

--number of employees by their most recent job title who are about to retire

SELECT COUNT (ui.emp_no), ui.titles

INTO retiring_titles_count

FROM unique_titles AS ui

GROUP BY ui.titles
ORDER BY ui.count DESC;

SELECT DISTINCT ON (emp_no) e.emp_no,
	e.first_name,	
	e.last_name,
	e.birth_date, 
	de.from_date,
	de.to_date,
	ti.titles
	
-- Challenge 7 Delieverable 2
--The Employees Eligible for the Mentorship Program

SELECT DISTINCT ON (emp_no) e.emp_no,
	e.first_name,	
e.last_name,
	e.birth_date, 
	de.from_date,
	de.to_date,
	ti.titles
	
-- INTO mentorship_eligibilty 
FROM employees as e	

INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
		
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
			
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
	
ORDER BY emp_no , de.to_date DESC;

---
SELECT COUNT (me.emp_no), me.titles

INTO mentor_titles_count

FROM mentorship_eligibilty AS me

GROUP BY me.titles
ORDER BY me.count DESC;