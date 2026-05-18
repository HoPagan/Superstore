USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 5/7/2026 1:35:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/28/2026
-- Update date: 5/7/2026
-- Description:	Get all Products
-- EXEC GetProducts
-- =============================================
CREATE PROCEDURE [dbo].[GetProducts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
   		
		SELECT TOP 100 ProductID,
			ProductName,
			p.CategoryID,
			c.Category,
			p.SubCategoryID,
			sc.SubCategory,
			UnitPrice,
			ProductKey,
			Quantity
		FROM dbo.Product AS p
		JOIN dbo.Category AS c 
		ON p.CategoryID = c.CategoryID
		JOIN dbo.SubCategory AS sc
		ON p.SubCategoryID = sc.SubCategoryID
		WHERE IsActive = 1;
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
