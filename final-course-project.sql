-- TASK 1
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    job_position VARCHAR(255) NOT NULL,
    salary NUMERIC(8, 2),
    start_date DATE NOT NULL,
    birth_date DATE NOT NULL,
    -- store_id INT REFERENCES store(store_id),
    -- department_id INT REFERENCES departments(department_id),
    -- manager_id INT REFERENCES store(manager_staff_id)
    store_id INT,
    department_id INT,
    manager_id INT
)


-- TASK 1.1
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department VARCHAR(255) NOT NULL,
    division VARCHAR(255) NOT NULL
)


-- TASK 2
ALTER TABLE employees ALTER COLUMN department_id SET NOT NULL;
ALTER TABLE employees ALTER COLUMN start_date SET DEFAULT CURRENT_DATE;
ALTER TABLE employees ADD COLUMN IF NOT EXISTS end_date DATE;
ALTER TABLE employees ADD CONSTRAINT birth_check CHECK(birth_date < CURRENT_DATE);
ALTER TABLE employees RENAME COLUMN job_position TO position_title;
-- ALTER TABLE employees DROP CONSTRAINT employees_store_id_fkey;
-- ALTER TABLE employees DROP CONSTRAINT employees_department_id_fkey;
-- ALTER TABLE employees DROP CONSTRAINT employees_manager_id_fkey;


-- TASK 3
INSERT INTO employees
    (emp_id, first_name, last_name, position_title, salary, start_date, birth_date, store_id, department_id, manager_id, end_date)
VALUES 
    (1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
    (2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
    (3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
    (4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
    (5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
    (6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
    (7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
    (8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
    (9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
    (10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
    (11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
    (12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
    (13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
    (14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
    (15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
    (16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
    (17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
    (18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
    (19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
    (20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
    (21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
    (22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
    (23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
    (24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
    (25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
    (26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL)


-- TASK 3.1
INSERT INTO departments
    (department_id, department, division)
VALUES
    (1, 'Analytics', 'IT'),
    (2, 'Finance', 'Administration'),
    (3, 'Sales', 'Sales'),
    (4, 'Website', 'IT'),
    (5, 'Back Office', 'Administration')


-- TASK 4
UPDATE employees
SET position_title = 'Senior SQL Analyst', salary = salary + 7200
WHERE first_name = 'Jack' AND last_name = 'Franklin'


-- TASK 4.1
UPDATE employees
SET position_title = 'Customer Specialist'
WHERE position_title = 'Customer Support'


-- TASK 4.2
UPDATE employees
SET salary = salary * 1.06
WHERE position_title IN ('SQL Analyst', 'Senior SQL Analyst')


-- TASK 4.3
SELECT ROUND(AVG(salary), 2)
FROM employees
WHERE position_title = 'SQL Analyst'


-- TASK 5
SELECT employees.*,
CASE 
    WHEN employees.end_date IS NOT NULL THEN 'false'
    WHEN employees.end_date IS NULL THEN 'true'
END AS is_active,
CONCAT(manager_.first_name, ' ', manager_.last_name) AS manager
FROM employees
LEFT JOIN employees AS manager_
ON employees.manager_id = manager_.emp_id


-- TASK 5.1
CREATE VIEW v_employees_info
AS
SELECT employees.*,
CASE 
    WHEN employees.end_date IS NOT NULL THEN 'false'
    WHEN employees.end_date IS NULL THEN 'true'
END AS is_active,
CONCAT(manager_.first_name, ' ', manager_.last_name) AS manager
FROM employees
LEFT JOIN employees AS manager_
ON employees.manager_id = manager_.emp_id


-- TASK 6
SELECT position_title, ROUND(AVG(salary), 2) AS average_salary
FROM employees
WHERE position_title IN ('Software Engineer')
GROUP BY position_title


-- TASK 7
SELECT department, ROUND(AVG(salary), 2) AS average_salary
FROM employees
LEFT JOIN departments
ON employees.department_id = departments.department_id
WHERE department IN ('Sales')
GROUP BY departments.department_id


-- TASK 8
CREATE MATERIALIZED VIEW mv_average_position_salaries AS
    SELECT position_title, ROUND(AVG(salary), 2) AS average_position_salary
    FROM employees
    GROUP BY position_title

SELECT emp_id, first_name, last_name, employees.position_title, salary, average_position_salary
FROM employees
LEFT JOIN mv_average_position_salaries
ON employees.position_title = mv_average_position_salaries.position_title
ORDER BY emp_id


-- TASK 8.1
SELECT COUNT(emp_id)
FROM employees
LEFT JOIN mv_average_position_salaries
ON employees.position_title = mv_average_position_salaries.position_title
WHERE
end_date IS NULL AND -- do we exclude people who already left the company?
salary < average_position_salary


-- TASK 9
SELECT emp_id, salary, start_date,
SUM(salary) OVER(ORDER BY start_date) AS running_total_of_salary
FROM employees


-- TASK 10
SELECT emp_id, salary, start_date,
SUM(salary) OVER(ORDER BY start_date) AS running_total_of_salary
FROM employees
WHERE end_date IS NULL


-- TASK 11
SELECT first_name, position_title, salary
FROM employees
WHERE position_title IN ('SQL Analyst')
ORDER BY salary DESC
LIMIT 1


-- TASK 11.1
SELECT first_name, employees.position_title, salary, average_position_salary
FROM employees
LEFT JOIN mv_average_position_salaries
ON employees.position_title = mv_average_position_salaries.position_title
ORDER BY salary DESC


-- TASK 11.2
SELECT first_name, employees.position_title, salary, average_position_salary
FROM employees
LEFT JOIN mv_average_position_salaries
ON employees.position_title = mv_average_position_salaries.position_title
ORDER BY salary DESC


-- TASK 12
SELECT division, department, position_title, SUM(salary), COUNT(emp_id), ROUND(AVG(salary))
FROM employees
LEFT JOIN departments
ON employees.department_id = departments.department_id
GROUP BY
ROLLUP(
    division,
    department,
    position_title
)
ORDER BY division, department, position_title


-- TASK 13
SELECT emp_id, position_title, department, salary, 
RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM employees
LEFT JOIN departments
ON employees.department_id = departments.department_id


-- TASK 14
SELECT emp_id, position_title, department, salary, 
FIRST_VALUE(emp_id) OVER(PARTITION BY department ORDER BY salary DESC) AS top_earner
FROM employees
LEFT JOIN departments
ON employees.department_id = departments.department_id
WHERE department IN ('Finance')
LIMIT 1