CREATE DATABASE hw4;
GO
USE hw4;

-- task 1
DROP TABLE if EXISTS [dbo].[TestMultipleZero];
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT * FROM [dbo].[TestMultipleZero] WHERE A+B+c+d != 0;

-- task 2
DROP TABLE if EXISTS TestMax;
CREATE TABLE TestMax
(
    Year1 INT, 
    Max1 INT, 
    Max2 INT, 
    Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

SELECT Year1, GREATEST(Max1, Max2, max3) as Max 
FROM TestMax;

-- task 3
DROP TABLE if EXISTS EmpBirth;
CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
GO
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

SELECT *
from EmpBirth
where MONTH(BirthDate)=5 and (day(BirthDate) between 7 and 15);

-- task 4
drop table if EXISTS letters;
create table letters
(letter char(1));
go
insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

-- b is 1st
select letter
from letters
order by 
case 
    when letter='b' then 1
    else 2
end, letter;

-- b is last
select letter
from letters
order by 
case 
    when letter='b' then 2
    else 1
end, letter;

-- b is 3rd (it just ensures that 'b' is after all a's)
select letter
from letters
order by 
case 
    when letter='b' then 2
    when letter<'b' then 1
    else 3
end, letter;
