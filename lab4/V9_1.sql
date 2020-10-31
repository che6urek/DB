--Task 1--

USE AdventureWorks;
GO

--Task 1.a--

CREATE TABLE Sales.SpecialOfferHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action CHAR(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	SourceID INT NOT NULL,
	UserName VARCHAR(50) NOT NULL
);
GO

--Task 1.b--

CREATE TRIGGER Sales.SpecialOffer_Insert
ON Sales.SpecialOffer
AFTER INSERT AS
	INSERT INTO Sales.SpecialOfferHst(Action, ModifiedDate, SourceID, UserName)
	SELECT 'INSERT', GETDATE(), ins.SpecialOfferID, USER_NAME()
	FROM inserted AS ins;
GO

CREATE TRIGGER Sales.SpecialOffer_Update
ON Sales.SpecialOffer
AFTER UPDATE AS
	INSERT INTO Sales.SpecialOfferHst(Action, ModifiedDate, SourceID, UserName)
	SELECT 'UPDATE', GETDATE(), ins.SpecialOfferID, USER_NAME()
	FROM inserted AS ins;
GO

CREATE TRIGGER Sales.SpecialOffer_Delete
ON Sales.SpecialOffer
AFTER DELETE AS
	INSERT INTO Sales.SpecialOfferHst(Action, ModifiedDate, SourceID, UserName)
	SELECT 'DELETE', GETDATE(), del.SpecialOfferID, USER_NAME()
	FROM deleted AS del;
GO

--Task 1.c--

CREATE VIEW Sales.vSpecialOffer
WITH ENCRYPTION AS SELECT * FROM Sales.SpecialOffer;
GO

--Task 1.d--

INSERT INTO Sales.vSpecialOffer (
	Description,
	DiscountPct,
	Type,
	Category,
	StartDate,
	EndDate,
	MinQty,
	MaxQty,
	rowguid)
VALUES ('Lol Kek Cheburek', 0.20, 'Discount', 'Customer', GETDATE(), GETDATE(), 10, 100, NEWID());

UPDATE Sales.vSpecialOffer SET Description = 'Discount' WHERE Description = 'Lol Kek Cheburek';

DELETE Sales.vSpecialOffer WHERE Description = 'Discount';

SELECT * FROM Sales.SpecialOfferHst;