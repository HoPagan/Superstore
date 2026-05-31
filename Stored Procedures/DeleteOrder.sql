USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/14/2026
-- Update date: 5/31/2026
-- Description:	Delete or deactivate orders (Supports Single or Batch TVP)
-- EXEC DeleteOrder @OrderID = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteOrder]
	@OrderID INT = NULL,
	@OrdersIDs dbo.IDList READONLY,
	@Delete BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	-- Combine parameters into a unified set for clean processing
	DECLARE @IDs TABLE (OrderID INT PRIMARY KEY);
	INSERT INTO @IDs (OrderID)
	SELECT DISTINCT OrderID
	FROM (
		SELECT @OrderID AS OrderID WHERE @OrderID IS NOT NULL
		UNION ALL
		SELECT ID FROM @OrdersIDs
	) AS Combined;

	BEGIN TRANSACTION;
	BEGIN TRY
		IF @Delete = 1
			BEGIN
				-- 1. Cascade clear child line item dependencies first
				DELETE od
				FROM dbo.OrderDetails od  -- Adjust to dbo.OrderDetail if singular in your schema
				JOIN @IDs d ON od.OrderID = d.OrderID;

				-- 2. Clear parent order header records
				DELETE o
				FROM dbo.[Order] o
				JOIN @IDs d ON o.OrderID = d.OrderID;
			END
		ELSE 
			BEGIN
				-- Soft delete/deactivate records matching our parameter array
   				UPDATE o
				SET o.IsActive = 0
				FROM dbo.[Order] o
				JOIN @IDs d ON o.OrderID = d.OrderID;
			END

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;
GO
