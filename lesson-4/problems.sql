use hw4;

create table parent
(
	pname varchar(50),
	cname varchar(50),
	gender char(1)
);

insert into parent
values
	('Karen', 'John', 'M'),
	('Karen', 'Steve', 'M'),
	('Karen', 'Ann', 'F'),
	('Rich', 'Cody', 'M'),
	('Rich', 'Stacy', 'F'),
	('Rich', 'Mike', 'M'),
	('Tom', 'John', 'M'),
	('Tom', 'Ross', 'M'),
	('Tom', 'Rob', 'M'),
	('Roger', 'Brandy', 'F'),
	('Roger', 'Jennifer', 'F'),
	('Roger', 'Sara', 'F')

SELECT * from parent;

SELECT pname
from parent
GROUP by pname
HAVING count(distinct gender) =2;