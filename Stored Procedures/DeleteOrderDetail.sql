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
-- Description:	Delete the history of the product purchased
-- EXEC DeleteOrderDetail @OrderID = 1
-- =============================================
CREATE PROCEDURE [dbo].[DeleteOrderDetail]
	@OrderID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		BEGIN
			DELETE FROM dbo.OrderDetail
			WHERE OrderID = @OrderID;
		END
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
