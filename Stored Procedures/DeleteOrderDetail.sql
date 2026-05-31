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
-- Description:	Delete line items for a specific order
-- EXEC DeleteOrderDetail @OrderID = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteOrderDetail]
	@OrderID INT
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		DELETE FROM dbo.OrderDetails
		WHERE OrderID = @OrderID;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
