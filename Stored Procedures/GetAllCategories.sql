USE [Superstore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/8/2026
-- Update date: 5/31/2026
-- Description:	Get all Category tiers sorted alphabetically
-- EXEC GetAllCategories
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetAllCategories]
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		SELECT CategoryID, Category
		FROM dbo.Category
		ORDER BY Category ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
