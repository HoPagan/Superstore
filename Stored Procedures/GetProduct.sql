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
-- Description:	Get a single active Product by ID
-- EXEC GetProduct @ProductID = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetProduct]
	@ProductID INT
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		SELECT TOP 1 
			p.ProductID,
			p.ProductName,
			p.CategoryID,
			c.Category,
			p.SubCategoryID,
			sc.SubCategory,
			p.UnitPrice,
			p.ProductKey
		FROM dbo.Product AS p
		JOIN dbo.Category AS c ON p.CategoryID = c.CategoryID
		JOIN dbo.SubCategory AS sc ON p.SubCategoryID = sc.SubCategoryID
		WHERE p.ProductID = @ProductID 
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
