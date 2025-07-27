-- Create and Use the Database
CREATE DATABASE AxiaStore;
GO

USE AxiaStore;
GO

-- Create CustomersTB Table
CREATE TABLE CustomersTB (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(50));

-- Insert Records into CustomersTB
INSERT INTO CustomersTB (CustomerID, FirstName, LastName, Email, Phone, City) VALUES
(1, 'Musa', 'Ahmed', 'musa.ahmed@hotmail.com', '0803-123-0001', 'Lagos'),
(2, 'Ray', 'Samson', 'ray.samson@yahoo.com', '0803-123-0002', 'Ibadan'),
(3, 'Chinedu', 'Okafor', 'chinedu.ok@yahoo.com', '0803-123-0003', 'Enugu'),
(4, 'Dare', 'Adewale', 'dare.ad@hotmail.com', '0803-123-0004', 'Abuja'),
(5, 'Efe', 'Ojo', 'efe.oj@gmail.com', '0803-123-0005', 'Port Harcourt'),
(6, 'Aisha', 'Bello', 'aisha.bello@hotmail.com', '0803-123-0006', 'Kano'),
(7, 'Tunde', 'Salami', 'tunde.salami@yahoo.com', '0803-123-0007', 'Ilorin'),
(8, 'Nneka', 'Umeh', 'nneka.umeh@gmail.com', '0803-123-0008', 'Owerri'),
(9, 'Kelvin', 'Peters', 'kelvin.peters@hotmail.com', '0803-123-0009', 'Asaba'),
(10, 'Blessing', 'Mark', 'blessing.mark@gmail.com', '0803-123-0010', 'Uyo');

-- Create ProductsTB Table
CREATE TABLE ProductsTB (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(18, 0),
    StockQty INT
);

-- Insert Records into ProductsTB
INSERT INTO ProductsTB (ProductID, ProductName, Category, UnitPrice, StockQty) VALUES
(1, 'Wireless Mouse', 'Accessories', 7500, 120),
(2, 'USB-C Charger 65W', 'Electronics', 14500, 75),
(3, 'Noise-Cancel Headset', 'Audio', 85500, 50),
(4, '27" 4K Monitor', 'Displays', 185000, 20),
(5, 'Laptop Stand', 'Accessories', 19500, 90),
(6, 'Bluetooth Speaker', 'Audio', 52000, 60),
(7, 'Mechanical Keyboard', 'Accessories', 18500, 40),
(8, 'WebCam 1080p', 'Electronics', 25000, 55),
(9, 'Smartwatch Series 5', 'Wearables', 320000, 30),
(10, 'Portable SSD 1TB', 'Storage', 125000, 35);

-- Create OrderTB Table
CREATE TABLE OrderTB (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES CustomersTB(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES ProductsTB(ProductID)
);

-- Insert Records into OrderTB
INSERT INTO OrderTB (OrderID, CustomerID, ProductID, OrderDate, Quantity) VALUES
(1001, 1, 3, '2025-06-01', 1),
(1002, 2, 1, '2025-06-03', 2),
(1003, 3, 5, '2025-06-05', 1),
(1004, 4, 4, '2025-06-10', 1),
(1005, 5, 2, '2025-06-12', 3),
(1006, 6, 7, '2025-06-15', 1),
(1007, 7, 6, '2025-06-18', 2),
(1008, 8, 8, '2025-06-20', 1),
(1009, 9, 9, '2025-06-22', 1),
(1010, 10, 10, '2025-06-25', 2);

-- Return FirstName and Email of customers who purchased “Wireless Mouse”
SELECT C.FirstName, C.Email
FROM CustomersTB C
JOIN OrderTB O ON C.CustomerID = O.CustomerID
JOIN ProductsTB P ON O.ProductID = P.ProductID
WHERE P.ProductName = 'Wireless Mouse';

-- List all customers full names in ascending alphabetical order (LastName then FirstName)
SELECT LastName + ' ' + FirstName AS FullName
FROM CustomersTB
ORDER BY LastName ASC, FirstName ASC;

-- Show every order with full name, product name, quantity, unit price, total price, and order date
SELECT 
    C.FirstName + ' ' + C.LastName AS FullName,
    P.ProductName,
    O.Quantity,
    P.UnitPrice,
    (O.Quantity * P.UnitPrice) AS TotalPrice,
    O.OrderDate
FROM OrderTB O
JOIN CustomersTB C ON O.CustomerID = C.CustomerID
JOIN ProductsTB P ON O.ProductID = P.ProductID;

-- Show average sales per product category and sort in descending order
SELECT 
    P.Category,
    AVG(O.Quantity * P.UnitPrice) AS AvgSales
FROM OrderTB O
JOIN ProductsTB P ON O.ProductID = P.ProductID
GROUP BY P.Category
ORDER BY AvgSales DESC;

-- Which city generated the highest revenue?
SELECT TOP 1
    C.City,
    SUM(O.Quantity * P.UnitPrice) AS TotalRevenue
FROM OrderTB O
JOIN CustomersTB C ON O.CustomerID = C.CustomerID
JOIN ProductsTB P ON O.ProductID = P.ProductID
GROUP BY C.City
ORDER BY TotalRevenue DESC;
