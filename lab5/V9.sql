--Task 1--

USE AdventureWorks;
GO

--Task 1.a--

CREATE FUNCTION Sales.SpecialOfferStartDate (@SpecialOfferID INT)
RETURNS NVARCHAR(64) AS
BEGIN
	DECLARE @StartDate DATETIME
	SELECT @StartDate = so.StartDate FROM Sales.SpecialOffer so
	WHERE SpecialOfferID = @SpecialOfferID;
	RETURN CONCAT(DATENAME(mm, @startDate), ', ', DATENAME(day, @startDate), '. ', DATENAME(dw, @startDate));
END
GO	

SELECT Sales.SpecialOfferStartDate(16);
GO

--Task 1.b--

CREATE FUNCTION Sales.GetSpecialOfferProducts(@SpecialOfferID INT)
RETURNS TABLE AS
RETURN 
	SELECT p.ProductID, p.Name FROM Sales.SpecialOfferProduct sop
	INNER JOIN Production.Product p 
		ON (p.ProductID = sop.ProductID)
	WHERE sop.SpecialOfferID = @SpecialOfferID;
GO

SELECT * FROM Sales.GetSpecialOfferProducts(16);
GO		

--Task 1.c--

SELECT SpecialOfferID, ProductID, Name FROM Sales.SpecialOffer so
CROSS APPLY 
	Sales.GetSpecialOfferProducts(so.SpecialOfferID);
GO

SELECT SpecialOfferID, ProductID, Name FROM Sales.SpecialOffer so
OUTER APPLY 
	Sales.GetSpecialOfferProducts(so.SpecialOfferID);
GO

--Task 1.d--

CREATE FUNCTION Sales.GetSpecialOfferProductsMultiStatement(@SpecialOfferID INT)
RETURNS @products TABLE (ProductID INT, Name NVARCHAR(64)) 
AS
BEGIN
	INSERT INTO @products 
		SELECT p.ProductID, p.Name FROM Sales.SpecialOfferProduct sop
		INNER JOIN Production.Product p
			ON (sop.ProductID = p.ProductID)
		WHERE sop.SpecialOfferID = @SpecialOfferID;
	RETURN;
END
GO

SELECT * FROM Sales.GetSpecialOfferProductsMultiStatement(16);
GO