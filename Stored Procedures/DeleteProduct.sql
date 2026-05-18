USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[DeleteProduct]    Script Date: 5/5/2026 1:36:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/28/2026
-- Update date: 5/5/2026
-- Description:	Either going to Delete or Deactivate a product
-- EXEC DeleteProduct @ProductID = 1
-- EXEC DeleteProduct @ProductID = 1, @Delete = 1
-- =============================================
ALTER PROCEDURE [dbo].[DeleteProduct]
	@ProductID INT,
	@Delete BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @Delete = 1
			BEGIN
				DELETE FROM dbo.Product
				WHERE ProductID = @ProductID;
			END
		ELSE 
			BEGIN
   				UPDATE dbo.Product
				SET IsActive = 0, Quantity = 0
				WHERE ProductID = @ProductID;
			END
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
