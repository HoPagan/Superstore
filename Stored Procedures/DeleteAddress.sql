USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/23/2026
-- Update date: 5/31/2026
-- Description:	Safely delete or deactivate a single specific address
-- EXEC DeleteAddress @AddressID = 1
-- EXEC DeleteAddress @AddressID = 1, @Delete = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[DeleteAddress]
	@AddressID INT,
	@Delete BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		IF @Delete = 1
			BEGIN
				DELETE FROM dbo.Address
				WHERE AddressID = @AddressID;
			END
		ELSE 
			BEGIN
            	UPDATE dbo.Address
				SET IsActive = 0
				WHERE AddressID = @AddressID;
			END
	END TRY
	BEGIN CATCH
        THROW;
	END CATCH;
END;
GO
