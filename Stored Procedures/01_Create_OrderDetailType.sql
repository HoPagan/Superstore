-- Create the User-Defined Table Type for batch operations
CREATE TYPE dbo.OrderDetailType AS TABLE (
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(4, 2) NOT NULL,
    Profit DECIMAL(18, 2) NOT NULL
);
GO
