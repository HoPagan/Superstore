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
-- Description:	Verification script to test single-batch transaction insertions
-- EXEC Test_InsertOrderWithDetails
-- =============================================

-- 1. Declare the table variable using your custom type
DECLARE @SampleItems dbo.OrderDetailType;

-- 2. Bulk populate the variable (Simulating batch data)
INSERT INTO @SampleItems (ProductID, Quantity, Discount, Profit)
VALUES 
(1001, 3, 0.00, 15.50),
(1002, 1, 0.10, 4.25),
(1003, 5, 0.00, 45.00);

-- 3. Execute the single-batch combination procedure
EXEC dbo.usp_InsertOrderWithDetails 
    @CustomerID = 45, 
    @OrderDate = '2026-05-25', 
    @ShipModeID = 2, 
    @OrderItems = @SampleItems;
GO
