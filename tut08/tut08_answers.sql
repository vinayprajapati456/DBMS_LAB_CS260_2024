-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

CREATE DATABASE Assignment8;
USE Assignment8;

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
    end_date DATE,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);


INSERT INTO projects 
(project_id, project_name, budget, start_date, end_date, manager_id) 
VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30', 1), 
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15', 2), 
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30', 3); 

-- QUESTION 1.

DELIMITER $$

CREATE TRIGGER increase_salary_before_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.10;
    END IF;
END$$

DELIMITER ;

--QUESTION 2..

DELIMITER $$

CREATE TRIGGER prevent_department_deletion
BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE employee_count INT;

    SELECT COUNT(*) INTO employee_count
    FROM employees
    WHERE department_id = OLD.department_id;

    IF employee_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete department with assigned employees.';
    END IF;
END$$

DELIMITER ;

-- QUESTION 3..

CREATE TABLE salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    employee_name VARCHAR(255),
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    update_date TIMESTAMP
);


DELIMITER $$

CREATE TRIGGER log_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit (emp_id, employee_name, old_salary, new_salary, update_date)
        VALUES (NEW.emp_id, CONCAT(NEW.first_name, ' ', NEW.last_name), OLD.salary, NEW.salary, NOW());
    END IF;
END$$

DELIMITER ;

-- QUESTION 4.

DELIMITER $$

CREATE TRIGGER assign_department_based_on_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3;
    
    END IF;
END$$

DELIMITER ;

-- QUESTION 5.
DELIMITER $$

CREATE TRIGGER update_manager_salary_on_new_hire
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    -- Temporary variables to hold data
    DECLARE highest_salary DECIMAL(10, 2);
    DECLARE manager_id INT;

    -- Find the highest salary and the manager's employee ID in the new employee's department
    SELECT emp_id, MAX(salary) INTO manager_id, highest_salary
    FROM employees
    WHERE department_id = NEW.department_id
    GROUP BY department_id;

    -- Update the manager's salary by a certain percentage, e.g., 10%
    UPDATE employees
    SET salary = salary * 1.10
    WHERE emp_id = manager_id AND salary = highest_salary;
END$$

DELIMITER ;

-- QUESTION 6..

DELIMITER $$

CREATE TRIGGER prevent_department_update_if_projects_exist
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE project_count INT;

    -- Check if the employee has worked on any projects
    SELECT COUNT(*) INTO project_count
    FROM projects
    WHERE manager_id = OLD.emp_id;

    -- If the employee has worked on projects, prevent the update
    IF project_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update department_id for employees who have worked on projects.';
    END IF;
END$$

DELIMITER ;

-- QUESTION 7.


CREATE TABLE department_averages (
    department_id INT PRIMARY KEY,
    average_salary DECIMAL(10, 2)
);

DELIMITER $$

CREATE TRIGGER update_average_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        
        DECLARE new_average DECIMAL(10, 2);

       
        SELECT AVG(salary) INTO new_average
        FROM employees
        WHERE department_id = NEW.department_id;

       
        UPDATE department_averages
        SET average_salary = new_average
        WHERE department_id = NEW.department_id;
    END IF;
END$$

DELIMITER ;

-- QUESTION 8.
DELIMITER $$

CREATE TRIGGER delete_works_on_records
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    
    DELETE FROM works_on
    WHERE emp_id = OLD.emp_id;
END$$

DELIMITER ;

-- QUESTION 9..

DELIMITER $$

CREATE TRIGGER check_min_salary_before_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10, 2);

    
    SELECT min_salary INTO min_salary
    FROM department_min_salaries
    WHERE department_id = NEW.department_id;

   
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The salary for the new employee is below the minimum salary for this department.';
    END IF;
END$$

DELIMITER ;

-- QUESTION 10

DELIMITER $$

CREATE TRIGGER update_department_budget
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Declare the variable at the beginning of the BEGIN ... END block
    DECLARE new_total_salary_budget DECIMAL(10, 2);

    IF OLD.salary <> NEW.salary THEN
        -- Calculate the new total salary budget for the department
        SELECT SUM(salary) INTO new_total_salary_budget
        FROM employees
        WHERE department_id = NEW.department_id;

        -- Update the department_budgets table with the new total salary budget
        UPDATE department_budgets
        SET total_salary_budget = new_total_salary_budget
        WHERE department_id = NEW.department_id;
    END IF;
END$$

DELIMITER ;

-- QUESTION 11

DELIMITER $$

CREATE TRIGGER notify_hr_after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
   
    CALL send_email(
        'hr@example.com', -- Recipient's email address
        'New Employee Hired', -- Email subject
        CONCAT('A new employee, ', NEW.first_name, ' ', NEW.last_name, ' has been hired with a salary of ', NEW.salary) -- Email body
    );
END$$

DELIMITER ;

-- QUESTION 12.

DELIMITER $$

CREATE TRIGGER check_department_location_before_insert
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL OR NEW.location = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert new department without specifying a location.';
    END IF;
END$$

DELIMITER ;

-- QUESTION 13.
DELIMITER $$

CREATE TRIGGER update_employee_department_name
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    IF OLD.department_name <> NEW.department_name THEN
        UPDATE employees
        SET department_name = NEW.department_name
        WHERE department_id = OLD.department_id;
    END IF;
END$$

DELIMITER ;

-- QUESTION 14.

DELIMITER $$

CREATE TRIGGER log_delete_on_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (operation_type, emp_id, first_name, last_name, salary, department_id)
    VALUES ('DELETE', OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, OLD.department_id);
END$$

DELIMITER ;

-- QUESTION 15..

DELIMITER $$

CREATE TRIGGER generate_emp_id
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    -- Check if the emp_id is not set
    IF NEW.emp_id IS NULL THEN
        -- Get the next AUTO_INCREMENT value for the employees table
        SET @next_id := (SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES
                         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'employees');
        -- Set the emp_id with a prefix and the next auto increment value, formatted to 3 digits
        SET NEW.emp_id = CONCAT('EMP', LPAD(@next_id, 3, '0'));
    END IF;
END$$

DELIMITER ;


















