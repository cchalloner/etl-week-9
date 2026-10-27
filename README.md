# Week 9: ETL Pipeline Setup, Part 1

Setup scripts for the Chinook Sales Data Warehouse. The steps for using them are in the Week 9 assignment instructions.

## Files

| File | What it creates |
|---|---|
| `ChinookDWSetup.sql` | `DimTrack`, `DimCustomer`, and `FactInvoiceLines` |
| `ChinookStagingSetup.sql` | `stgDimCustomer`, `stgDimTrack`, and `stgFactInvoiceLines` |

Run each script once in `ChinookSalesDW` and once in `ChinookSalesDW_QA`.

## Warnings

- Each script drops and recreates its tables. Any data in those tables is deleted.
- Each script checks which database is selected. If it is not `ChinookSalesDW` or `ChinookSalesDW_QA`, the script prints a message and creates nothing.
- The scripts never touch the `Chinook` source database.

## Not included

- `DimDate` is not created by these scripts.
- The scripts create empty tables only. The finished ETL pipeline is built in Week 11.

## Table notes

- `DimTrack` is a wide dimension holding track, album, artist, and genre names. `TrackCode` is the natural key from `Chinook.Track.TrackId`.
- `DimCustomer` uses `CustomerCode` as the natural key from `Chinook.Customer.CustomerId`.
- `FactInvoiceLines` has a composite primary key of `DateKey`, `CustomerKey`, and `TrackKey`. `UnitPrice` comes from `Chinook.InvoiceLine`.
- In `stgDimCustomer`, the state column is `State_Name`. In `DimCustomer`, it is `State`.
