DROP DATABASE IF EXISTS mydatabase;
CREATE DATABASE mydatabase;

USE mydatabase;

CREATE TABLE mytable (
    column1 INT UNIQUE PRIMARY KEY,
    sname VARCHAR(20),
    department VARCHAR(10)
);

INSERT INTO mytable (column1, sname, department) VALUES
(1, 'Rahul', 'IT'),
(2, 'Priya', 'HR'),
(3, 'Amit', 'Finance'),
(4, 'Sneha', 'Marketing');


select * from mytable;