--Task 2--

USE AdventureWorks;
GO

--Task 2.a--

CREATE TABLE dbo.StateProvince (
	  StateProvinceID         INT NOT NULL, 
	  StateProvinceCode       NCHAR(3) NOT NULL, 
	  CountryRegionCode       NVARCHAR(3) NOT NULL, 
	  IsOnlyStateProvinceFlag FLAG NOT NULL, 
	  Name                    NAME NOT NULL, 
	  TerritoryID             INT NOT NULL, 
	  ModifiedDate            DATETIME NOT NULL);	

--Task 2.b--

ALTER TABLE dbo.StateProvince
	ADD CONSTRAINT PK_StateProvinceID_StateProvinceCode
		PRIMARY KEY (StateProvinceID, StateProvinceCode);
GO

--Task 2.c--

CREATE FUNCTION dbo.IsEven(@number INT)  
RETURNS BIT  
AS   
BEGIN  
	DECLARE @digit INT;  
	WHILE (@number > 0)
	BEGIN
		SET @digit = @number % 10;
		IF ((@digit % 2) <> 0)
			RETURN 0;
		SET @number = (@number - @digit) / 10;
	END;
	RETURN 1
END;  
GO  

ALTER TABLE dbo.StateProvince
	ADD CONSTRAINT Check_TerritoryID
		CHECK (dbo.IsEven(TerritoryID) = 1);

--Task 2.d--

ALTER TABLE dbo.StateProvince
	ADD CONSTRAINT Default_TerritoryID
		DEFAULT 2 FOR TerritoryID;

--Task 2.e--

INSERT INTO dbo.StateProvince (
		StateProvinceID, StateProvinceCode, CountryRegionCode, IsOnlyStateProvinceFlag, Name, ModifiedDate)
	SELECT
		p.StateProvinceID, p.StateProvinceCode, p.CountryRegionCode, p.IsOnlyStateProvinceFlag, p.Name, p.ModifiedDate
	FROM (
		SELECT 		
			  sp.StateProvinceID, sp.StateProvinceCode, sp.CountryRegionCode, 
			  sp.IsOnlyStateProvinceFlag, sp.Name, sp.ModifiedDate, a.AddressID, 
			  RANK() OVER(PARTITION BY sp.StateProvinceID, sp.StateProvinceCode ORDER BY a.AddressId DESC) pr
		FROM Person.StateProvince sp
		INNER JOIN Person.Address a ON (a.StateProvinceID = sp.StateProvinceID)
		INNER JOIN Person.BusinessEntityAddress bea ON (a.AddressID = bea.AddressID)
		INNER JOIN Person.AddressType at ON (bea.AddressTypeID = at.AddressTypeID)
		WHERE at.Name = 'Shipping'
	) p
	WHERE pr = 1;

--Task 2.f--

ALTER TABLE dbo.StateProvince
	ALTER COLUMN IsOnlyStateProvinceFlag SMALLINT NULL;
