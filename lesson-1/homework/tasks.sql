DROP DATABASE IF EXISTS hw1;
CREATE DATABASE hw1;
USE hw1;

--task1
DROP table if EXISTS student;

CREATE TABLE student (
    id int NULL,
    name VARCHAR(50) NULL,
    age int NOT NULL 
);

ALTER TABLE student
ALTER COLUMN id INT NOT NULL;

--task2
DROP TABLE IF EXISTS product;
CREATE TABLE product (
    product_id INT CONSTRAINT uq_product_id UNIQUE,
    product_name NVARCHAR(100),
    price DEC(10, 2)
);
ALTER TABLE product
DROP CONSTRAINT uq_product_id;

ALTER TABLE product
ADD CONSTRAINT product_id_cs UNIQUE(product_id);

ALTER TABLE product
ADD UNIQUE(product_id, product_name);

--task3
DROP TABLE if EXISTS orders;

CREATE TABLE orders (
    order_id INT CONSTRAINT pm_order_id PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE
);
ALTER TABLE orders
DROP CONSTRAINT pm_order_id;

ALTER TABLE orders
ADD PRIMARY KEY(order_id);

--task4
DROP TABLE if EXISTS category;
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

DROP TABLE IF EXISTS item;
CREATE TABLE item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT 
    CONSTRAINT fk_category_id FOREIGN KEY 
    REFERENCES category(category_id)
);

ALTER TABLE item
DROP CONSTRAINT fk_category_id;

--task5
DROP TABLE if EXISTS account;
CREATE TABLE account (
    account_id INT PRIMARY KEY,
    balance DEC(15, 5) CONSTRAINT ch_balance CHECK(balance>=0),
    account_type VARCHAR(100) CONSTRAINT ch_account_type
    CHECK(account_type='Saving' or account_type='Checking')
);

ALTER TABLE account
DROP CONSTRAINT ch_balance;

ALTER TABLE account
ADD CONSTRAINT ch_balance CHECK(balance>=0);
 
ALTER TABLE account
DROP CONSTRAINT ch_account_type;

ALTER TABLE account
ADD CONSTRAINT ch_account_type 
CHECK(account_type='Saving' or account_type='Checking')

--task6
DROP TABLE if EXISTS customer;
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100) CONSTRAINT d_city DEFAULT 'Unknown'
);

ALTER TABLE customer
DROP CONSTRAINT d_city;

ALTER TABLE customer
ADD CONSTRAINT d_city DEFAULT 'Unknown' FOR city;

--task7
DROP table if EXISTS invoice;
CREATE TABLE invoice (
    invoice_id INT IDENTITY,
    amount DEC(10, 2)
);
INSERT into invoice(amount)
VALUES 
    (10.5),
    (11.5),
    (12.5),
    (13.5),
    (14.5);

SELECT * FROM invoice;

SET IDENTITY_INSERT invoice off;
INSERT into invoice(invoice_id, amount)
VALUES (100, 13.33);

SET IDENTITY_INSERT invoice on;
INSERT into invoice(invoice_id, amount)
VALUES (100, 14.44);

--task8
DROP TABLE if EXISTS books;
CREATE TABLE books (
    book_id INT PRIMARY KEY IDENTITY(1000, 1),
    title VARCHAR(100) 
    CONSTRAINT ch_title CHECK(LEN(title)>0) NOT NULL,
    price DEC(10, 2) CONSTRAINT ch_price CHECK(price>0) NOT NULL,
    genre VARCHAR(100) CONSTRAINT d_genre DEFAULT 'Unknown'
);
INSERT into books(title, price)
values 
    ('hey', 13.5);

SELECT * FROM books;

--task9
DROP TABLE if EXISTS Book;
CREATE TABLE Book (
    book_id INT PRIMARY KEY IDENTITY(0001, 1),
    title NVARCHAR(100) NOT NULL,
    author NVARCHAR(100) NOT NULL,
    published_year INT NOT NULL
);

DROP TABLE if EXISTS Member;
CREATE TABLE Member (
    member_id INT PRIMARY KEY IDENTITY(0001, 1),
    name NVARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(100)
    CONSTRAINT uq_phone_number UNIQUE
);

DROP TABLE if EXISTS Loan;
CREATE TABLE Loan (
    loan_id INT PRIMARY KEY,
    book_id INT
    FOREIGN KEY REFERENCES book(book_id),
    member_id INT
    FOREIGN KEY REFERENCES member(member_id),
    loan_date DATE NOT NULL,
    return_date DATE
);

INSERT into Book
VALUES
    ('ufq', 'Said Ahmad', 2005),
    ('jinoyat va jazo', 'Fyodor Dostoyevskiy', 2000)

INSERT into Member
VALUES
    ('Suhrobbek', 's.erkinov@newuu.uz', '+998906172544'),
    ('Muzrobbek', 'm.erkinov@newuu.uz', '+998777022544');

INSERT into Loan
VALUES
    (1, 0001, 0001, '2025-04-08', NULL),
    (2, 0002, 0002, '2025-04-01', '2025-04-07')

SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Loan;