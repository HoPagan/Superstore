USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/14/2026
-- Update date: 
-- Description:	Delete an Order
-- EXEC DeleteOrder @OrderID = 1
-- EXEC DeleteOrder @OrderID = 1, @Delete = 1
-- =============================================
CREATE PROCEDURE [dbo].[DeleteOrder]
	@OrderID INT,
	@Delete BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		IF @Delete = 1
			BEGIN
				-- Delete all order details
				EXEC DeleteOrderDetail @OrderID = @OrderID

				DELETE FROM dbo.[Order]
				WHERE OrderID = @OrderID;
			END
		ELSE 
			BEGIN
   				UPDATE dbo.[Order]
				SET IsActive = 0, DateUpdated = GETDATE()
				WHERE OrderID = @OrderID;
			END
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
