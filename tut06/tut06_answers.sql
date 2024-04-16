-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

CREATE DATABASE IF NOT EXISTS university;
USE university;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_id, first_name, last_name, age, city) VALUES
(1, 'Rahul', 'Kumar', 20, 'Delhi'),
(2, 'Neha', 'Sharma', 22, 'Mumbai'),
(3, 'Krishna', 'Singh', 21, 'Bangalore'),
(4, 'Pooja', 'Verma', 23, 'Kolkata'),
(5, 'Rohan', 'Gupta', 22, 'Hyderabad');

INSERT INTO courses (course_id, course_name, instructor_id) VALUES
(101, 'Mathematics', 1),
(102, 'Physics', 2),
(103, 'History', 3),
(104, 'Chemistry', 1),
(105, 'Computer Science', 2);

INSERT INTO instructors (instructor_id, first_name, last_name) VALUES
(1, 'Dr. Akhil', 'Singh'),
(2, 'Dr. Neha', 'Agarwal'),
(3, 'Dr. Nitin', 'Warrier');

INSERT INTO enrollments (enrollment_id, student_id, course_id, grade) VALUES
(1, 1, 101, 'A'),
(2, 2, 102, 'B+'),
(3, 3, 104, 'A-'),
(4, 4, 103, 'B'),
(5, 5, 105, 'A');


---Question 1
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

---Question 2
SELECT c.course_name, e.grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id;

---Question 3
SELECT s.first_name, s.last_name, c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;

---Question 4
SELECT s.first_name, s.last_name, s.age, s.city
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

----Question 5
SELECT c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;


----Question 6
SELECT s.first_name, s.last_name, e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;

---Question 7
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 1;


---Question 8
SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

----Question 9
SELECT s.first_name, s.last_name, s.age
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


----Question 10
SELECT c.course_name, AVG(
    CASE
        WHEN e.grade = 'A' THEN 4.0
        WHEN e.grade = 'A-' THEN 3.7
        WHEN e.grade = 'B+' THEN 3.3
        WHEN e.grade = 'B' THEN 3.0
        -- add more cases for other grades if needed
        ELSE 0.0
    END
) AS average_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;


----Question 11
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade > 'B';


----QUestion 12
SELECT c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.last_name LIKE 'S%';


-----Question 13
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Dr. Akhil';


----Question 14
SELECT c.course_name, MAX(e.grade) AS max_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

---Question 15
SELECT s.first_name, s.last_name, s.age, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY c.course_name ASC;

