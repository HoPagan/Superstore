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
-- Description:	Batch delete multiple orders and their cascade items using an ID list TVP
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteOrder]
    @OrderIDs dbo.IDList READONLY -- The new Table-Valued Parameter
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Clear linked child rows from OrderDetail first to prevent foreign key errors
        DELETE FROM dbo.OrderDetail
        WHERE OrderID IN (SELECT Id FROM @OrderIDs);

        -- 2. Delete parent records from the main Order table
        DELETE FROM dbo.[Order]
        WHERE OrderID IN (SELECT Id FROM @OrderIDs);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANSACTIONCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
