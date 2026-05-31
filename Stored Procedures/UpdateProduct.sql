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
-- Description:	Update a Product using partial parameters
-- EXEC UpdateProduct @ProductID = 1, @ProductName = 'Updated Product'
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[UpdateProduct]
	@ProductID INT,
	@ProductName NVARCHAR(150) = NULL,
	@CategoryID INT = NULL,
	@SubCategoryID INT = NULL,
	@UnitPrice DECIMAL(18,2) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		UPDATE dbo.Product
		SET ProductName = COALESCE(@ProductName, ProductName),
			CategoryID = COALESCE(@CategoryID, CategoryID),
			SubCategoryID = COALESCE(@SubCategoryID, SubCategoryID),
			UnitPrice = COALESCE(@UnitPrice, UnitPrice)
		WHERE ProductID = @ProductID;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
