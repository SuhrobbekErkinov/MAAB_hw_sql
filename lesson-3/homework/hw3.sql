CREATE DATABASE hw3;
GO
USE hw3;

-- task 1
drop table if EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES 
    (1, 'Alice', 'Johnson', 'HR', 60000, '2019-03-15'),
    (2, 'Bob', 'Smith', 'IT', 85000, '2018-07-20'),
    (3, 'Charlie', 'Brown', 'Finance', 95000, '2017-01-10'),
    (4, 'David', 'Williams', 'HR', 50000, '2021-05-22'),
    (5, 'Emma', 'Jones', 'IT', 110000, '2016-12-02'),
    (6, 'Frank', 'Miller', 'Finance', 40000, '2022-06-30'),
    (7, 'Grace', 'Davis', 'Marketing', 75000, '2020-09-14'),
    (8, 'Henry', 'White', 'Marketing', 72000, '2020-10-10'),
    (9, 'Ivy', 'Taylor', 'IT', 95000, '2017-04-05'),
    (10, 'Jack', 'Anderson', 'Finance', 105000, '2015-11-12');

SELECT top 10 percent * 
from Employees
ORDER by Salary DESC;

SELECT Department,
    AVG(Salary) as avg_salary
from Employees
GROUP by Department;

SELECT *, 
    case 
        when Salary > 80000 then 'High'
        when Salary between 50000 and 80000 then 'Medium'
        else 'Low'
    end as SalaryCategory
from Employees;

SELECT *, 
    iif(Salary > 80000, 'High', iif(
        Salary >= 50000, 'Medium', 'Low'
    ))  as SalaryCategory
from Employees;

select Department, 
    avg(Salary) as AverageSalary
from Employees
GROUP by Department
order by AverageSalary DESC;

SELECT * from Employees
order by EmployeeID
offset 2 rows fetch next 5 rows only;

-- task 2
drop table if exists Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES 
    (101, 'John Doe', '2023-01-15', 2500, 'Shipped'),
    (102, 'Mary Smith', '2023-02-10', 4500, 'Pending'),
    (103, 'James Brown', '2023-03-25', 6200, 'Delivered'),
    (104, 'Patricia Davis', '2023-05-05', 1800, 'Cancelled'),
    (105, 'Michael Wilson', '2023-06-14', 7500, 'Shipped'),
    (106, 'Elizabeth Garcia', '2023-07-20', 9000, 'Delivered'),
    (107, 'David Martinez', '2023-08-02', 1300, 'Pending'),
    (108, 'Susan Clark', '2023-09-12', 5600, 'Shipped'),
    (109, 'Robert Lewis', '2023-10-30', 4100, 'Cancelled'),
    (110, 'Emily Walker', '2023-12-05', 9800, 'Delivered');

SELECT * from Orders
WHERE OrderDate between  '2023-01-01' and '2023-12-31';

SELECT *,
    case 
        when [Status]='Shipped' or [Status]='Delivered' then 'Completed'
        when [Status]='Pending' then 'Pending'
        when [Status]='Cancelled' then 'Cancelled'
    end as OrderStatus
from Orders;

SELECT 
    case 
        when [Status]='Shipped' or [Status]='Delivered' then 'Completed'
        when [Status]='Pending' then 'Pending'
        when [Status]='Cancelled' then 'Cancelled'
    end as OrderStatus,
    COUNT(*) as TotalOrders, SUM(TotalAmount) as TotalRevenue
from Orders
group by 
    case 
        when [Status]='Shipped' or [Status]='Delivered' then 'Completed'
        when [Status]='Pending' then 'Pending'
        when [Status]='Cancelled' then 'Cancelled'
    end
ORDER by TotalRevenue DESC;

SELECT * from Orders
Where TotalAmount > 5000;

-- task 3
drop table if exists Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES 
    (1, 'Laptop', 'Electronics', 1200, 15),
    (2, 'Smartphone', 'Electronics', 800, 30),
    (3, 'Desk Chair', 'Furniture', 150, 5),
    (4, 'LED TV', 'Electronics', 1400, 8),
    (5, 'Coffee Table', 'Furniture', 250, 0),
    (6, 'Headphones', 'Accessories', 200, 25),
    (7, 'Monitor', 'Electronics', 350, 12),
    (8, 'Sofa', 'Furniture', 900, 2),
    (9, 'Backpack', 'Accessories', 75, 50),
    (10, 'Gaming Mouse', 'Accessories', 120, 20);

SELECT distinct Category
from Products;

SELECT Category,
    max(Price) as MaxPrice
from Products
group by Category;

SELECT p.Category, p.ProductName, p.Price as MaxPrice
FROM Products p
WHERE p.Price = (
    SELECT MAX(Price) 
    FROM Products 
    WHERE Category = p.Category
)
ORDER BY p.Category;

SELECT *,
    iif(Stock=0, 'Out of Stock', iif(
        Stock between 1 and 10, 'Low Stock', 'In Stock'
    )) as StockStatus
from Products
ORDER by Price DESC
OFFSET 5 rows;