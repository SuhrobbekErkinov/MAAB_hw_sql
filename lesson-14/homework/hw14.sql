create database hw14;
go
use hw14;

exec msdb.dbo.sysmail_add_account_sp
@account_name='FirstAccount',
@description = 'SMTP Account for SQL Server',
@port = 587,
@username='suhrobbekerkinov2806@gmail.com',
@password='ebwo sbdq yfyk thdl',
@display_name = 'SQL Server Mail', 
@email_address='suhrobbekerkinov2806@gmail.com',
@mailserver_name='smtp.gmail.com',
@enable_ssl = 1;


exec msdb.dbo.sysmail_add_profileaccount_sp
@profile_name='FirstProfile',
@account_name='FirstAccount',
@sequence_number=1;

exec msdb.dbo.sysmail_add_principalprofile_sp
@profile_name='FirstProfile',
@principal_name='public',
@is_default='1';

declare @html nvarchar(max);
set @html=N'
<html>
<head>
    <style>
        table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>SQL Server Index Metadata Report</h2>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Type</th>
        </tr>
'+CAST((
            SELECT 
                td = t.name, '', 
                td = i.name, '', 
                td = i.type_desc, '', 
                td = ty.name  -- Retrieves column type
            FROM sys.indexes i
            JOIN sys.tables t ON i.object_id = t.object_id
            JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
            JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            JOIN sys.types ty ON c.user_type_id = ty.user_type_id  -- Getting the data type
            WHERE i.type > 0 -- Exclude heap indexes
            FOR XML PATH('tr'), TYPE
        ) AS NVARCHAR(MAX))+
		N'</table></body></html>';
exec msdb.dbo.sp_send_dbmail
@profile_name='FirstProfile',
@recipients='s.erkinov@newuu.uz',
@subject='SQL Server Index Metadata Report',
@body=@html,
@body_format='HTML';




