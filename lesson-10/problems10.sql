create database prb10;
go 
use prb10;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductName VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders VALUES 
	(1, 'Alice', '2024-03-01'),
	(2, 'Bob', '2024-03-02'),
	(3, 'Charlie', '2024-03-03');

INSERT INTO OrderDetails VALUES 
	(1, 1, 'Laptop', 1, 1000.00),
	(2, 1, 'Mouse', 2, 50.00),
	(3, 2, 'Phone', 1, 700.00),
	(4, 2, 'Charger', 1, 30.00),
	(5, 3, 'Tablet', 1, 400.00),
	(6, 3, 'Keyboard', 1, 80.00);

select * from orders;
select * from OrderDetails;

select o.OrderID, o.CustomerName,
(select max(UnitPrice) as MaxPrice
from OrderDetails od
where od.OrderID = o.OrderID),
(select ProductName
from OrderDetails od
where od.OrderID = o.OrderID)
from Orders o