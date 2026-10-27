-- NOTE: Run this against both ChinookSalesDW and ChinookSalesDW_QA.
-- Select the database in the SSMS database dropdown before you run the script.
-- WARNING: This script drops and recreates the staging tables.
-- Any data in those tables is deleted.

IF DB_NAME() NOT IN ('ChinookSalesDW', 'ChinookSalesDW_QA')
BEGIN
    PRINT 'Select ChinookSalesDW or ChinookSalesDW_QA in the database dropdown, then run the script again.';
    SET NOEXEC ON;
END

-- 1. Staging Table for Customer Dimension (loads DimCustomer)
IF OBJECT_ID('dbo.stgDimCustomer') IS NOT NULL DROP TABLE dbo.stgDimCustomer;
CREATE TABLE dbo.stgDimCustomer (
    -- NATURAL KEY (from Chinook.Customer)
    CustomerId INT NOT NULL,

    -- Descriptive Attributes
    FirstName NVARCHAR(40) NULL,
    LastName NVARCHAR(40) NULL,
    City NVARCHAR(40) NULL,
    State_Name NVARCHAR(40) NULL,
    Country NVARCHAR(40) NULL,
    PostalCode NVARCHAR(10) NULL
);

-- 2. Staging Table for Wide Track Dimension (loads DimTrack)
IF OBJECT_ID('dbo.stgDimTrack') IS NOT NULL DROP TABLE dbo.stgDimTrack;
CREATE TABLE dbo.stgDimTrack (
    -- NATURAL KEY (from Chinook OLTP)
    TrackId INT NOT NULL,

    -- ATTRIBUTES (Denormalized descriptive data)
    TrackName NVARCHAR(200) NULL,
    AlbumTitle NVARCHAR(160) NULL,
    ArtistName NVARCHAR(120) NULL,
    GenreName NVARCHAR(120) NULL
);

-- 3. Staging Table for Fact Invoice Lines (Uses Natural Keys from OLTP source)
IF OBJECT_ID('dbo.stgFactInvoiceLines') IS NOT NULL DROP TABLE dbo.stgFactInvoiceLines;
CREATE TABLE dbo.stgFactInvoiceLines (
    -- Natural Keys (from Chinook OLTP)
    InvoiceID INT NOT NULL,
    InvoiceLineID INT NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    CustomerID INT NOT NULL,
    TrackID INT NOT NULL,

    -- Measures (UnitPrice comes from Chinook.InvoiceLine)
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL
);

SET NOEXEC OFF;
