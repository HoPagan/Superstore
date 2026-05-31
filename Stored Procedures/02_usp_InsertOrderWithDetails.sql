USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/20/2026
-- Update date: 5/31/2026
-- Description:	Insert an Order header and its batch line items in a single transaction
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_InsertOrderWithDetails]
    @CustomerID INT,
    @OrderDate DATE,
    @ShipModeID INT,
    @OrderItems dbo.OrderDetailType READONLY  -- TVP for batch line items
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @NewOrderID INT;

        -- 1. Insert parent order record
        INSERT INTO dbo.[Order] (CustomerID, OrderDate, ShipModeID)
        VALUES (@CustomerID, @OrderDate, @ShipModeID);

        -- Capture the generated ID to link child rows
        SET @NewOrderID = SCOPE_IDENTITY();

        -- 2. Batch Operation: Insert all rows from the TVP into OrderDetails
        INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, Discount, Profit)
        SELECT @NewOrderID, ProductID, Quantity, Discount, Profit
        FROM @OrderItems;

        COMMIT TRANSACTION;
        
        -- Return verification status to support REST API location context
        SELECT @NewOrderID AS GeneratedOrderID, 'Success' AS Status;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
