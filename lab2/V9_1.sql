--Task 1--

USE AdventureWorks;
GO

--Task 1.1--

SELECT 
	Employee.BusinessEntityID, JobTitle, AVG(Rate) as AverageRate
FROM
	HumanResources.Employee
	INNER JOIN HumanResources.EmployeePayHistory
	ON (Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID)
GROUP BY
	Employee.BusinessEntityID, JobTitle;

--Task 1.2--

SELECT 
	Employee.BusinessEntityID, JobTitle, Rate, 
	CASE 
		WHEN Rate <= 50 
			THEN 'Less or equal 50'
		WHEN Rate > 50 AND Rate <= 100 
			THEN 'More than 50 but less or equal 100'
		ELSE 'More than 100'
	END AS RateReport	
FROM
	HumanResources.Employee
	INNER JOIN HumanResources.EmployeePayHistory
	ON (Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID);

--Task 1.3--

SELECT 
	Name, MAX(Rate) AS MaxRate
FROM
	HumanResources.Department
	INNER JOIN HumanResources.EmployeeDepartmentHistory
	ON ((Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID) AND (EndDate IS NULL))
	INNER JOIN HumanResources.Employee
	ON (EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID)
	INNER JOIN HumanResources.EmployeePayHistory
	ON ((Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID) AND (Rate > 60))
GROUP BY
	Name
ORDER BY
	MaxRate;