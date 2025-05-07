-- Create the database
CREATE DATABASE IF NOT EXISTS NaivasInventoryDB;
USE NaivasInventoryDB;

-- 1. Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(150) NOT NULL,
    Brand VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 3. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(150) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Location VARCHAR(100)
);

-- 4. Branches Table
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(150) NOT NULL
);

-- 5. Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    Phone VARCHAR(15),
    BranchID INT NOT NULL,
    CONSTRAINT fk_branch_employee FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 6. Inventory Table (Tracks product quantities at each branch)
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    BranchID INT,
    ProductID INT,
    Quantity INT NOT NULL DEFAULT 0,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (BranchID, ProductID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 7. Purchases Table
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    ReceivedBy INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ReceivedBy) REFERENCES Employees(EmployeeID)
);

-- 8. PurchaseDetails Table (M:N Relationship between Purchases and Products)
CREATE TABLE PurchaseDetails (
    PurchaseDetailID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    CostPerUnit DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- --------------------------------------------------------
-- Insert Sample Data
-- --------------------------------------------------------

-- Categories
INSERT INTO Categories (CategoryName) VALUES
('Cereals'), ('Bakery'), ('Dairy'), ('Beverages'), ('Spices');

-- Products
INSERT INTO Products (ProductName, Brand, CategoryID, Price) VALUES
('Jogoo Maize Flour 2kg', 'Jogoo', 1, 155.00),
('Soko Maize Flour 2kg', 'Soko', 1, 150.00),
('White Bread', 'Broadways', 2, 70.00),
('Blue Band Margarine 250g', 'Blue Band', 3, 120.00),
('Brookside Milk 500ml', 'Brookside', 3, 60.00),
('Chai Bora Tea Leaves 250g', 'Chai Bora', 4, 180.00),
('Royco Mchuzi Mix 100g', 'Royco', 5, 85.00);

-- Suppliers
INSERT INTO Suppliers (SupplierName, Phone, Email, Location) VALUES
('Unga Group Ltd', '0722123456', 'info@unga.co.ke', 'Nairobi'),
('Brookside Dairies', '0700112233', 'sales@brookside.co.ke', 'Ruiru'),
('Bidco Africa', '0733445566', 'contact@bidcoafrica.com', 'Thika'),
('Unilever Kenya', '0711002200', 'support@unilever.co.ke', 'Nairobi');

-- Branches
INSERT INTO Branches (BranchName, Location) VALUES
('Naivas Westlands', 'Westlands, Nairobi'),
('Naivas Embakasi', 'Embakasi, Nairobi'),
('Naivas Kisumu', 'Kisumu City, Kisumu');

-- Employees
INSERT INTO Employees (FullName, Position, Phone, BranchID) VALUES
('Brian Mwangi', 'Inventory Manager', '0700001111', 1),
('Esther Njeri', 'Cashier', '0711223344', 2),
('Kevin Otieno', 'Stock Clerk', '0722334455', 3);

-- Purchases
INSERT INTO Purchases (SupplierID, PurchaseDate, ReceivedBy) VALUES
(1, '2025-05-01', 1),
(2, '2025-05-02', 3),
(4, '2025-05-03', 1);

-- Purchase Details
INSERT INTO PurchaseDetails (PurchaseID, ProductID, Quantity, CostPerUnit) VALUES
(1, 1, 100, 145.00),
(1, 2, 80, 140.00),
(2, 5, 200, 55.00),
(2, 4, 100, 110.00),
(3, 7, 150, 75.00);

-- Inventory
INSERT INTO Inventory (BranchID, ProductID, Quantity) VALUES
(1, 1, 90),
(1, 2, 70),
(2, 5, 180),
(3, 4, 90),
(1, 7, 140);
