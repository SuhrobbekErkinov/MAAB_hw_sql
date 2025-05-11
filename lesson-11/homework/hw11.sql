create database hw11;
go
use hw11;

-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);

CREATE TABLE #EmployeeTransfers (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);
UPDATE Employees
SET Department = (
    case 
        when Department = 'HR' then 'IT'
        when Department = 'IT' then 'Sales'
        when Department = 'Sales' then 'HR'
    end
);
INSERT into #EmployeeTransfers
select * from Employees;

SELECT * from #EmployeeTransfers;



-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);

declare @MissingOrders table (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);
insert into @MissingOrders
select *
from (
    select 
        db1.OrderID, db1.CustomerName, db1.Product, db1.Quantity
    from Orders_DB1 db1
    left join Orders_DB2 db2
        on db1.OrderID = db2.OrderID
        where db2.OrderID is null
) tb1;
SELECT * from @MissingOrders;

-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

-- create view vw_MonthlyWorkSummary as
CREATE VIEW vw_MonthlyWorkSummary AS
WITH thw AS (
    SELECT 
        EmployeeID,
        EmployeeName, 
        Department, 
        SUM(HoursWorked) AS TotalHoursWorked
    FROM WorkLog
    GROUP BY EmployeeID, EmployeeName, Department
),
thd AS (
    SELECT 
        Department,
        SUM(HoursWorked) AS TotalHoursDepartment,
        AVG(HoursWorked) AS AvgHoursDepartment
    FROM WorkLog
    GROUP BY Department
)
SELECT 
    tb1.EmployeeID,
    tb1.EmployeeName,
    tb1.Department,
    tb1.TotalHoursWorked,
    tb2.TotalHoursDepartment,
    tb2.AvgHoursDepartment
FROM thw tb1 
JOIN thd tb2 ON tb1.Department = tb2.Department;



select * from vw_MonthlyWorkSummary;

