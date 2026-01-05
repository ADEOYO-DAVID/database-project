-- ==========================================
-- 1. DATABASE & TABLE CREATION
-- ==========================================

-- Create Users Table (Admins and Standard Users)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'User') DEFAULT 'User',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Categories Table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create Items Table
CREATE TABLE Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    size ENUM('Small', 'Medium', 'Large') NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    status ENUM('Pending', 'Approved', 'Disapproved') DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create OrderItems Table (Junction table for Many-to-Many relationship)
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);


-- ==========================================
-- 2. INSERTING RECORDS
-- ==========================================

-- Insert Categories
INSERT INTO Categories (category_name, description) VALUES 
('Electronics', 'Gadgets and devices'),
('Office Supplies', 'Stationery and desk items');

-- Insert Items
INSERT INTO Items (item_name, price, size, stock_quantity, category_id) VALUES 
('Wireless Mouse', 25.00, 'Small', 100, 1),
('Ergonomic Chair', 150.00, 'Large', 20, 2),
('Laptop Stand', 45.00, 'Medium', 50, 1);

-- Insert Users
INSERT INTO Users (username, email, password_hash, role) VALUES 
('AdminUser', 'admin@companyx.com', 'hashedpass123', 'Admin'),
('JohnSmith', 'john@companyx.com', 'hashedpass456', 'User');

-- Insert an Order
INSERT INTO Orders (user_id, status) VALUES (2, 'Pending');

-- Insert Items into that Order (User bought 2 Mice and 1 Chair)
INSERT INTO OrderItems (order_id, item_id, quantity) VALUES 
(1, 1, 2),
(1, 2, 1);


-- ==========================================
-- 3. UPDATING RECORDS (Two or more entities)
-- ==========================================

-- Update stock in Items when an order is approved, 
-- and update the Order status simultaneously (Transaction logic usually required here)
UPDATE Orders SET status = 'Approved' WHERE order_id = 1;
UPDATE Items SET stock_quantity = stock_quantity - 2 WHERE item_id = 1;


-- ==========================================
-- 4. DELETING RECORDS (Two or more entities)
-- ==========================================

-- Delete a specific item from an order (OrderItems) 
-- and then delete the Order itself if empty.
DELETE FROM OrderItems WHERE order_id = 1 AND item_id = 2;
DELETE FROM Orders WHERE order_id = 1;


-- ==========================================
-- 5. QUERIES & JOINS (Multiple Entities)
-- ==========================================

-- Get all orders with User name, Item names, and Categories
SELECT 
    u.username,
    o.order_id,
    o.status,
    i.item_name,
    i.size,
    c.category_name,
    oi.quantity
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Items i ON oi.item_id = i.item_id
JOIN Categories c ON i.category_id = c.category_id;