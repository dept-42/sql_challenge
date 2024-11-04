-- SQL Challenge
-- Wayne Mitchell
-- 11.4.2024

-- clean out prexisting tables
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Titles;
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Dept_manager;
DROP TABLE IF EXISTS Dept_emp;
DROP TABLE IF EXISTS Departments;

-- CREATE TABLES

-- NOTE: I judged all of the fields to be critical to the use case for
-- an 'Employee' database. So, I  flagged them all as NOT NULL to enforce
-- an entry for each field when new entries are made to the DB. 

CREATE TABLE Employees (
    emp_no int   NOT NULL,
    emp_title_id varchar(5)   NOT NULL,
    birth_date date   NOT NULL,
    first_name varchar(30)   NOT NULL,
    last_name varchar(30)   NOT NULL,
    sex char(1)   NOT NULL,
    hire_date date   NOT NULL,
    CONSTRAINT pk_Employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Titles (
    title_id varchar(5)   NOT NULL,
    title varchar(30)   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

CREATE TABLE Salaries (
    emp_no int   NOT NULL,
    salary int   NOT NULL,
    CONSTRAINT pk_Salaries PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Departments (
    dept_no varchar(4)   NOT NULL,
    dept_name varchar(30)   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE Dept_manager (
    dept_no varchar(4)   NOT NULL,
	emp_no int   NOT NULL
);

CREATE TABLE Dept_emp (
    emp_no int   NOT NULL,
    dept_no varchar(4)   NOT NULL
);

-- populate tables with csv data using 'import' wizzard
-- (not shown)
-- check tables
SELECT *
FROM Employees

SELECT *
FROM Titles

SELECT *
FROM Salaries

SELECT *
FROM Dept_emp

SELECT *
FROM Dept_manager

SELECT *
FROM Departments

-- constrain tables
ALTER TABLE Dept_manager ADD COLUMN id SERIAL

ALTER TABLE Dept_emp ADD COLUMN id SERIAL

ALTER TABLE Dept_manager  ADD CONSTRAINT pk_Dept_manager PRIMARY KEY (id)

ALTER TABLE Dept_emp ADD CONSTRAINT pk_Dept_emp PRIMARY KEY (id)
	 
ALTER TABLE Employees ADD CONSTRAINT fk_Employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

ALTER TABLE Salaries ADD CONSTRAINT fk_Salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Dept_manager ADD CONSTRAINT fk_Dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Dept_manager ADD CONSTRAINT fk_Dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Dept_emp ADD CONSTRAINT fk_Dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Dept_emp ADD CONSTRAINT fk_Dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

-- check tables
SELECT *
FROM Employees

SELECT *
FROM Titles

SELECT *
FROM Salaries

SELECT *
FROM Dept_emp

SELECT *
FROM Dept_manager

SELECT *
FROM Departments

-->> (Table Check all OK) <<--

-- List the employee number, last name, first name, sex, and salary of each employee 
SELECT Employees.emp_no, last_name, first_name, sex, salary
FROM Employees
INNER JOIN Salaries ON Employees.emp_no = Salaries.emp_no;
-->> (returns expected columns: OK ) <<--

-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM Employees
WHERE (EXTRACT ('Year' FROM hire_date)) = 1986;
-->> (returns expected columns: OK ) <<--

-- List the manager of each department along with their department number, 
-- department name, employee number, last name, and first name 
SELECT dept_name, last_name, first_name, sex, salary
FROM Employees
INNER JOIN Salaries ON Employees.emp_no = Salaries.emp_no;

-- List the department number for each employee along with that employee’s 
-- employee number, last name, first name, and department name 
SELECT Departments.dept_name, Dept_manager.dept_no, Dept_manager.emp_no, last_name, first_name
FROM Departments, Dept_manager, Employees
WHERE Dept_manager.emp_no = Employees.emp_no
AND Dept_manager.dept_no = Departments.dept_no;
-->> (returns expected columns: OK ) <<--

-- List first name, last name, and sex of each employee whose 
-- first name is Hercules and whose last name begins with the letter B 
SELECT first_name, last_name
FROM Employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%'
-->> (returns expected columns: OK ) <<--

-- List each employee in the Sales department, including their 
-- employee number, last name, and first name 
SELECT Dept_emp.emp_no, last_name, first_name
FROM Departments, Dept_emp, Employees
WHERE dept_name = 'Sales'
AND Departments.dept_no = Dept_emp.dept_no
AND Dept_emp.emp_no = Employees.emp_no;
-->> (returns expected columns: OK ) <<--

-- List each employee in the Sales and Development departments, including 
-- their employee number, last name, first name, and department name 
SELECT Dept_emp.emp_no, last_name, first_name, dept_name
FROM Dept_emp, Employees, Departments
WHERE (dept_name = 'Sales' OR dept_name = 'Development')
AND Departments.dept_no = Dept_emp.dept_no
AND Dept_emp.emp_no = Employees.emp_no;
-->> (returns expected columns: OK ) <<--

-- List the frequency counts, in descending order, of all the employee 
-- last names (that is, how many employees share each last name)
SELECT last_name, COUNT (*) AS last_name_count
FROM Employees
GROUP BY last_name
ORDER BY last_name_count DESC, last_name;
-->> (returns expected columns: OK ) <<--