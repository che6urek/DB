--Task 1--

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name='NewDatabase')
DROP DATABASE NewDatabase;

CREATE DATABASE NewDatabase;
GO

USE NewDatabase;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE NewDatabase
	TO DISK = 'C:\SQL\DB\lab1\Evgeny_Drozhzha.bak';
GO

USE master;
GO

DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase	
	FROM DISK = 'C:\SQL\DB\lab1\Evgeny_Drozhzha.bak';
GO