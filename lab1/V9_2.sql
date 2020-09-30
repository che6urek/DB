--Task 2--

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name='AdventureWorks')
DROP DATABASE AdventureWorks;

RESTORE DATABASE AdventureWorks
	FROM DISK = 'C:\SQL\AdventureWorks2012-Full Database Backup.bak'
	WITH MOVE 'AdventureWorks2012_Data' TO 'C:\SQL\AdventureWorks2012_Data.mdf',
	MOVE 'AdventureWorks2012_Log' TO 'C:\SQL\AdventureWorks2012_Log.ldf';
GO

USE AdventureWorks
GO

--Task 2.1--

SELECT 
	BusinessEntityID, JobTitle, BirthDate, HireDate
FROM
	AdventureWorks.HumanResources.Employee
WHERE
	BirthDate >= '1981-01-01' AND HireDate > '2003-04-1';

--Task 2.2--

SELECT 
	SUM(VacationHours) as SumVacationHours, SUM(SickLeaveHours) as SumSickLeaveHours
FROM
	AdventureWorks.HumanResources.Employee;

--Task 2.3--

SELECT TOP 3 
	BusinessEntityID, JobTitle, BirthDate, HireDate
FROM
	AdventureWorks.HumanResources.Employee
ORDER BY 
	HireDate;