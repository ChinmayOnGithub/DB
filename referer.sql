-- Create a new database
CREATE DATABASE TestDB;

-- Use the database
USE TestDB;

-- ===============================================
-- Basic Table Creation with Constraints
-- ===============================================
-- Create students table with various constraints
CREATE TABLE
    students (
        id INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key, auto-incremented
        name VARCHAR(255) NOT NULL, -- Name should not be NULL
        age INT NOT NULL CHECK (age >= 18), -- Age must be 18 or greater
        department VARCHAR(255)
    );

-- Create another table for courses
CREATE TABLE
    courses (
        course_id INT AUTO_INCREMENT PRIMARY KEY,
        course_name VARCHAR(255) NOT NULL
    );

-- ===============================================
-- Insert Data into Tables
-- ===============================================
-- Insert sample data into students table
INSERT INTO
    students (name, age, department)
VALUES
    ('John', 20, 'CS'),
    ('Alice', 22, 'IT'),
    ('Bob', 23, 'ECE'),
    ('Eve', 21, 'EE');

-- Insert data into courses table
INSERT INTO
    courses (course_name)
VALUES
    ('Database Systems'),
    ('Operating Systems'),
    ('Computer Networks');

-- ===============================================
-- Select Data (Basic Queries)
-- ===============================================
-- Select all data from students
SELECT
    *
FROM
    students;

-- Select specific columns
SELECT
    name,
    age
FROM
    students;

-- Use WHERE clause for filtering
SELECT
    *
FROM
    students
WHERE
    department = 'CS';

-- ===============================================
-- Joins
-- ===============================================
-- Create a table for student courses (many-to-many relationship)
CREATE TABLE
    student_courses (
        student_id INT,
        course_id INT,
        PRIMARY KEY (student_id, course_id),
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
    );

-- Insert sample data into student_courses table
INSERT INTO
    student_courses (student_id, course_id)
VALUES
    (1, 1), -- John enrolled in Database Systems
    (2, 2), -- Alice enrolled in Operating Systems
    (3, 3), -- Bob enrolled in Computer Networks
    (1, 3);

-- John also enrolled in Computer Networks
-- Inner Join to get students and their courses
SELECT
    students.name,
    courses.course_name
FROM
    students
    JOIN student_courses ON students.id = student_courses.student_id
    JOIN courses ON student_courses.course_id = courses.course_id;

-- Left Join (include students with no courses)
SELECT
    students.name,
    courses.course_name
FROM
    students
    LEFT JOIN student_courses ON students.id = student_courses.student_id
    LEFT JOIN courses ON student_courses.course_id = courses.course_id;

-- ===============================================
-- Update Data
-- ===============================================
-- Update a student's department
UPDATE students
SET
    department = 'Software Engineering'
WHERE
    name = 'Alice';

-- ===============================================
-- Delete Data
-- ===============================================
-- Delete a student record
DELETE FROM students
WHERE
    name = 'Bob';

-- ===============================================
-- Trigger: Automatically update department
-- ===============================================
-- Create a trigger that updates the department of a student after an update
DELIMITER / / CREATE TRIGGER update_department AFTER
UPDATE ON students FOR EACH ROW BEGIN IF OLD.department != NEW.department THEN
INSERT INTO
    audit_log (operation, details)
VALUES
    (
        'Department Change',
        CONCAT (
            'ID: ',
            OLD.id,
            ', Old: ',
            OLD.department,
            ', New: ',
            NEW.department
        )
    );

END IF;

END / / DELIMITER;

-- Create an audit_log table to store changes
CREATE TABLE
    audit_log (
        id INT AUTO_INCREMENT PRIMARY KEY,
        operation VARCHAR(255),
        details TEXT,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Insert data into students to activate the trigger
UPDATE students
SET
    department = 'Data Science'
WHERE
    name = 'Eve';

-- View the audit log
SELECT
    *
FROM
    audit_log;

-- ===============================================
-- Stored Procedure
-- ===============================================
-- Create a stored procedure to get all students by department
DELIMITER / / CREATE PROCEDURE GetStudentsByDepartment (IN dept_name VARCHAR(255)) BEGIN
SELECT
    *
FROM
    students
WHERE
    department = dept_name;

END / / DELIMITER;

-- Call the stored procedure to get all students in 'IT' department
CALL GetStudentsByDepartment ('IT');

-- ===============================================
-- View (for recurring complex queries)
-- ===============================================
-- Create a view to get student-course information
CREATE VIEW
    student_course_view AS
SELECT
    students.name,
    courses.course_name
FROM
    students
    JOIN student_courses ON students.id = student_courses.student_id
    JOIN courses ON student_courses.course_id = courses.course_id;

-- Select from the view (it behaves like a table)
SELECT
    *
FROM
    student_course_view;

-- ===============================================
-- Index (Improve query performance)
-- ===============================================
-- Create an index on the department column to speed up searches
CREATE INDEX idx_department ON students (department);

-- ===============================================
-- Group By and Aggregation
-- ===============================================
-- Count the number of students in each department
SELECT
    department,
    COUNT(*) AS num_students
FROM
    students
GROUP BY
    department;

-- ===============================================
-- Subqueries
-- ===============================================
-- Subquery to get students who are enrolled in 'Database Systems' course
SELECT
    *
FROM
    students
WHERE
    id IN (
        SELECT
            student_id
        FROM
            student_courses
        WHERE
            course_id = (
                SELECT
                    course_id
                FROM
                    courses
                WHERE
                    course_name = 'Database Systems'
            )
    );

-- ===============================================
-- Transaction (for multiple operations)
-- ===============================================
-- Start a transaction to transfer data between students (for example, a department change)
START TRANSACTION;

-- Update a student’s department (simulate a department transfer)
UPDATE students
SET
    department = 'Mechanical Engineering'
WHERE
    name = 'John';

-- If all operations are correct, commit the transaction
COMMIT;

-- If there’s an error, roll back to the previous state
-- ROLLBACK;
-- ===============================================
-- Drop Tables, Procedures, and Views
-- ===============================================
-- Drop the view
DROP VIEW IF EXISTS student_course_view;

-- Drop the trigger
DROP TRIGGER IF EXISTS update_department;

-- Drop the procedure
DROP PROCEDURE IF EXISTS GetStudentsByDepartment;

-- Drop the tables
DROP TABLE IF EXISTS student_courses,
audit_log,
students,
courses;