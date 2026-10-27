-- NOTE: Run this against your ChinookSalesDW and ChinookSalesDW_QA databases.
-- Select the database in the SSMS database dropdown before you run the script.
-- WARNING: This script drops and recreates DimTrack, DimCustomer, and FactInvoiceLines.
-- Any data in those tables is deleted.

IF DB_NAME() NOT IN ('ChinookSalesDW', 'ChinookSalesDW_QA')
BEGIN
    PRINT 'Select ChinookSalesDW or ChinookSalesDW_QA in the database dropdown, then run the script again.';
    SET NOEXEC ON;
END

-- 1. Wide Dimension Table (DimTrack: Includes Album, Artist, Genre details)
IF OBJECT_ID('dbo.DimTrack') IS NOT NULL DROP TABLE dbo.DimTrack;
CREATE TABLE dbo.DimTrack (
    TrackKey INT IDENTITY(1,1) PRIMARY KEY,
    TrackCode INT NOT NULL UNIQUE, -- Natural Key from Chinook.Track.TrackId
    TrackName NVARCHAR(200) NOT NULL,
    AlbumTitle NVARCHAR(160) NOT NULL,
    ArtistName NVARCHAR(120) NOT NULL,
    GenreName NVARCHAR(120) NOT NULL
);

IF OBJECT_ID('dbo.DimCustomer') IS NOT NULL DROP TABLE dbo.DimCustomer;
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerCode INT NOT NULL UNIQUE, -- Natural Key from Chinook.Customer.CustomerId
    FirstName NVARCHAR(40) NOT NULL,
    LastName NVARCHAR(40) NOT NULL,
    City NVARCHAR(40),
    State NVARCHAR(40),
    Country NVARCHAR(40),
    PostalCode NVARCHAR(10)
);

-- 2. Fact Table (FactInvoiceLines: Target for the final load)
IF OBJECT_ID('dbo.FactInvoiceLines') IS NOT NULL DROP TABLE dbo.FactInvoiceLines;
CREATE TABLE dbo.FactInvoiceLines (
    -- Foreign Keys
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    TrackKey INT NOT NULL,

    -- Measures (UnitPrice comes from Chinook.InvoiceLine)
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,

    -- Composite Key
    CONSTRAINT PK_FactInvoiceLines PRIMARY KEY (DateKey, CustomerKey, TrackKey)
);

SET NOEXEC OFF;
