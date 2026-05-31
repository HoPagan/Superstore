USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/16/2026
-- Update date: 5/31/2026
-- Description:	Delete or deactivate customers (Single or Batch TVP)
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteCustomer]
	@CustomerID INT = NULL,
	@CustomerIDList dbo.IDList READONLY,
	@Delete BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
	BEGIN TRY
		IF @Delete = 1
			BEGIN
				-- 1. Cascade delete dependent child OrderDetails records first
				DELETE od 
				FROM dbo.OrderDetails od
				JOIN dbo.[Order] o ON od.OrderID = o.OrderID
				WHERE o.CustomerID = @CustomerID
				   OR o.CustomerID IN (SELECT ID FROM @CustomerIDList);

				-- 2. Cascade delete parent Order records
				DELETE FROM dbo.[Order]
				WHERE CustomerID = @CustomerID
				   OR CustomerID IN (SELECT ID FROM @CustomerIDList);

				-- 3. Clear customer address link records
				DELETE FROM dbo.Address
				WHERE CustomerID = @CustomerID
				   OR CustomerID IN (SELECT ID FROM @CustomerIDList);

				-- 4. Purge target customer master records
				DELETE FROM dbo.Customer
				WHERE CustomerID = @CustomerID
				   OR CustomerID IN (SELECT ID FROM @CustomerIDList);
			END
		ELSE 
			BEGIN
				-- Soft delete/deactivate records matching single ID or batch list
   				UPDATE dbo.Customer
				SET IsActive = 0
				WHERE CustomerID = @CustomerID
				   OR CustomerID IN (SELECT ID FROM @CustomerIDList);
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
