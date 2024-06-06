 Use AdventureWorks2019;
 select * from sales.SalesOrderDetail
--1. Top 10 Best-Selling Products
SELECT TOP 10
    P.Name AS ProductName, 
    SUM(SD.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalQuantitySold DESC;

--2.Total Sales by Year
SELECT 
    YEAR(OrderDate) AS Year, 
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY Year;

--3. Sales by Territory
SELECT 
    ST.Name AS Territory, 
    SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
ORDER BY TotalSales DESC;

--4. Top 5 Customers by Sales Amount
SELECT TOP 5 
    C.CustomerID, 
    P.FirstName + ' ' + P.LastName AS CustomerName, 
    SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.Customer C ON SOH.CustomerID = C.CustomerID
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID
GROUP BY C.CustomerID, P.FirstName, P.LastName
ORDER BY TotalSales DESC;

--5. Average Order Value
SELECT 
    AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader;

--6. Product Categories with Most Sales

SELECT 
    PC.Name AS Category, 
    SUM(SD.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name
ORDER BY TotalQuantitySold DESC;

--7. Sales by Month for the Current Year

SELECT MONTH(OrderDate) AS Month, 
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = YEAR(GETDATE())
GROUP BY MONTH(OrderDate)
ORDER BY Month;

--8. Inventory Levels by Product

SELECT 
    P.Name AS ProductName, 
    SUM(PI.Quantity) AS TotalQuantity
FROM Production.ProductInventory PI
JOIN Production.Product P ON PI.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalQuantity DESC;

--9. Sales Performance by Salesperson

SELECT 
    S.BusinessEntityID, 
    P.FirstName + ' ' + P.LastName AS SalespersonName, 
    SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesPerson S ON SOH.SalesPersonID = S.BusinessEntityID
JOIN Person.Person P ON S.BusinessEntityID = P.BusinessEntityID
GROUP BY S.BusinessEntityID, P.FirstName, P.LastName
ORDER BY TotalSales DESC;

--10. Customer Demographics
SELECT 
st.CountryRegionCode,
    st.TerritoryID, 
    COUNT(sc.CustomerID) AS NumberOfCustomers
FROM Sales.Customer sc
JOIN sales.SalesTerritory st
ON sc.TerritoryID=ST.TerritoryID
GROUP BY st.CountryRegionCode,st.TerritoryID
ORDER BY NumberOfCustomers DESC;

--11. Top 5 Products with Highest Profit Margins

SELECT
    P.Name AS ProductName, 
    (P.ListPrice - P.StandardCost) AS ProfitMargin
FROM Production.Product P
ORDER BY ProfitMargin DESC;

-- 12. Sales Growth Rate Year Over Year
SELECT 
    YEAR(OrderDate) AS Year, 
    SUM(TotalDue) AS TotalSales,
    LAG(SUM(TotalDue)) OVER (ORDER BY YEAR(OrderDate)) AS PreviousYearSales,
    (SUM(TotalDue) - LAG(SUM(TotalDue)) OVER (ORDER BY YEAR(OrderDate))) / LAG(SUM(TotalDue)) OVER (ORDER BY YEAR(OrderDate)) * 100 AS GrowthRate
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY Year;

--13. Products with Low Inventory Levels
SELECT 
    P.Name AS ProductName, 
    PI.Quantity AS InventoryQuantity
FROM Production.ProductInventory PI
JOIN Production.Product P ON PI.ProductID = P.ProductID
WHERE PI.Quantity < 10
ORDER BY PI.Quantity ASC;

--15. Return Rates by Product
SELECT 
    P.Name AS ProductName, 
    COUNT(RD.SalesOrderID) AS ReturnCount
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
LEFT JOIN Sales.SalesOrderHeader SOH ON SD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Sales.SalesOrderDetail RD ON SOH.SalesOrderID = RD.SalesOrderID AND RD.OrderQty < 0
GROUP BY P.Name
ORDER BY ReturnCount DESC;

--16. Top 5 Sales Territories by Total Sale
SELECT 
    ST.Name AS Territory,
    SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
ORDER BY TotalSales DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--16.Top 10 Products by Total Sales Quantity
SELECT TOP 10 
    P.Name AS ProductName,
    SUM(SD.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalQuantitySold DESC;

--17.Product Categories with Highest Sales Amount
SELECT 
    PC.Name AS Category,
    SUM(SD.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name
ORDER BY TotalSales DESC;

--18. Average Salary by Department
SELECT
    D.Name AS Department,
    AVG(EP.Rate) AS AverageSalary
FROM HumanResources.EmployeePayHistory EP
JOIN HumanResources.Employee E ON EP.BusinessEntityID = E.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory EDH ON E.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department D ON EDH.DepartmentID = D.DepartmentID
GROUP BY D.Name
ORDER BY AverageSalary DESC;

--19. Employee Count by Department
SELECT 
    D.Name AS Department,
    COUNT(*) AS EmployeeCount
FROM HumanResources.EmployeeDepartmentHistory EDH
JOIN HumanResources.Department D ON EDH.DepartmentID = D.DepartmentID
GROUP BY D.Name
ORDER BY EmployeeCount DESC;

--20. Total Purchases by Vendor
SELECT 
    V.Name AS Vendor,
    ROUND(SUM(POH.TotalDue),2) AS TotalPurchases
FROM Purchasing.PurchaseOrderHeader POH
JOIN Purchasing.Vendor V ON POH.VendorID = V.BusinessEntityID
GROUP BY V.Name
ORDER BY TotalPurchases DESC;

--21.Customer Count by Territory
SELECT 
    ST.Name AS Territory,
    COUNT(C.CustomerID) AS CustomerCount
FROM Sales.Customer C
JOIN Sales.SalesTerritory ST ON C.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
ORDER BY CustomerCount DESC;

--22. Inventory Levels by Product
SELECT 
    P.Name AS ProductName,
    SUM(PI.Quantity) AS TotalQuantity
FROM Production.ProductInventory PI
JOIN Production.Product P ON PI.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalQuantity DESC;

-- 23. Sales Performance by Product Subcategory
SELECT 
    PSC.Name AS Subcategory,
    ROUND(SUM(SD.LineTotal),2) AS TotalSales
FROM Sales.SalesOrderDetail SD
JOIN Production.Product P ON SD.ProductID = P.ProductID
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
GROUP BY PSC.Name
ORDER BY TotalSales DESC;
--24. Customer Age Demographics
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) < 20 THEN 'Under 20'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 20 AND 29 THEN '20-29'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 30 AND 39 THEN '30-39'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS AgeGroup,
    COUNT(*) AS CustomerCount
FROM Person.Person
WHERE BirthDate IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) < 20 THEN 'Under 20'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 20 AND 29 THEN '20-29'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 30 AND 39 THEN '30-39'
        WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END
ORDER BY AgeGroup;

-- 25. Average Tenure of Employees by Department
SELECT 
    D.Name AS Department,
    AVG(DATEDIFF(YEAR, E.HireDate, GETDATE())) AS AverageTenure
FROM HumanResources.Employee E
JOIN HumanResources.EmployeeDepartmentHistory EDH ON E.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department D ON EDH.DepartmentID = D.DepartmentID
GROUP BY D.Name
ORDER BY AverageTenure DESC;

--26. Impact of Special Offers on Sales
SELECT 
    SO.Description AS SpecialOffer,
    ROUND(COUNT(SD.SalesOrderID),2) AS NumberOfOrders,
    ROUND(SUM(SD.LineTotal),2) AS TotalSales
FROM Sales.SpecialOfferProduct SOP
JOIN Sales.SpecialOffer SO ON SOP.SpecialOfferID = SO.SpecialOfferID
JOIN Sales.SalesOrderDetail SD ON SOP.ProductID = SD.ProductID
GROUP BY SO.Description
ORDER BY TotalSales DESC;

--27.  Total Revenue, Cost, and Profit by Year
WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        round(SUM(TotalDue),2) AS TotalRevenue
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
),
YearlyCost AS (
    SELECT 
        YEAR(POH.OrderDate) AS Year,
        SUM(POD.LineTotal) AS TotalCost
    FROM Purchasing.PurchaseOrderHeader POH
    JOIN Purchasing.PurchaseOrderDetail POD ON POH.PurchaseOrderID = POD.PurchaseOrderID
    GROUP BY YEAR(POH.OrderDate))
SELECT 
    YS.Year,
    YS.TotalRevenue,
    YC.TotalCost,
    (YS.TotalRevenue - YC.TotalCost) AS TotalProfit
FROM YearlySales YS
JOIN YearlyCost YC ON YS.Year = YC.Year
ORDER BY YS.Year;

--28. Average Revenue per Order and Average Cost per Order
SELECT 
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader) AS AverageRevenuePerOrder,
    (SELECT AVG(LineTotal) FROM Purchasing.PurchaseOrderDetail) AS AverageCostPerOrder;

--29. Profit Margin by Product
	WITH ProductSales AS (
    SELECT 
        P.ProductID,
        P.Name AS ProductName,
        SUM(SD.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail SD
    JOIN Production.Product P ON SD.ProductID = P.ProductID
    GROUP BY P.ProductID, P.Name
),
ProductCost AS (
    SELECT 
        P.ProductID,
        P.Name AS ProductName,
        SUM(P.StandardCost * PI.Quantity) AS TotalCost
    FROM Production.Product P
    JOIN Production.ProductInventory PI ON P.ProductID = PI.ProductID
    GROUP BY P.ProductID, P.Name
)
SELECT 
    PS.ProductName,
    PS.TotalSales,
    PC.TotalCost,
    (PS.TotalSales - PC.TotalCost) AS Profit,
    ((PS.TotalSales - PC.TotalCost) / PS.TotalSales) * 100 AS ProfitMargin
FROM ProductSales PS
JOIN ProductCost PC ON PS.ProductID = PC.ProductID
ORDER BY ProfitMargin DESC;

--30.Sales Growth Rate by Year
WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
),
SalesGrowth AS (
    SELECT 
        Year,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY Year) AS PreviousYearSales,
        ((TotalSales - LAG(TotalSales) OVER (ORDER BY Year)) / LAG(TotalSales) OVER(ORDER BY Year)) * 100 AS GrowthRate
FROM YearlySales
)
SELECT
Year,
TotalSales,
PreviousYearSales,
GrowthRate
FROM SalesGrowth
WHERE PreviousYearSales IS NOT NULL
ORDER BY Year;

--31. Customer Lifetime Value (CLV)
SELECT 
    C.CustomerID,
    P.FirstName + ' ' + P.LastName AS CustomerName,
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS AverageRevenuePerCustomer,
    (SELECT COUNT(DISTINCT YEAR(OrderDate)) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS CustomerLifespan,
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) * 
    (SELECT COUNT(DISTINCT YEAR(OrderDate)) FROM Sales.SalesOrderHeader WHERE CustomerID = C.CustomerID) AS CustomerLifetimeValue
FROM Sales.Customer C
JOIbN Person.Person P ON C.PersonID = P.BusinessEntityID
ORDER BY CustomerLifetimeValue DESC;

--32. Operating Income by Year
WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(TotalDue) AS TotalRevenue
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
),
YearlyExpenses AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(LineTotal) AS TotalExpenses
    FROM Purchasing.PurchaseOrderDetail POD
    JOIN Purchasing.PurchaseOrderHeader POH ON POD.PurchaseOrderID = POH.PurchaseOrderID
    GROUP BY YEAR(OrderDate)
)
SELECT 
    YS.Year,
    YS.TotalRevenue,
    YE.TotalExpenses,
    (YS.TotalRevenue - YE.TotalExpenses) AS OperatingIncome
FROM YearlySales YS
JOIN YearlyExpenses YE ON YS.Year = YE.Year
ORDER BY YS.Year;