CREATE DATABASE hw2;
USE hw2;

-- task 1
DROP TABLE if EXISTS test_identity;
CREATE TABLE test_identity 
(
    id TINYINT PRIMARY KEY IDENTITY(1, 1),
    name VARCHAR(10)
);

INSERT test_identity
SELECT 'suhrob'

SELECT * FROM test_identity;

DELETE from test_identity WHERE id=5;
DELETE test_identity;
TRUNCATE TABLE test_identity;

-- difference between delete and truncate is that we can use delete with statements 
-- truncate just deletes everything from the table and initializes the identity as the first value given when declaring
-- delete also deletes everything if used without a statement and deletes wherever you point and if a new item is inserted identity value continues where it stops
-- drop, on the other hand, just deletes table fully, select op will not work meaning table just seizes to exist from the database

-- task 2
DROP TABLE if EXISTS data_types_demo;
CREATE TABLE data_types_demo
(
    id INT PRIMARY KEY IDENTITY,
    tiny_int TINYINT,
    small_int SMALLINT,
    big_int BIGINT,
    dec_v DEC(10, 3),
    float_v FLOAT,
    char_v CHAR(10),
    varch_v VARCHAR(10),
    text_v TEXT,
    nt_v NTEXT,
    date_v DATE,
    time_v TIME,
    dt_v DATETIME,
    ui UNIQUEIDENTIFIER,
    vb VARBINARY(MAX)
);

INSERT into data_types_demo
SELECT 40, 30000, 200000000, 88.90155, 23.4444, 'char', 'varchar',
        'assalomu alaykum', 'va alaykum assalom', '2025-04-12', 
        '21:32:32', GETDATE(), NEWID(), * FROM openrowset (
            BULK '/data/image-3.jpg', single_blob
        ) as img;
SELECT * FROM data_types_demo;

-- task 3
DROP TABLE if EXISTS photos;
CREATE TABLE photos 
(
    id TINYINT IDENTITY,
    name VARCHAR(10),
    photo VARBINARY(MAX)
);

INSERT into photos
SELECT 'ghibli', * from openrowset (
    BULK '/data/image-3.jpg', single_blob
) as img;

SELECT * FROM photos;

-- task 4
CREATE TABLE student 
(
    id INT PRIMARY KEY IDENTITY,
    classes INT NOT NULL,
    tuition_per_class FLOAT NOT NULL, 
    total_tuition as classes*tuition_per_class
);

INSERT into student
VALUES 
    (4, 40.89),
    (3, 32.87);

SELECT * FROM student;

-- task 5
DROP TABLE if EXISTS worker;
CREATE TABLE worker 
(
    id INT PRIMARY KEY IDENTITY, 
    name VARCHAR(50)
);

BULK insert worker
FROM '/data/worker.csv'
with(
    firstrow=2,
        fieldterminator=',',
        rowterminator='\n'
);

SELECT * FROM worker;