create database hw12;
go
use hw12;

-- task 1
create table #temp(
    DatabaseName VARCHAR(50),
    SchemaName VARCHAR(50),
    TableName VARCHAR(50),
    ColumnName VARCHAR(50),
    DataType VARCHAR(50)
);

declare @alldb NVARCHAR(max);
declare @dbname VARCHAR(max);
declare @i int = 1;
declare @count int;
select @count = count(1)
from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb');
while @i < @count + 1
begin 
;with cte as (
    select name, row_number() over(order by name) as rn
    from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
)
select @dbname = name from cte 
where rn = @i
set @alldb = '
use ['+@dbname+'];
select 
	table_catalog as DatabaseName,
	table_schema as SchemaName,
	table_name as TableName,
	column_name as ColumnName,
	concat(data_type, ''(''+
		(case 
			when cast(character_maximum_length as varchar)=''-1''
			then ''max''
			else cast(character_maximum_length as varchar)
		end)
	+'')'') as DataType
from information_schema.columns;
'
insert into #temp
exec sp_executesql @alldb
set @i = @i + 1
end;
select * from #temp;
go;

-- task 2
alter proc sp_proc @dbname VARCHAR(max)=NULL AS
begin 
    create table #temp1(
        Name varchar(max),
        Type varchar(50),
        DatabaseName varchar(max),
        SchemaName varchar(50),
        Parameter varchar(50),
        DataType varchar(50)
    );
    declare @sql nvarchar(max);
    declare @databases table(
        ID int identity(1,1),
        Name varchar(max)
    );
    insert into @databases(name)
    select name from sys.databases
    where name not in ('master', 'tempdb', 'model', 'msdb');
    declare @i int=1;
    declare @count int;
    select @count=count(*) from @databases;
        if @dbname is not null
            begin 
                set @sql='
                    use ['+@dbname+'];
                    select 
                        rt.routine_name as Name,
                        rt.routine_type as Type,
                        rt.routine_catalog as DatabaseName,
                        rt.routine_schema as SchemaName,
                        pr.parameter_name as Parameter,
                        concat(pr.data_type, ''('' + 
                            (case 
                                when 
                                    cast(pr.character_maximum_length as varchar)=''-1''
                                    then ''max''
                                else 
                                    cast(pr.character_maximum_length as varchar)
                            end)
                        + '')'') as DataType
                    from information_schema.routines rt 
                    join information_schema.parameters pr
                        on rt.routine_name = pr.specific_name
                '
                insert into #temp1 
                exec sp_executesql @sql;
                select * from #temp1;
            end 
        else
            begin 
                while @i <= @count
                    begin 
                        select @dbname = name from @databases 
                        where id = @i;
                        set @sql='
                            use ['+@dbname+'];
                            select 
                                rt.routine_name as Name,
                                rt.routine_type as Type,
                                rt.routine_catalog as DatabaseName,
                                rt.routine_schema as SchemaName,
                                pr.parameter_name as Parameter,
                                concat(pr.data_type, ''('' + 
                                    (case 
                                        when 
                                            cast(pr.character_maximum_length as varchar)=''-1''
                                            then ''max''
                                        else 
                                            cast(pr.character_maximum_length as varchar)
                                    end)
                                + '')'') as DataType
                            from information_schema.routines rt 
                            join information_schema.parameters pr
                                on rt.routine_name = pr.specific_name 
                        ' 
                        insert into #temp1 
                        exec sp_executesql @sql;
                    set @i = @i + 1 
                end;
                select * from #temp1;
            end;
        drop table #temp1;
end;
exec sp_proc;
    
