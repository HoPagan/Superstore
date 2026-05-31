USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOrder]    Script Date: 5/21/2026 1:15:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/14/2026
-- Update date: 5/30/2026
-- Description:	Delete an Order
-- EXEC DeleteOrder @OrderID = 1
-- EXEC DeleteOrder @OrderID = 1, @Delete = 1
-- =============================================
CREATE PROCEDURE [dbo].[DeleteOrder]
	@OrderID INT = NULL,
	@OrdersIDs dbo.IDList READONLY,
	@Delete BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		-- Get distinct OrderIDs from the input parameters
		DECLARE @IDs TABLE (OrderID INT PRIMARY KEY);
		INSERT INTO @IDs (OrderID)
		SELECT DISTINCT OrderID
		FROM (
			SELECT @OrderID AS OrderID
			WHERE @OrderID IS NOT NULL

			UNION ALL

			SELECT ID
			FROM @OrdersIDs
				
		) AS Combined

		IF @Delete = 1
			BEGIN
				-- Delete order detail
				DELETE od
				FROM dbo.OrderDetail od
				JOIN @IDs d 
				ON od.OrderID = d.OrderID;

				-- Delete order
				DELETE o
				FROM dbo.[Order] o
				JOIN @IDs d 
				ON o.OrderID = d.OrderID;
			END
		ELSE 
			BEGIN
   				UPDATE o
				SET IsActive = 0, DateUpdated = GETDATE()
				FROM dbo.[Order] o
				JOIN @IDs d
				ON o.OrderID = d.OrderID;
			END
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
