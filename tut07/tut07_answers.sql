-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

CREATE DATABASE Assignment7;
USE Assignment7;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255),
    manager_id INT
);

INSERT INTO departments 
(department_id, department_name, location, manager_id) 
VALUES
(1, 'Engineering', 'New Delhi', 3),
(2, 'Sales', 'Mumbai', 5),
(3, 'Finance', 'Kolkata', 4);


CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees 
(emp_id, first_name, last_name, salary, department_id) 
VALUES
(1, 'Rahul', 'Kumar', 60000, 1),
(2, 'Neha', 'Sharma', 55000, 2),
(3, 'Krishna', 'Singh', 62000, 1),
(4, 'Pooja', 'Verma', 58000, 3),
(5, 'Rohan', 'Gupta', 59000, 2);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    budget DECIMAL(10, 2),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects 
(project_id, project_name, budget, start_date, end_date) 
VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');

-- QUESTION 1..........................................................................
DELIMITER //

CREATE PROCEDURE GetAverageSalary(IN dept_id INT)
BEGIN
    SELECT AVG(salary) AS average_salary
    FROM employees
    WHERE department_id = dept_id;
END //

DELIMITER ;

CALL GetAverageSalary(1); -- Replace 1 with the department_id you want to query

-- QUESTION 2............................................

DELIMITER //

CREATE PROCEDURE UpdateSalary(IN employee_id INT, IN salary_increase_percentage DECIMAL(5,2))
BEGIN
    UPDATE employees
    SET salary = salary * (1 + (salary_increase_percentage / 100))
    WHERE emp_id = employee_id;
END //

DELIMITER ;

CALL UpdateSalary(1, 10); -- This will increase the salary of the employee with emp_id 1 by 10%

-- QUESTION 3.........................................................

DELIMITER //

CREATE PROCEDURE ListEmployeesByDepartment(IN dept_id INT)
BEGIN
    SELECT * FROM employees
    WHERE department_id = dept_id;
END //

DELIMITER ;

CALL ListEmployeesByDepartment(2); -- Replace 2 with the department_id you want to query


-- QUESTION 4...................................................

DELIMITER //

CREATE PROCEDURE GetProjectBudget(IN proj_id INT)
BEGIN
    SELECT budget FROM projects
    WHERE project_id = proj_id;
END //

DELIMITER ;

CALL GetProjectBudget(101); -- Replace 101 with the project_id you want to query

-- QUESTION 5........................................................

DELIMITER //

CREATE PROCEDURE GetHighestPaidEmployee(IN dept_id INT)
BEGIN
    SELECT emp_id, first_name, last_name, salary
    FROM employees
    WHERE department_id = dept_id
    ORDER BY salary DESC
    LIMIT 1;
END //

DELIMITER ;

CALL GetHighestPaidEmployee(1); -- Replace 1 with the department_id you want to query

-- QUESTION 6........................................................

DELIMITER //

CREATE PROCEDURE ListProjectsEndingSoon(IN days_until_end INT)
BEGIN
    SELECT * FROM projects
    WHERE DATEDIFF(end_date, CURDATE()) <= days_until_end;
END //

DELIMITER ;

CALL ListProjectsEndingSoon(30); -- This will list all projects ending in the next 30 days

-- QUESTION 7........................................................

DELIMITER //

CREATE PROCEDURE CalculateTotalSalaryExpenditure(IN dept_id INT)
BEGIN
    SELECT SUM(salary) AS total_expenditure
    FROM employees
    WHERE department_id = dept_id;
END //

DELIMITER ;


CALL CalculateTotalSalaryExpenditure(2); -- Replace 2 with the department_id you want to query

-- QUESTION 8	........................................................

DELIMITER //

CREATE PROCEDURE EmployeeDepartmentSalaryReport()
BEGIN
    SELECT e.emp_id, e.first_name, e.last_name, e.salary, d.department_name
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id;
END //

DELIMITER ;

CALL EmployeeDepartmentSalaryReport();

-- QUESTION 9	........................................................

DELIMITER //

CREATE PROCEDURE FindHighestBudgetProject()
BEGIN
    SELECT * FROM projects
    ORDER BY budget DESC
    LIMIT 1;
END //

DELIMITER ;

CALL FindHighestBudgetProject();


-- QUESTION 10	........................................................

DELIMITER //

CREATE PROCEDURE CalculateAverageSalaryAcrossDepartments()
BEGIN
    SELECT AVG(salary) AS average_salary
    FROM employees;
END //

DELIMITER ;

CALL CalculateAverageSalaryAcrossDepartments();

-- QUESTION 11	........................................................

DELIMITER //

CREATE PROCEDURE AssignNewManager(IN dept_id INT, IN new_manager_id INT)
BEGIN
    UPDATE departments
    SET manager_id = new_manager_id
    WHERE department_id = dept_id;
END //

DELIMITER ;

CALL AssignNewManager(2, 6); -- This will assign the employee with emp_id 6 as the new manager of department_id 2

-- QUESTION 12	........................................................

DELIMITER //

CREATE PROCEDURE CalculateRemainingBudget(IN proj_id INT, IN spent_amount DECIMAL(10,2))
BEGIN
    DECLARE project_budget DECIMAL(10,2);

    -- Get the total budget for the project
    SELECT budget INTO project_budget FROM projects WHERE project_id = proj_id;

    -- Calculate and return the remaining budget
    SELECT project_budget - spent_amount AS remaining_budget;
END //

DELIMITER ;


CALL CalculateRemainingBudget(101, 50000); -- This will calculate the remaining budget for project_id 101 with 50000 spent

-- QUESTION 13........................................................

DELIMITER //

CREATE PROCEDURE ReportEmployeesByJoinYear(IN year_joined INT)
BEGIN
    SELECT emp_id, first_name, last_name, join_date
    FROM employees
    WHERE YEAR(join_date) = year_joined;
END //

DELIMITER ;

CALL ReportEmployeesByJoinYear(2023); -- Replace 2023 with the year you want to query

-- QUESTION 14........................................................

DELIMITER //

CREATE PROCEDURE UpdateProjectEndDate(IN proj_id INT, IN duration_days INT)
BEGIN
    UPDATE projects
    SET end_date = DATE_ADD(start_date, INTERVAL duration_days DAY)
    WHERE project_id = proj_id;
END //

DELIMITER ;

CALL UpdateProjectEndDate(101, 180); -- This will set the end date of project_id 101 to 180 days after the start date

-- QUESTION 15........................................................

DELIMITER //

CREATE PROCEDURE CalculateTotalEmployeesPerDepartment()
BEGIN
    SELECT department_id, COUNT(emp_id) AS total_employees
    FROM employees
    GROUP BY department_id;
END //

DELIMITER ;

CALL CalculateTotalEmployeesPerDepartment();















