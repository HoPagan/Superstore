CREATE PROCEDURE dbo.usp_InsertOrderWithDetails
    -- Single parameters for the Order entity
    @CustomerID INT,
    @OrderDate DATE,
    @ShipModeID INT,
    -- Table-Valued Parameter for the batch items (Must be READONLY)
    @OrderItems dbo.OrderDetailType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Single Operation: Insert into the parent Orders table
        DECLARE @NewOrderID INT;

        INSERT INTO dbo.Orders (CustomerID, OrderDate, ShipModeID)
        VALUES (@CustomerID, @OrderDate, @ShipModeID);

        -- Capture the generated ID to link the child rows
        SET @NewOrderID = SCOPE_IDENTITY();

        -- 2. Batch Operation: Insert all rows from the TVP into OrderDetails
        INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, Discount, Profit)
        SELECT @NewOrderID, ProductID, Quantity, Discount, Profit
        FROM @OrderItems;

        COMMIT TRANSACTION;
        
        -- Return verification status
        SELECT @NewOrderID AS GeneratedOrderID, 'Success' AS Status;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Return error context
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
