CREATE DATABASE Bejibun
USE Bejibun

Create Table MsCustomer(
CustomerID Varchar(255) Primary Key NOT NULL,
CustomerName Varchar(255),
CustomerGender Varchar(255),
CustomerPhone Varchar(255),
CustomerDateOfBirth Date,

CONSTRAINT CHK_custID CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
CONSTRAINT CHK_custGender CHECK (CustomerGender LIKE 'Female' OR CustomerGender LIKE 'Male'),
CONSTRAINT CHK_custDOB CHECK (CustomerDateOfBirth BETWEEN 'January 1, 1990' AND GETDATE())
)

CREATE Table MsStaff(
StaffID Varchar(255) Primary Key NOT NULL,
StaffName Varchar(255),
StaffGender Varchar(255),
StaffPhone Varchar(255),
StaffSalary Integer,

CONSTRAINT CHK_staffID CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
CONSTRAINT CHK_staffGender CHECK (StaffGender LIKE 'Female' OR StaffGender LIKE 'Male'),
CONSTRAINT CHK_staffSalary CHECK (StaffSalary>0)
)


CREATE Table MsItemType(
TypeID Varchar(255) Primary Key NOT NULL,
TypeName Varchar(255) NOT NULL,

CONSTRAINT CHK_itemTypeID CHECK(TYPEID LIKE 'IP[0-9][0-9][0-9]'),
CONSTRAINT CHK_typeName CHECK(LEN(TypeName) >= 4)
)


CREATE Table MsItem(
ItemID Varchar(255) Primary Key Not NULL,
TypeID Varchar(255) Foreign Key References MsItemType(TypeID) NOT NULL,
ItemName Varchar(255) NOT NULL,
ItemPrice Integer,
MinimumPurchase Integer,

CONSTRAINT CHK_itemID CHECK (ItemID LIKE 'IT[0-9][0-9][0-9]'),
CONSTRAINT CHK_itemPrice CHECK (ItemPrice > 0)
)

Create Table TrSales(
SalesID Varchar(255) Primary Key NOT NULL,
StaffID Varchar(255) Foreign Key References MsStaff(StaffID) NOT NULL,
CustomerID Varchar(255) Foreign Key References MsCustomer(CustomerID) NOT NULL,
SalesDate DATE,

CONSTRAINT CHK_salesID CHECK(SalesID LIKE'SA[0-9][0-9][0-9]')
)

Create Table TrSalesDetail(
SalesID Varchar(255) Foreign Key References TrSales(SalesID) NOT NULL,
ItemID Varchar(255) Foreign Key References MsItem(ItemID) NOT NULL,
Quantity Integer,
Primary Key(SalesID,ItemID)
)

Create Table MsVendor(
VendorID Varchar(255) Primary Key NOT NULL,
VendorName Varchar(255) NOT NULL,
VendorPhone Varchar(255),
VendorAddress Varchar(255),
VendorEmail Varchar(255),

CONSTRAINT CHK_vendEmail CHECK(TRIM(VendorEmail) LIKE '%_@_%.com'),
CONSTRAINT CHK_vendAddress CHECK(VendorAddress LIKE '% Street'),
CONSTRAINT CHK_vendID CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]')
)

Create Table TrPurchase(
PurchaseID Varchar(255) Primary Key NOT NULL,
StaffID Varchar(255) Foreign Key References MsStaff(StaffID) NOT NULL,
VendorID Varchar(255) Foreign key References MsVendor(VendorID) NOT NULL,
PurchaseDate Date,
ArrivalDate Date,

CONSTRAINT CHK_purchaseID CHECK(PurchaseID LIKE'PH[0-9][0-9][0-9]')
)

Create Table TrPurchaseDetail(
PurchaseID Varchar(255) Foreign Key References TrPurchase(PurchaseID) NOT NULL,
ItemID Varchar(255) Foreign Key References MsItem(ItemID) NOT NULL,
Quantity Integer
Primary Key(PurchaseID,ItemID)
)

SELECT * FROM MsCustomer
SELECT * FROM MsItem
SELECT * FROM MsItemType
SELECT * FROM MsStaff
SELECT * FROM MsVendor
SELECT * FROM TrSales
SELECT * FROM TrSalesDetail
SELECT * FROM TrPurchase
SELECT * FROM TrPurchaseDetail

