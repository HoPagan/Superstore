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
-- Description:	Update an Address using partial parameters
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[UpdateAddress]
	@AddressID INT,
	@AddressLine1 NVARCHAR(25) = NULL,
	@AddressLine2 NVARCHAR(25) = NULL,
	@City NVARCHAR(50) = NULL,
	@StateID INT = NULL,
	@CountryID INT = NULL,
	@PostalCode INT = NULL,
	@RegionID INT = NULL,
	@AddressTypeID INT = NULL,
	@CustomerID  INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		UPDATE dbo.Address
		SET AddressLine1 = COALESCE(@AddressLine1, AddressLine1), 
			AddressLine2 = COALESCE(@AddressLine2, AddressLine2), 
			City = COALESCE(@City, City), 
			StateID = COALESCE(@StateID, StateID), 
			CountryID = COALESCE(@CountryID, CountryID), 
			PostalCode = COALESCE(@PostalCode, PostalCode), 
			RegionID = COALESCE(@RegionID, RegionID), 
			AddressTypeID = COALESCE(@AddressTypeID, AddressTypeID), 
			CustomerID = COALESCE(@CustomerID, CustomerID)
		WHERE AddressID = @AddressID;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
