CREATE DATABASE EmployeeDB;

DROP TABLE departments

CREATE TABLE departments (
    depart_id SERIAL PRIMARY KEY,
    depart_name VARCHAR(100) NOT NULL,
    depart_city VARCHAR(100) NOT NULL
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role VARCHAR(100) NOT NULL
);

CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    salary_pa NUMERIC(10,2) NOT NULL
);

CREATE TABLE overtime_hours (
    overtime_id SERIAL PRIMARY KEY,
    overtime_hours INTEGER NOT NULL
);

DROP TABLE employees CASCADE

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    address TEXT,
    email VARCHAR(150),

    depart_id INTEGER,
    role_id INTEGER,
    salary_id INTEGER,
    overtime_id INTEGER,

    CONSTRAINT fk_department
        FOREIGN KEY (depart_id)
        REFERENCES departments(depart_id),

    CONSTRAINT fk_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id),

    CONSTRAINT fk_salary
        FOREIGN KEY (salary_id)
        REFERENCES salaries(salary_id),

    CONSTRAINT fk_overtime
        FOREIGN KEY (overtime_id)
        REFERENCES overtime_hours(overtime_id)
);

INSERT INTO departments (depart_name, depart_city)
VALUES
('IT', 'Johannesburg'),
('HR', 'Cape Town'),
('Finance', 'Durban');

INSERT INTO roles (role)
VALUES
('Software Developer'),
('HR Manager'),
('Accountant');

INSERT INTO salaries (salary_pa)
VALUES
(600000),
(500000),
(550000);

INSERT INTO overtime_hours (overtime_hours)
VALUES
(10),
(5),
(20);

INSERT INTO employees (
    first_name, surname, gender, address, email,
    depart_id, role_id, salary_id, overtime_id
)
VALUES
('James', 'Smith', 'Male', '123 Main Rd', 'james@example.com', 1, 1, 1, 1),
('Sarah', 'Jones', 'Female', '45 Long St', 'sarah@example.com', 2, 2, 2, 2),
('Michael', 'Brown', 'Male', '78 Beach Ave', 'michael@example.com', 3, 3, 3, 3);

INSERT INTO employees (
    first_name, surname, depart_id
)
VALUES
('Invalid', 'Employee', 99);

SELECT
    d.depart_name,
    r.role AS job_title,
    s.salary_pa,
    o.overtime_hours
FROM employees e
LEFT JOIN departments d ON e.depart_id = d.depart_id
LEFT JOIN roles r ON e.role_id = r.role_id
LEFT JOIN salaries s ON e.salary_id = s.salary_id
LEFT JOIN overtime_hours o ON e.overtime_id = o.overtime_id;
