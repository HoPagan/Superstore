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
-- Description:	Safely delete or deactivate a single specific product
-- EXEC DeleteProduct @ProductID = 1
-- EXEC DeleteProduct @ProductID = 1, @Delete = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteProduct]
	@ProductID INT,
	@Delete BIT = 0
AS
BEGIN
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
				SET IsActive = 0
				WHERE ProductID = @ProductID;
			END
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
