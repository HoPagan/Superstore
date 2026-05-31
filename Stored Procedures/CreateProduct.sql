USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/28/2026
-- Update date: 5/31/2026
-- Description:	Create a Product and return the new ID
-- EXEC CreateProduct @ProductName = 'New Product', @CategoryID = 1, @SubCategoryID = 1, @UnitPrice = 19.99
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[CreateProduct]
	@ProductName NVARCHAR(150),
	@CategoryID INT,
	@SubCategoryID INT,
	@UnitPrice DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		INSERT INTO dbo.Product (ProductName, CategoryID, SubCategoryID, UnitPrice)
		VALUES (@ProductName, @CategoryID, @SubCategoryID, @UnitPrice);

		-- Return new primary identifier to backend API layer
		SELECT SCOPE_IDENTITY() AS NewProductID;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
