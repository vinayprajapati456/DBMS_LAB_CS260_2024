-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS company_database;
USE company_database;

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Insert data into the departments table
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Engineering', 'New Delhi'),
(2, 'Sales', 'Mumbai'),
(3, 'Finance', 'Kolkata');

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert data into the employees table
INSERT INTO employees (emp_id, first_name, last_name, salary, department_id) VALUES
(1, 'Rahul', 'Kumar', 60000, 1),
(2, 'Neha', 'Sharma', 55000, 2),
(3, 'Krishna', 'Singh', 62000, 1),
(4, 'Pooja', 'Verma', 58000, 3),
(5, 'Rohan', 'Gupta', 59000, 2);

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget DECIMAL,
    start_date DATE,
    end_date DATE
);

-- Insert data into the projects table
INSERT INTO projects (project_id, project_name, budget, start_date, end_date) VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');


---Question 1
SELECT * 
FROM employees 
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering');

--Question 2
SELECT first_name, salary 
FROM employees;

---Question 3
SELECT * 
FROM employees 
WHERE emp_id IN (SELECT manager_id FROM departments);

---Question 4
SELECT * 
FROM employees 
WHERE salary > 60000;


--Question 5
SELECT * 
FROM employees 
JOIN departments ON employees.department_id = departments.department_id;


--Question 6
SELECT * 
FROM employees CROSS JOIN projects;


--Question 7
SELECT * 
FROM employees 
WHERE emp_id NOT IN (SELECT manager_id FROM departments WHERE manager_id IS NOT NULL);


--Question 8
SELECT * 
FROM departments NATURAL JOIN projects;


---Question 9
SELECT department_name, location 
FROM departments;


---Question 10
SELECT * 
FROM projects 
WHERE budget > 100000;


--QUestion 11
SELECT * 
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
WHERE department_name = 'Sales' AND manager_id IS NOT NULL;


----Question 12
SELECT first_name, salary 
FROM employees 
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering')
UNION
SELECT first_name, salary 
FROM employees 
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance');


------Question 13
SELECT * 
FROM employees 
WHERE emp_id NOT IN (SELECT emp_id FROM projects);



----Question 14
SELECT * 
FROM employees 
LEFT JOIN projects ON employees.emp_id = projects.emp_id;


---Question 15
SELECT * 
FROM employees 
WHERE salary < 50000 OR salary > 70000;


