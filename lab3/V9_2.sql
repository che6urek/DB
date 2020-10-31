--Task 2--

USE AdventureWorks;
GO

--Task 2.a--
ALTER TABLE dbo.StateProvince
ADD 
	TaxRate			SMALLMONEY, 
	CurrencyCode	NCHAR(3), 
	AverageRate		MONEY, 
	IntTaxRate		AS CEILING(TaxRate)
GO

--Task 2.b--

CREATE TABLE #StateProvince (
	StateProvinceID         INT NOT NULL PRIMARY KEY,
	StateProvinceCode       NCHAR(3) NOT NULL,
	CountryRegionCode       NVARCHAR(3) NOT NULL,
	IsOnlyStateProvinceFlag SMALLINT NULL,
	Name                    NVARCHAR(50)NOT NULL,
	TerritoryID             INT NOT NULL,
	ModifiedDate            DATETIME NOT NULL,
	TaxRate                 SMALLMONEY NULL,
	CurrencyCode            NCHAR(3) NULL,
	AverageRate             MONEY NULL);	

--Task 2.c--

INSERT INTO #StateProvince
SELECT 
	sp.StateProvinceID, 
	sp.StateProvinceCode, 
	sp.CountryRegionCode, 
	sp.IsOnlyStateProvinceFlag, 
	sp.Name, 
	sp.TerritoryID, 
	sp.ModifiedDate, 
	COALESCE(str.TaxRate, 0), 
	crc.CurrencyCode, 
	NULL
FROM dbo.StateProvince sp
LEFT OUTER JOIN Sales.SalesTaxRate str
ON ((str.StateProvinceID = sp.StateProvinceID) AND (str.TaxType = 1))
INNER JOIN Sales.CountryRegionCurrency crc
ON (crc.CountryRegionCode = sp.CountryRegionCode);

WITH CTE AS (
	SELECT sp.CurrencyCode, MAX(cr.AverageRate) AverageRate
	FROM #StateProvince sp
	INNER JOIN Sales.CurrencyRate cr
	ON ((cr.ToCurrencyCode COLLATE SQL_Latin1_General_CP1_CI_AS) = sp.CurrencyCode)
	GROUP BY sp.CurrencyCode
)
UPDATE #StateProvince
SET AverageRate = CTE.AverageRate
FROM CTE
WHERE #StateProvince.CurrencyCode = CTE.CurrencyCode;

SELECT * FROM #StateProvince;
GO

--Task 2.d--

DELETE 
FROM dbo.StateProvince
WHERE CountryRegionCode = 'CA';

SELECT * FROM dbo.StateProvince;
GO

--Task 2.e--

MERGE dbo.StateProvince target
USING #StateProvince source
	ON (source.StateProvinceID = target.StateProvinceID)
WHEN MATCHED THEN 
	UPDATE
		SET 
			target.TaxRate = source.TaxRate, 
			target.CurrencyCode = source.CurrencyCode, 
			target.AverageRate = source.AverageRate
WHEN NOT MATCHED BY TARGET THEN
	INSERT (  
		StateProvinceID, 
		StateProvinceCode, 
		CountryRegionCode, 
		IsOnlyStateProvinceFlag, 
		Name, 
		TerritoryID, 
		ModifiedDate, 
		TaxRate, 
		CurrencyCode, 
		AverageRate)
	VALUES (
		source.StateProvinceID, 
		source.StateProvinceCode, 
		source.CountryRegionCode, 
		source.IsOnlyStateProvinceFlag, 
		source.Name, 
		source.TerritoryID, 
		source.ModifiedDate, 
		source.TaxRate, 
		source.CurrencyCode, 
		source.AverageRate)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;

SELECT * FROM dbo.StateProvince;
GO