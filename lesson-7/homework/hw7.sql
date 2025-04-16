create database hw7;
go
use hw7;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);


INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

-- task 1
select 
    c.CustomerID as CustomerID,
    c.CustomerName as CustomerName,
    o.OrderID as OrderID,
    o.OrderDate as OrderDate
from Customers c
left join Orders o
    on c.CustomerID = o.CustomerID;

-- task 2
select 
    c.CustomerName as CustomerName,
    o.OrderID as OrderID
from Customers c 
left join Orders o
    on c.CustomerID = o.CustomerID where o.OrderID is NULL;

-- task 3
select 
    od.ProductID as ProductID,
    p.ProductName as ProductName,
    o.OrderID as OrderID,
    od.Quantity as Quantity
from Orders o 
join OrderDetails od 
    on o.OrderID = od.OrderID
join Products p 
    on od.ProductID = p.ProductID;

-- task 4
select 
    c.CustomerName
from Customers c
join Orders o
    on c.CustomerID = o.CustomerID 
    group by c.CustomerName 
    having count(*) > 1;

-- task 5
select 
    o.OrderID OrderID,
    p.ProductName ProductName
from Orders o 
join OrderDetails od 
    on o.OrderID = od.OrderID
join Products p 
    on od.ProductID = p.ProductID
    where od.Price=(
        select max(price)
        from OrderDetails
        where OrderID=o.OrderID
    )
    order by o.OrderID;

-- task 6
select 
    c.CustomerName,
    o.OrderID,
    o.OrderDate
from Customers c 
join Orders o 
    on c.CustomerID = o.CustomerID
    where o.OrderDate=(
        select max(OrderDate)
        from Orders
        where CustomerID = c.CustomerID
    )
    order by c.CustomerID;

-- task 7
select 
    c.CustomerName
from Customers c 
join Orders o 
    on c.CustomerID = o.CustomerID
join OrderDetails od 
    on o.OrderID = od.OrderID
join Products p 
    on od.ProductID = p.ProductID
group by c.CustomerName
having count(case when p.Category != 'Electronics' then p.ProductID end) = 0;

-- task 8
select 
    distinct c.CustomerID,
    c.CustomerName
from Customers c 
join Orders o 
    on c.CustomerID = o.CustomerID
join OrderDetails od 
    on o.OrderID = od.OrderID
join Products p 
    on od.ProductID = p.ProductID
    where p.Category = 'Stationery';

-- task 9
select 
    c.CustomerID,
    c.CustomerName,
    sum(od.Price*od.Quantity) as TotalSpent
from Customers c 
join Orders o 
    on c.CustomerID = o.CustomerID
join OrderDetails od 
    on o.OrderID = od.OrderID
group by c.CustomerID, c.CustomerName

