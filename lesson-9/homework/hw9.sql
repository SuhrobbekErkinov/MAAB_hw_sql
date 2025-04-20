create database hw9;
go
use hw9;

CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

-- task 1
select * from Employees;
;with cte as (
    select *, 0 as Depth 
    from Employees 
    where ManagerID is null
    union all
    select e.*, Depth + 1
    from cte 
    join Employees e 
    on cte.EmployeeID=e.ManagerID
)
select * from cte;

-- task 2
;with cte as (
    select 1 as Num, 1 as Factorial
    union all 
    select Num + 1, Factorial*(Num+1)
    from cte
    where Num<10
)
select *
from cte;

-- task 3
;with cte as (
    select 1 as n, 0 as prev,1 as Fibonacci_Number
    union all 
    select n+1, Fibonacci_Number, Fibonacci_Number+prev
    from cte
    where n<10
)
select n, Fibonacci_Number
from cte;