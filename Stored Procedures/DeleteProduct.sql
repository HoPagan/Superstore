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
-- Description:	Safely delete a single specific product from the store catalog
-- EXEC DeleteProduct @ProductID = 1, @Delete = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteProduct]
	@ProductID INT,
	@Delete BIT = 1 -- Default to true to align with table schemas
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DELETE FROM dbo.Product
		WHERE ProductID = @ProductID;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
