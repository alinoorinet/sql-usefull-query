use [reza_score];
go

IF OBJECT_ID(N'tempdb.dbo.#Msg_Unique_Ids') IS NOT NULL
    drop table #Msg_Unique_Ids
CREATE TABLE #Msg_Unique_Ids(Id int not null);	

INSERT INTO  
	#Msg_Unique_Ids (Id)
SELECT 
	Id
FROM 
	Sms
WHERE 
    Id IN (SELECT MIN(Id) FROM Sms GROUP BY Mobile)

UPDATE [dbo].[Sms] SET [Status] = 2
UPDATE [dbo].[Sms] SET [Status] = 1 WHERE Id IN (SELECT Id FROM #Msg_Unique_Ids)

DECLARE @Mobile nvarchar(11);

DECLARE db_cursor CURSOR FOR SELECT Mobile FROM [dbo].[Sms]

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @Mobile  

WHILE @@FETCH_STATUS = 0  
	BEGIN  
		print @mobile
		IF NOT EXISTS(SELECT TOP 1 * FROM Users WHERE Mobile = @Mobile)
			UPDATE [dbo].[Sms] SET [Status] = 3 WHERE Mobile = @Mobile
		FETCH NEXT FROM db_cursor INTO @Mobile 
	END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

SELECT 
	* 
FROM 
	Sms s
	LEFT JOIN Users u on s.Mobile = u.Mobile