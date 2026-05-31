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
-- Description:	Get all active Products with category descriptions
-- EXEC GetProducts
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetProducts]
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		SELECT 
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
		WHERE p.IsActive = 1;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
