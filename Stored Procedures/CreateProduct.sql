USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[CreateProduct]    Script Date: 5/5/2026 1:40:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/28/2026
-- Update date: 5/5/2026
-- Description:	Create a Product
-- EXEC CreateProduct @ProductName = 'New Product', @CategoryID = 1, @SubCategoryID = 1, @UnitPrice = 0.00, @Quantity = 10
-- =============================================
ALTER PROCEDURE [dbo].[CreateProduct]
	@ProductName NVARCHAR(150),
	@CategoryID INT,
	@SubCategoryID INT,
    @UnitPrice DECIMAL(18,2), 
	@Quantity INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
   		INSERT INTO dbo.Product(ProductName, CategoryID, SubCategoryID, UnitPrice, Quantity)
		VALUES(@ProductName, @CategoryID, @SubCategoryID, @UnitPrice, @Quantity);
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
