-- 1. Database Creation and Use

-- Create a new database
CREATE DATABASE UniversityDB;

-- Switch to the newly created database
USE UniversityDB;


-- 2. Table Creation with Constraints

-- a. Students Table with Constraints
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Primary Key, auto-incremented
    name VARCHAR(255) NOT NULL,                 -- Name should not be NULL
    age INT NOT NULL CHECK (age >= 18),         -- Age must be 18 or greater
    department VARCHAR(255) NOT NULL,           -- Department cannot be NULL
    UNIQUE (name)                              -- Ensure that names are unique
);

-- b. Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary Key
    course_name VARCHAR(255) NOT NULL          -- Course name should not be NULL
);

-- c. Student-Courses Relationship Table (Many-to-Many)
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),      -- Composite Primary Key
    FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,  -- Foreign Key referencing students table
    FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE  -- Foreign Key referencing courses table
);

-- 3. Inserting Data into Tables

-- a. Inserting Data into Students Table
INSERT INTO students (name, age, department)
VALUES
    ('Arjun Kumar', 20, 'Computer Science'),
    ('Priya Sharma', 22, 'Information Technology'),
    ('Vikram Singh', 23, 'Electronics'),
    ('Sanya Patel', 21, 'Electrical Engineering');

-- b. Inserting Data into Courses Table
INSERT INTO courses (course_name)
VALUES
    ('Database Systems'),
    ('Operating Systems'),
    ('Computer Networks'),
    ('Machine Learning');

-- c. Inserting Data into Student-Courses Table
INSERT INTO student_courses (student_id, course_id)
VALUES
    (1, 1), -- Arjun Kumar enrolled in Database Systems
    (2, 2), -- Priya Sharma enrolled in Operating Systems
    (3, 3), -- Vikram Singh enrolled in Computer Networks
    (4, 1), -- Sanya Patel enrolled in Database Systems
    (1, 2); -- Arjun Kumar enrolled in Operating Systems


-- 4. Selecting Data (Basic Queries)

-- a. Select All Data from Students
SELECT * FROM students;

-- b. Select Specific Columns (name, age)
SELECT name, age FROM students;

-- c. Using WHERE Clause for Filtering
SELECT * FROM students
WHERE department = 'Computer Science';

-- d. Using HAVING Clause with GROUP BY
SELECT department, COUNT(*) AS num_students
FROM students
GROUP BY department
HAVING num_students > 1;


-- 5. Joins (Including All Types of Joins)

-- a. Inner Join
SELECT students.name, courses.course_name
FROM students
JOIN student_courses ON students.id = student_courses.student_id
JOIN courses ON student_courses.course_id = courses.course_id;

-- b. Left Join
SELECT students.name, courses.course_name
FROM students
LEFT JOIN student_courses ON students.id = student_courses.student_id
LEFT JOIN courses ON student_courses.course_id = courses.course_id;

-- c. Right Join
SELECT students.name, courses.course_name
FROM students
RIGHT JOIN student_courses ON students.id = student_courses.student_id
RIGHT JOIN courses ON student_courses.course_id = courses.course_id;

-- d. Full Outer Join
SELECT students.name, courses.course_name
FROM students
FULL OUTER JOIN student_courses ON students.id = student_courses.student_id
FULL OUTER JOIN courses ON student_courses.course_id = courses.course_id;


-- 6. Update Data

-- Update a student's department
UPDATE students
SET department = 'Data Science'
WHERE name = 'Arjun Kumar';


-- 7. Delete Data

-- Delete a student record
DELETE FROM students
WHERE name = 'Vikram Singh';


-- 8. Triggers

-- a. Create Trigger for Logging Department Changes
DELIMITER $$

CREATE TRIGGER update_department
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    IF OLD.department != NEW.department THEN
        INSERT INTO audit_log (operation, details)
        VALUES ('Department Change', CONCAT('ID: ', OLD.id, ', Old: ', OLD.department, ', New: ', NEW.department));
    END IF;
END$$

DELIMITER ;

-- b. Create Audit Log Table
CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operation VARCHAR(255),
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 9. Stored Procedures

-- a. Create a Stored Procedure to Get Students by Department
DELIMITER $$

CREATE PROCEDURE GetStudentsByDepartment (IN dept_name VARCHAR(255))
BEGIN
    SELECT * FROM students
    WHERE department = dept_name;
END$$

DELIMITER ;

-- b. Call the Stored Procedure to Get Students in 'Computer Science'
CALL GetStudentsByDepartment ('Computer Science');


-- 10. Views

-- a. Create a View for Student-Course Information
CREATE VIEW student_course_view AS
SELECT students.name, courses.course_name
FROM students
JOIN student_courses ON students.id = student_courses.student_id
JOIN courses ON student_courses.course_id = courses.course_id;

-- b. Select Data from the View
SELECT * FROM student_course_view;


-- 11. Indexing (Improving Query Performance)

-- a. Create Index on the Department Column
CREATE INDEX idx_department ON students (department);


-- 12. Hashing

-- a. Create a Hash Index (For Memory Tables)
CREATE TABLE students_hash (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    department VARCHAR(255)
) ENGINE = MEMORY;

-- Create a hash index on the department column
CREATE INDEX idx_department_hash ON students_hash(department);


-- 13. Subqueries

-- a. Subquery in WHERE Clause
SELECT * FROM students
WHERE id IN (
    SELECT student_id
    FROM student_courses
    WHERE course_id = (SELECT course_id FROM courses WHERE course_name = 'Database Systems')
);


-- 14. Transactions

-- a. Start a Transaction
START TRANSACTION;

-- Update a student's department
UPDATE students
SET department = 'Mechanical Engineering'
WHERE name = 'Arjun Kumar';

-- Commit the transaction
COMMIT;

-- If there's an error, roll back the transaction
-- ROLLBACK;
