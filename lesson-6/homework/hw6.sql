create database hw6;
go
use hw6;

-- Drop tables if they already exist (for clean reruns)
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary INT
);

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID)
);

-- Insert values into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert values into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Insert values into Projects
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

-- task 1
select Employees.Name as Name,
    Departments.DepartmentName as Department
from Employees 
inner join Departments
    on Employees.DepartmentID = Departments.DepartmentID;

-- task 2
select Employees.Name as Name,
    Departments.DepartmentName as Department
from Employees
left join Departments
    on Employees.DepartmentID = Departments.DepartmentID; 

-- task 3
select Departments.DepartmentName as Department,
    Employees.Name as Name
from Employees
right join Departments
    on Employees.DepartmentID = Departments.DepartmentID;

-- task 4
select [Departments].DepartmentName as Department,
    Employees.Name as Name
from Employees
full outer join Departments
    on Employees.DepartmentID = Departments.DepartmentID;

-- task 5
select distinct Departments.DepartmentName as Department,
    sum(Salary) over(partition by departments.DepartmentName) as TotalSalary
from Employees
right join Departments
    on Departments.DepartmentID = Employees.DepartmentID;

-- task 6
select DepartmentName, 
    ProjectName
from Departments 
cross join projects;

select * 
from Departments
cross join Projects;

-- task 7
SELECT Employees.Name as Name,
    Projects.ProjectName as Project,
    Departments.DepartmentName as Department
from Employees
left join Projects
    on Employees.EmployeeID = Projects.EmployeeID
left join Departments
    on Employees.DepartmentID = Departments.DepartmentID;
