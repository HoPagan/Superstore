USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAddress]    Script Date: 5/12/2026 1:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 4/23/2026
-- Update date: 5/12/2026
-- Description:	Update an Address
-- EXEC UpdateAddress @AddressID = 1
-- EXEC UpdateAddress @AddressID = 1, @AddressLine1 = '123 Main St', @AddressLine2 = 'Apt 4', @City = 'Anytown', @StateID = 1, CountryID = 1, @PostalCode = 12345, @RegionID = 1, @AddressTypeID = 1, @CustomerID = 1, @CustomerID = 1
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAddress]
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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
			CustomerID = COALESCE(@CustomerID, CustomerID),
			DateUpdated = GETDATE()
		WHERE AddressID = @AddressID;
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
