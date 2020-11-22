--Task 1--

USE AdventureWorks;
GO

CREATE PROCEDURE Sales.MaxDiscountByCategory (@categories NVARCHAR(MAX)) AS
BEGIN
	DECLARE @query NVARCHAR(512) = 
	   'SELECT * FROM (
			SELECT p.Name, so.Category, so.DiscountPct
			FROM Sales.SpecialOffer so
			INNER JOIN Sales.SpecialOfferProduct sop
				ON (sop.SpecialOfferID = so.SpecialOfferID)
			INNER JOIN Production.Product p
				ON (p.ProductID = sop.ProductID)) p
		PIVOT (MAX(DiscountPct) FOR Category IN (' + @categories + ')) [pivot];';
	EXECUTE sp_executesql @query;
END
GO

EXEC Sales.MaxDiscountByCategory @categories = '[Reseller], [No Discount], [Customer]';
GO