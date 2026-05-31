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
-- Description:	Get all Sub-Categories (optionally filtered by Category)
-- EXEC GetAllSubCategories
-- EXEC GetAllSubCategories @CategoryID = 1
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetAllSubCategories]
	@CategoryID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		SELECT SubCategoryID, SubCategory, CategoryID
		FROM dbo.SubCategory
		WHERE @CategoryID IS NULL OR CategoryID = @CategoryID
		ORDER BY SubCategory ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO
