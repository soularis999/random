----------------------------------------------------------------------------------------------
-- SHOW PERMISSIONS 
--
-- This script will display all users and their permissions in the database.
-- 6/14/2002	DavidLee
----------------------------------------------------------------------------------------------
SET NOCOUNT ON
DECLARE @database varchar(128)
, @obj varchar(2000)
, @message varchar(4000)
, @rolename varchar(200)

create table #cmd ( db varchar(50), Grantee varchar(200) , obj varchar(2000), type char(2), uid smallint, owner varchar(200))

DECLARE db_cursor CURSOR FOR 
SELECT name
FROM master..sysdatabases

OPEN db_cursor

FETCH NEXT FROM db_cursor 
INTO @database

WHILE @@FETCH_STATUS = 0
BEGIN
   select @message = 'insert into #cmd select ''' + @database + ''', u.Name, o.name, o.type, o.uid, Null from ' + @database + '.dbo.syspermissions p join ' + @database + '.dbo.sysobjects o on o.id = p.id join ' + @database + '.dbo.sysusers u on u.uid = p.Grantee'
   exec (@message)

   FETCH NEXT FROM db_cursor 
   INTO @database
END

CLOSE db_cursor
DEALLOCATE db_cursor

-- Update the object owners
update #cmd set owner = u.name 
from #cmd c 
join sysusers u on u.uid = c.uid
GO

print 'Permissions by Database, per User'
select distinct db, Grantee, Count=count(*) from #cmd Group By db, Grantee order by db, Grantee 
print 'Object Permissions for each User'
select Grantee, db, obj, type, uid, owner from #cmd order by Grantee, db, type, obj
GO
drop table #cmd
GO