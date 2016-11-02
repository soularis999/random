----------------------------------------------------------------------------------------------
-- REVOKE PERMISSIONS TO PUBLIC
--
-- This script will evaluate your database and create a script which revokes permissions
-- to the PUBLIC role.  The only required permission for PUBLIC is SELECT on spt_values.
--
-- Simply paste the text results of the script back into the query window and execute.
--
-- NOTE:  it is expected that some system functions can not be removed from PUBLIC.
--        you may see warnings such as:
--                Invalid object name 'system_function_schema.fn_updateparameterwithargument'.
----------------------------------------------------------------------------------------------
SET NOCOUNT ON
DECLARE @database varchar(128)
, @cmd varchar(2000)
, @message varchar(4000)
, @rolename varchar(200)

select @rolename = 'public'

create table #cmd ( db varchar(50), cmd varchar(2000), type char(2), uid smallint, owner varchar(200) )

DECLARE db_cursor CURSOR FOR 
SELECT name
FROM master..sysdatabases

OPEN db_cursor

FETCH NEXT FROM db_cursor 
INTO @database

WHILE @@FETCH_STATUS = 0
BEGIN
   -- Get the list of objects in this database with permissions to public 
   select @message = 'insert into #cmd select ''' + @database + ''', o.name, o.type, o.uid, Null from ' + @database + '.dbo.syspermissions p join ' + @database + '.dbo.sysobjects o on o.id = p.id where p.grantee = (select uid from sysusers where name = ''public'')'
   exec (@message)

   -- Update the owners for this database
   select @message = 'update #cmd set owner = u.name from #cmd c join ' + @database + '..sysusers u on u.uid = c.uid where c.db = ''' + @database + ''''
   exec (@message)

   FETCH NEXT FROM db_cursor 
   INTO @database
END

CLOSE db_cursor
DEALLOCATE db_cursor

GO

-----------------------------------------------------------
DECLARE @database varchar(128)
, @cmd varchar(2000)
, @message varchar(4000)
, @lastDb varchar(128)
, @owner varchar(200)


select @lastDb = ''

   DECLARE obj_cursor CURSOR FOR 
   SELECT db, cmd, owner from #cmd order by db, cmd

   OPEN obj_cursor
   FETCH NEXT FROM obj_cursor INTO @database, @cmd, @owner 

   IF @@FETCH_STATUS <> 0 
      PRINT '--         Public is secure!'

   WHILE @@FETCH_STATUS = 0
   BEGIN

      if (@lastdb <> @database)
      BEGIN
         if (@lastdb <> '') Print 'GO'
         print '------------------------------------------------------------------------------'
         print '-- ' + @database + ': Clear PUBLIC permissions on database.'
         print 'USE ' + @database
         print 'GO'
         set @lastdb = @database
      END      

      set @owner = '['+@owner+'].'
      if NOT @cmd is NULL
      BEGIN
          SELECT @message = 'REVOKE ALL ON '+ ISNULL(@owner,'') + '[' + @cmd + '] to public'
          PRINT @message
      END
      --EXEC @message

      FETCH NEXT FROM obj_cursor INTO @database, @cmd, @owner
   END

   CLOSE obj_cursor
   DEALLOCATE obj_cursor

GO
drop table #cmd
go
print 'GO'
print '----------------------------------------------------------------------------------'
print '-- ADD REQUIRED PERMISSIONS BACK TO MASTER!'
print 'use master'
print 'GO'
print 'GRANT SELECT on spt_values to public'
print 'GRANT EXEC on sp_MSHasDBAccess to public'
print 'GO'

