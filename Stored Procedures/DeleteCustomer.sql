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
-- Description:	Batch delete multiple customers using an ID list TVP
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteCustomer]
    @CustomerIDs dbo.IDList READONLY -- The new Table-Valued Parameter
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Delete any customers whose IDs are stored inside our temporary list array
        DELETE FROM dbo.Customer
        WHERE CustomerID IN (SELECT Id FROM @CustomerIDs);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANSACTIONCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
