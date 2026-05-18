USE [Superstore]
GO
/****** Object:  StoredProcedure [dbo].[GetAllSubCategories]    Script Date: 5/14/2026 2:27:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harold Pagan	
-- Create date: 5/8/2026
-- Update date: 
-- Description:	Get all Sub-Categories
-- EXEC GetAllSubCategories
-- =============================================
CREATE PROCEDURE [dbo].[GetAllSubCategories]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		SELECT SubCategoryID, SubCategory
		FROM dbo.SubCategory;
	END TRY
	BEGIN CATCH
   		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END
