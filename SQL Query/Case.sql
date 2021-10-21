USE Bejibun
--CASE

--Nomor 1
SELECT ItemName, ItemPrice, SUM(b.quantity) AS 'Item Total'
FROM MsItem a
	JOIN TrPurchaseDetail b
		ON a.ItemID = b.ItemID
	JOIN TrPurchase c
		ON c.PurchaseID = b.PurchaseID
WHERE c.ArrivalDate IS NULL
GROUP BY ItemName, ItemPrice
Having SUM(quantity) > 100
ORDER BY SUM(quantity) DESC

-- Nomor 2
SELECT VendorName,
[Domain Name] = SUBSTRING(VendorEmail, CHARINDEX('@',VendorEmail,1)+1, LEN(VendorEmail)),
[Average Purchased Item] = AVG(c.Quantity)
FROM MsVendor a
	JOIN TrPurchase b
		ON a.VendorID = b.VendorID
	JOIN TrPurchaseDetail c
		ON c.PurchaseID = b.PurchaseID
WHERE a.VendorAddress LIKE '%Food Street%' 
AND RIGHT(RTRIM(LTRIM(a.VendorEmail)), 9) <> 'gmail.com'
GROUP BY VendorName, SUBSTRING(VendorEmail, CHARINDEX('@',VendorEmail,1)+1, LEN(VendorEmail))

--Nomor 3
SELECT [Month] = DATENAME(month, a.SalesDate),
[Minimum Quantity Sold] = MIN(b.Quantity), 
[Maximum Quantity Sold] = MAX(b.Quantity)
FROM TrSales a
	JOIN TrSalesDetail b
		ON b.SalesID = a.SalesID
	JOIN MsItem c
		ON c.ItemID = b.ItemID
	JOIN MsItemType d
		ON d.TypeID = c.TypeID
WHERE YEAR(a.SalesDate) = 2019 
AND d.TypeName <> 'Food'
AND d.TypeName <> 'Drinks'
GROUP BY DATENAME(month, a.SalesDate), a.SalesID

--Nomor 4
SELECT [Staff Number] = STUFF(a.StaffID, 1, 2, 'Staff '), 
StaffName, 
[Salary] = 'Rp. '+ CAST(StaffSalary AS VARCHAR), 
[Sales Count] = COUNT(b.SalesID), 
[Average Sales Quantity] = AVG(c.Quantity)
FROM MsStaff a
	JOIN TrSales b
		ON a.StaffID = b.StaffID
	JOIN (
		SELECT SalesID, [Quantity] = SUM(Quantity)
		FROM TrSalesDetail
		GROUP BY SalesID
		) c
		ON c.SalesID = b.SalesID
	JOIN MsCustomer d
		ON d.CustomerID = b.CustomerID
WHERE a.StaffGender <> d.CustomerGender
AND MONTH(b.SalesDate) = 2
GROUP BY STUFF(a.StaffID, 1, 2, 'Staff '), StaffName, StaffSalary


-- Nomor 5
SELECT [Customer Initial] = LEFT(CustomerName, 1) + RIGHT(CustomerName, 1),
[Transaction Date] = CONVERT(varchar, b.SalesDate, 107),
[Quantity] = SUM(c.Quantity) 
FROM MsCustomer a
	JOIN TrSales b
		ON a.CustomerID = b.CustomerID
	JOIN TrSalesDetail c
		ON b.SalesID = c.SalesID
AND a.CustomerGender = 'Female'
GROUP BY CustomerName, CONVERT(varchar, b.SalesDate, 107)
HAVING SUM(c.Quantity) > 
		(SELECT AVG(b.Quantity) 
		FROM TrSales a
			JOIN (
				SELECT SalesID, [Quantity] = SUM(Quantity)
				FROM TrSalesDetail
				GROUP BY SalesID
			) b
			ON a.SalesID = b.SalesID)


-- NOMOR 6
SELECT b.PurchaseID, c.Quantity, [DisplayID] = LOWER(a.VendorID),
VendorName, 
[Phone Number] = '+62' + SUBSTRING(VendorPhone, 2, LEN(VendorPhone))
FROM MsVendor a
	JOIN TrPurchase b
		ON a.VendorID = b.VendorID
	JOIN (SELECT PurchaseID, Quantity = SUM(Quantity)
		FROM TrPurchaseDetail
		WHERE CAST(RIGHT(ItemID, 3) AS int) % 2 != 0
		GROUP BY PurchaseID
		) c
		ON c.PurchaseID = b.PurchaseID
WHERE c.Quantity > (SELECT TOP 1 Quantity = SUM(Quantity) 
					FROM TrPurchaseDetail 
					GROUP BY PurchaseID
					ORDER BY SUM(Quantity) ASC)

--NOMOR 7
SELECT StaffName, VendorName, b.PurchaseID,
[Total Purchased Quantity] = SUM(d.Quantity),
[Ordered Day] = CAST(ABS(DATEDIFF(DAY, b.PurchaseDate, GETDATE())) AS varchar) + ' Days Ago'
FROM MsStaff a
	JOIN TrPurchase b
		ON b.StaffID = a.StaffID
	JOIN MsVendor c
		ON b.VendorID = c.VendorID
	JOIN TrPurchaseDetail d
		ON b.PurchaseID = d.PurchaseID
GROUP BY StaffName, VendorName, b.PurchaseID, b.PurchaseDate
HAVING SUM(d.Quantity) > 
		(SELECT TOP 1 [MaxQuantityOfTransactions] = SUM(Quantity)
		FROM TrPurchase a
			JOIN TrPurchaseDetail b
				ON a.PurchaseID = b.PurchaseID
		WHERE (ABS(DATEDIFF(DAY, a.PurchaseDate, a.ArrivalDate))) < 7
		GROUP BY a.PurchaseID
		ORDER BY [MaxQuantityOfTransactions] DESC)


--NOMOR 8
SELECT TOP 2 [Day] = DATENAME(weekday, SalesDate),
[Item Sales Amount] = COUNT(b.ItemID)
FROM TrSales a
	JOIN TrSalesDetail b
		ON a.SalesID = b.SalesID
	JOIN MsItem c
		ON b.ItemID = c.ItemID
WHERE b.ItemID IN (
	SELECT ItemID 
	FROM MsItem 
	WHERE ItemPrice <
		(SELECT [AVG] = AVG(ItemPrice)
		FROM MsItem a
			JOIN MsItemType b
				ON a.TypeID = b.TypeID
		WHERE b.TypeName = 'Electronic' OR b.TypeName = 'Gadgets'))
GROUP BY a.SalesID, a.SalesDate
ORDER BY [Item Sales Amount] ASC

--NOMOR 9
CREATE VIEW [Customer Statistic by Gender] 
AS
	SELECT c.CustomerGender,
	[Maximum Sales] = MAX(b.Quantity),
	[Minimum Sales] = MIN(b.Quantity)
	FROM TrSales a
		JOIN TrSalesDetail b
			ON a.SalesID = b.SalesID
		JOIN MsCustomer c
			ON c.CustomerID = a.CustomerID
	WHERE b.Quantity BETWEEN 10 AND 50
	AND YEAR(CustomerDateOfBirth) BETWEEN 1998 AND 1999
	GROUP BY CustomerGender

SELECT * FROM [Customer Statistic by Gender]

-- NOMOR 10
CREATE VIEW [Item Type Statistic] 
AS
	SELECT [Item Type] = UPPER(TypeName),
	[Average Price] = AVG(b.ItemPrice),
	[Number of Variety Item] = COUNT(b.ItemID)
	FROM MsItemType a
		JOIN MsItem b
			ON a.TypeID = b.TypeID
	WHERE LEFT(TRIM(a.TypeName), 1) = 'F' 
	AND b.MinimumPurchase > 5
	GROUP BY a.TypeName

SELECT * FROM [Item Type Statistic]