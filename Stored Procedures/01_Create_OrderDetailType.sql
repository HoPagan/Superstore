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
-- Description:	Create the User-Defined Table Type for batch order line item insertions
-- =============================================

-- Create the User-Defined Table Type for batch operations if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.types WHERE name = 'OrderDetailType' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TYPE dbo.OrderDetailType AS TABLE (
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        Discount DECIMAL(4, 2) NOT NULL,
        Profit DECIMAL(18, 2) NOT NULL
    );
END;
GO
