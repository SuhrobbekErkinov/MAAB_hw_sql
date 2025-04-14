create database hw5;
go 
use hw5;

drop table if exists Employees;
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29'),
    ('suhrob', 'HR', 52000, '2021-03-29');

-- task 1
select *, 
    ROW_NUMBER() OVER(order by Salary desc) as rank
from Employees
order by EmployeeID;

-- task 2
select *,
    dense_rank() over(order by Salary desc) as d_rank 
from Employees
order by EmployeeID;

-- task 3
select * from (
    select *,
        DENSE_RANK() over(partition by Department order by Salary desc) as s_rank
    from Employees
) s_rank
where s_rank=1 or s_rank=2;

--can have duplicate values if same salary is given to different employees

-- task 4
select * from (
    select *,
        DENSE_RANK() over(partition by Department order by Salary) as s_rank
    from Employees
) s_tb 
where s_rank=1;

-- task 5
select *,
    sum(Salary) over(partition by Department order by EmployeeID) as sumS
from Employees;

-- task 6
select distinct department,
    sum(Salary) over(partition by Department) as TotalSalary
from Employees;

-- task 7
select distinct Department,
    cast(avg(Salary) over(partition by department) as dec(10, 2)) as AverageSalary
from Employees;

-- task 8
select *, 
    abs(cast(Salary - avg(Salary) over(partition by department) as dec(10, 2))) as Difference
from Employees;

-- task 9
select *,
    cast(avg(salary) over(order by salary rows between 1 preceding and 1 following) as dec(10, 2)) as MovingAvgSalary
from Employees;

-- task 10
--- 1st method
select 
sum(salary) from (
    select *
    from Employees
    order by HireDate desc
    offset 0 row fetch next 3 rows only
) s_tb;

--- 2nd method 
select
    sum(salary) over(order by HireDate desc rows between 1 preceding and 1 following) as last3
from Employees
order by HireDate desc
offset 1 row fetch next 1 row only;

-- task 11
select *,
    cast(avg(Salary) over(order by EmployeeID rows between unbounded preceding and current row) as dec(10, 2)) as RunAvgSalary
from Employees;

-- task 12
select *,
    max(Salary) over(order by EmployeeID rows between 1 preceding and 1 following) as MaxSalary
from Employees;

-- task 13
select *,
    cast(100 * Salary / sum(salary) over(partition by department) as dec(10, 2)) as PerCon
from Employees;