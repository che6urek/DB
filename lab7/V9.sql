--Task 1--

USE AdventureWorks;
GO

--Task 1.a--

DECLARE @DepartmentHistoryXml XML;

SET @DepartmentHistoryXml = (
	SELECT
		edh.StartDate [Start], 
		edh.EndDate [End], 
		d.GroupName [Department/Group], 
		d.Name [Department/Name]
	FROM HumanResources.EmployeeDepartmentHistory edh
		INNER JOIN HumanResources.Department d
			ON (d.DepartmentID = edh.DepartmentID)
		FOR XML PATH ('Transaction'), ROOT('History'));

SELECT @DepartmentHistoryXml;

--Task 1.b--

CREATE TABLE #temporary (sql XML);

INSERT INTO #temporary
	SELECT DepartmentHistoryXml.c.query('.')
	FROM @DepartmentHistoryXml.nodes('History/Transaction/Department') DepartmentHistoryXml(c);

SELECT * FROM #temporary;