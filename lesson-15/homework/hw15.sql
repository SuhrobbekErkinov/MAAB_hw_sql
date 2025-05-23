create database hw15;
go
use hw15;

DROP TABLE IF EXISTS Contacts;
CREATE TABLE Contacts
(
	identifier_name NVARCHAR(50),
	identifier_value NVARCHAR(255),
	firstname NVARCHAR(255),
	lastname NVARCHAR(255),
	website NVARCHAR(255),
	company NVARCHAR(255),
	phone NVARCHAR(255),
	address NVARCHAR(255),
	city NVARCHAR(255),
	state NVARCHAR(255),
	zip NVARCHAR(255),
);

INSERT INTO Contacts(identifier_name, identifier_value, firstname, lastname, website, company, phone, address, city, state, zip)
VALUES 
	('vid', '259429', 'Harper', 'Wolfberg', 'http://hubspot.com', 'HubSpot', '555-122-2323', '25 First Street', 'Cambridge', 'MA', '02139'),
	('email', 'testingapis@hubspot.com', 'Codey', 'Huang', 'http://hubspot.com', 'HubSpot', '555-122-2323', '25 First Street', 'Cambridge', 'MA', '02139'),
    ('email', 'john.doe@example.com', 'John', 'Doe', 'http://example.org', 'Example Inc', '555-345-6789', '456 Oak St', 'Boston', 'MA', '02110'),
    ('email', 'alice.wonderland@fable.com', 'Alice', 'Wonderland', 'http://fable.com', 'Fable Enterprises', '555-987-6543', '102 Rabbit Hole', 'Wonderland', 'CA', '90210'),
	('vid', '543210', 'Ava', 'Smith', 'http://example.com', 'Example Corp', '555-233-4545', '123 Maple Ave', 'Springfield', 'IL', '62701'),
    ('vid', '987654', 'Jane', 'Roe', 'http://company.net', 'Company LLC', '555-678-1234', '789 Pine Rd', 'New York', 'NY', '10001'),
    ('email', 'emily.brown@company.com', 'Emily', 'Brown', 'http://company.com', 'Company Ltd', '555-222-3333', '88 Blueberry Lane', 'Austin', 'TX', '73301'),
    ('vid', '321987', 'Robert', 'Johnson', 'http://robertj.com', 'RJ Consulting', '555-111-2222', '22 Lincoln Way', 'Columbus', 'OH', '43215'),
    ('vid', '654321', 'Michael', 'Davis', 'http://davistech.com', 'Davis Technologies', '555-444-5555', '99 Tech Park', 'Seattle', 'WA', '98109'),
    ('email', 'oliver.queen@starcity.com', 'Oliver', 'Queen', 'http://starcity.com', 'Star City Industries', '555-777-8888', '567 Arrow St', 'Star City', 'CA', '94016');

-- task 1

select * from Contacts;
DECLARE @json NVARCHAR(MAX);
SET @json = (
    SELECT 
        identifier_name AS [key], 
        identifier_value AS value,
        (
            SELECT 
                COLUMN_NAME AS property, 
                CAST(C.[identifier_value] AS NVARCHAR(MAX)) AS value
            FROM INFORMATION_SCHEMA.COLUMNS IC
            CROSS APPLY (SELECT TOP 1 * FROM Contacts T WHERE T.identifier_name = C.identifier_name) C
            WHERE IC.TABLE_NAME = 'Contacts' 
            AND IC.ORDINAL_POSITION >= 3
            FOR JSON PATH
        ) AS properties
    FROM Contacts C
    FOR JSON PATH, ROOT('Contacts')
);
SELECT @json;


go

declare @json nvarchar(max);

declare @properties nvarchar(max);
set @properties=
(select string_agg('{"property":"'+column_name+'","value":"', '},') from information_schema.columns 
where table_name='Contacts' and ordinal_position>=3);

set @json=
  (select STRING_AGG('{"' + identifier_name + '": "' + identifier_value + '", "properties":["property:"'+@properties+'"]}', ', ') from Contacts);
select @json;

select firstname from Contacts;
select * from Contacts where identifier_value='259429'
select '{"'+concat(identifier_name,'":"', identifier_value, '", "properties":[]}') from Contacts;
select column_name from information_schema.columns where table_name='Contacts' and ordinal_position>=3; 
select * from contacts;
declare @sql nvarchar(max)=
'select @outValue = CAST(['+column_name+'] AS NVARCHAR(MAX)) from Contacts where identifier_value=''259429''
cross apply (SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = ''Contacts'' AND ordinal_position >= 3) col'
with cter as(
select 3 as n, (select column_name from information_schema.columns where table_name='Contacts' and ordinal_position=3) as column_name,
(select firstname from Contacts where identifier_value='259429') as value
union all
select n+1, (select column_name from information_schema.columns where table_name='Contacts' and ordinal_position=n+1),  from cter
)
;with cte as (
  select 1 as n, 
  (select string_agg('{"property":"'+column_name+'","value":', '},') from information_schema.columns where table_name='Contacts' and ordinal_position>=3) as property, 
  (select STRING_AGG('{"' + identifier_name + '": "' + identifier_value + '", "properties":'+@properties+'"]}', ', ')
    FROM Contacts c) as code
	union all
	select n+1,property, code from cte
	where n<10
)
select * from cte;
select column_name from information_schema.columns where table_name='Contacts' and ordinal_position>=3;

SET @json = '[' + @json + ']';  
SELECT @json;


go
declare @countofcol int=(select max(ordinal_position) from information_schema.columns where table_name='Contacts')
select column_name from information_schema.columns where table_name='Contacts' and ordinal_position>=3;


-- task 2
go
drop table if exists #view;
create table #view(
 num int identity(1,1),
 identifier_name nvarchar(max),
 identifier_value nvarchar(max),
 property nvarchar(max),
 value nvarchar(max)
)
declare @columns nvarchar(MAX);
declare @sql nvarchar(MAX);

select @columns = string_agg(quotename(column_name), ', ')
from information_schema.columns
where table_name = 'Contacts' AND ordinal_position >=3;


SET @sql = '
select identifier_name, identifier_value, columns AS property, entries AS value
from Contacts c
UNPIVOT (entries FOR columns IN (' + @columns + ')) anpvt;';

insert into #view(identifier_name, identifier_value, property, value)
EXEC sp_executesql @sql;
select * from #view;
declare @final nvarchar(max);
set @final='['+(
select string_agg(properties_json, ',') from(
select 
    identifier_name, 
    identifier_value,
    '{"'+identifier_name+'":"'+identifier_value+'","properties":[' + string_agg(
        '{"property":"' + property + '","value":"' + value + '"}', 
        ','
    ) + ']}' as properties_json
from #view
group by identifier_name, identifier_value) t1)+']';
select @final;

GO

drop table if exists items;
create table items
(
	ID varchar(10),
	CurrentQuantity int,
	QuantityChange int,
	ChangeType varchar(10),
	Change_datetime datetime
);
insert into items
values 
	('A0013', 278,   99 ,   'out', '2020-05-25 0:25'), 
	('A0012', 377,   31 ,   'in',  '2020-05-24 22:00'),
	('A0011', 346,   1  ,   'out', '2020-05-24 15:01'),
	('A0010', 347,   1  ,   'out', '2020-05-23 5:00'),
	('A009',  348,   102,   'in',  '2020-04-25 18:00'),
	('A008',  246,   43 ,   'in',  '2020-04-25 2:00'),
	('A007',  203,   2  ,   'out', '2020-02-25 9:00'),
	('A006',  205,   129,   'out', '2020-02-18 7:00'),
	('A005',  334,   1  ,   'out', '2020-02-18 6:00'),
	('A004',  335,   27 ,   'out', '2020-01-29 5:00'),
	('A003',  362,   120,   'in',  '2019-12-31 2:00'),
	('A002',  242,   8  ,   'out', '2019-05-22 0:50'),
	('A001',  250,   250,   'in',  '2019-05-20 0:45');
select * from items order by ChangeType, Change_datetime;

--the table to make the final table
drop table if exists #visual;
create table #visual
(
	 [quantity change] int,
	 days int
);

--the table containing only out items
drop table if exists #out;
create table #out 
(
	num int identity(1,1),
	ID varchar(10),
	CurrentQuantity int,
	QuantityChange int,
	ChangeType varchar(10),
	Change_datetime datetime
);
insert into #out(ID, Currentquantity, quantitychange, changetype, change_datetime)
select * from items where ChangeType='out' order by change_datetime asc;

--the table containing only in items
drop table if exists #in;
create table #in 
(
	num int identity(1,1),
	ID varchar(10),
	CurrentQuantity int,
	QuantityChange int,
	ChangeType varchar(10),
	Change_datetime datetime
);
insert into #in(ID, Currentquantity, quantitychange, changetype, change_datetime)
select * from items where ChangeType='in' order by change_datetime asc;

select * from #out;
select * from #in;

--actual process
declare @first int;
declare @second int;
declare @third int;
declare @fourth int;
declare @fifth int;
declare @in int;
declare @out int=0;
declare @i int=1;
declare @j int=1;
declare @outcount int =(select count(*) from items where ChangeType='out')
declare @incount int=(select count(*) from items where ChangeType='in')

set @out=(select QuantityChange from #out where num=1);


while @i<=@incount
begin
	set @in=(
	select QuantityChange from #in where num=@i);

	--we start to decrease 'in' items relative to 'out'
	while @out<@in --when 'in' items are not enough to out, it exits
	begin 
		insert into #visual
		values
			(@out, datediff(day, (select change_datetime from #in where num=@i), (select change_datetime from #out where num=@j)));
		set @in=@in-@out;
		set @j=@j+1;
		--when there is no 'out' item left, it should stop looping in '#out' table
		if @j>@outcount
			break;
		set @out=(select QuantityChange from #out where num=@j);
	end
	--when there is no 'out' item left, it should stop looping in '#in' table too
	if @j>@outcount
	break;
	  
	insert into #visual
	values
		(@in, datediff(day, (select change_datetime from #in where num=@i), (select change_datetime from #out where num=@j)));
	set @out=@out-@in
	set @i=@i+1
end

--we should insert the last value we came to in '#in' table
insert into #visual 
values
	(@in, datediff(day, (select change_datetime from #in where num=@i), (select max(change_datetime) from items)));
--now, inserting other not changed 'in' items in '#in' table
while @i<@incount
begin
	set @i=@i+1;
	insert into #visual
	values
		((select quantitychange from #in where num=@i), datediff(day, (select change_datetime from #in where num=@i), (select max(change_datetime) from items)));
end;

select * from #visual;

--only for this specific case
select
(select sum([quantity change]) from #visual where days between 1 and 90) as [1-90 days old], 
(select sum([quantity change]) from #visual where days between 91 and 180) as [91-180 days old],
(select sum([quantity change]) from #visual where days between 181 and 270) as [181-270 days old],
(select sum([quantity change]) from #visual where days between 271 and 360) as [271-360 days old],
(select sum([quantity change]) from #visual where days between 361 and 450) as [361-450 days old];

--select max(days)/90+1 from #visual;


select * from #visual;
declare @num int=0
declare @finalsql nvarchar(max)='select'
while @num<(select max(days)/90+1 from #visual)
begin
if (select sum([quantity change]) from #visual where days between 90*@num+1 and 90*(@num+1)) is null
begin
set @num=@num+1
continue
end
else
set @finalsql=@finalsql+'(select sum([quantity change]) from #visual where days between '+cast(@num*90+1 as nvarchar(max))+' and '+cast((@num+1)*90 as nvarchar(max))+') 
as ['+cast(@num*90+1 as nvarchar(max))+'-'+cast((@num+1)*90 as nvarchar(max))+' days old],'
set @num=@num+1;
end
set @finalsql= (select left(@finalsql, len(@finalsql)-1)+';' where right(@finalsql, 1)=',')

exec sp_executesql @finalsql;

--to check
/*insert into #visual
values
(12, 542);*/