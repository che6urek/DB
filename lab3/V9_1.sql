--Task 1--

USE AdventureWorks;
GO

--Task 1.a--

ALTER TABLE dbo.StateProvince
	ADD AddressType NVARCHAR(50);
GO

--Task 1.b--

DECLARE @StateProvince TABLE
(
	StateProvinceID INT NOT NULL,
	StateProvinceCode NCHAR(3) NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL,
	IsOnlyStateProvinceFlag SMALLINT NULL,
	Name dbo.Name NOT NULL,
	TerritoryID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	AddressType NVARCHAR(50) NULL
);

INSERT INTO @StateProvince 
SELECT 
	sp.StateProvinceID,
	sp.StateProvinceCode, 
	sp.CountryRegionCode, 
	sp.IsOnlyStateProvinceFlag,
	sp.Name,
	sp.TerritoryID,
	sp.ModifiedDate, 
	at.Name
FROM dbo.StateProvince AS sp
	INNER JOIN Person.Address pa 
	ON pa.StateProvinceID = sp.StateProvinceID	
	INNER JOIN Person.BusinessEntityAddress ea 
	ON ea.AddressID = pa.AddressID
	INNER JOIN Person.AddressType at 
	ON at.AddressTypeID = ea.AddressTypeID;

--Task 1.c--

UPDATE dbo.StateProvince
SET dbo.StateProvince.AddressType = sp.AddressType,
	dbo.StateProvince.Name = CONCAT(reg.Name, ' ', sp.Name)
FROM @StateProvince AS sp
	INNER JOIN Person.CountryRegion AS reg 
	ON reg.CountryRegionCode = sp.CountryRegionCode
WHERE 
	dbo.StateProvince.StateProvinceID = sp.StateProvinceID

SELECT * FROM dbo.StateProvince;
GO

--Task 1.d--

DELETE FROM dbo.StateProvince
FROM dbo.StateProvince sp
INNER JOIN (
	SELECT AddressType, MAX(StateProvinceID) MaxStateProvinceID 
	FROM dbo.StateProvince
	GROUP BY AddressType) maxSpId
	ON (maxSpId.AddressType = sp.AddressType)
WHERE sp.StateProvinceID <> maxSpId.MaxStateProvinceID;

SELECT * FROM dbo.StateProvince;
GO

--Task 1.e--

ALTER TABLE dbo.StateProvince
	DROP COLUMN AddressType

SELECT *FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StateProvince';

SELECT *FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StateProvince';

SELECT *FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StateProvince';

SELECT
	DEFAULT_CONSTRAINTS.NAME
FROM SYS.ALL_COLUMNS
	INNER JOIN SYS.TABLES
	ON ALL_COLUMNS.OBJECT_ID = TABLES.OBJECT_ID
	INNER JOIN  SYS.SCHEMAS
	ON TABLES.SCHEMA_ID = SCHEMAS.SCHEMA_ID
	INNER JOIN  SYS.DEFAULT_CONSTRAINTS
	ON ALL_COLUMNS.DEFAULT_OBJECT_ID = DEFAULT_CONSTRAINTS.OBJECT_ID
WHERE TABLES.NAME = 'StateProvince' AND SCHEMAS.NAME = 'dbo'

ALTER TABLE dbo.StateProvince
	DROP CONSTRAINT PK_StateProvinceID_StateProvinceCode, Check_TerritoryID, Default_TerritoryID

--Task 1.f--

DROP TABLE dbo.StateProvince