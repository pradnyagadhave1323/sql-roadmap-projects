-- =============================================================
-- Phase 5: Sales Analytics System
-- =============================================================
CREATE DATABASE sales_analytics;
GO
USE sales_analytics;
GO

-- =============================================================
-- customers
-- =============================================================

CREATE TABLE customers (
    customer_id INT          PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(100)   NOT NULL,
    email VARCHAR(100)       NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(100)        NOT NULL,
    state VARCHAR(100)       NOT NULL,
    segment VARCHAR(20)
        NOT NULL
        CHECK (segment IN ('Retail','Wholesale','Online','Corporate'))
        DEFAULT 'Retail',
    joined_date DATE         NOT NULL
);
GO
-- =============================================================
-- products
-- =============================================================
CREATE TABLE products (
    product_id INT             PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(150)  NOT NULL,
    category VARCHAR(100)      NOT NULL,
    unit_price DECIMAL(10,2)
        NOT NULL
        CHECK (unit_price > 0),
    cost_price DECIMAL(10,2)
        NOT NULL
        CHECK (cost_price > 0),
    stock_qty INT
        DEFAULT 0
        CHECK (stock_qty >= 0)
);
GO

-- =============================================================
-- sales
-- =============================================================
CREATE TABLE sales (
    sale_id INT           PRIMARY KEY IDENTITY(1,1),
    customer_id INT       NOT NULL,
    product_id INT        NOT NULL,
    quantity INT
        NOT NULL
        CHECK (quantity > 0),
    unit_price DECIMAL(10,2)
        NOT NULL
        CHECK (unit_price > 0),
    discount_pct DECIMAL(5,2)
        DEFAULT 0.00
        CHECK (discount_pct BETWEEN 0 AND 100),
    sale_date DATE       NOT NULL,
    payment_mode VARCHAR(20)
        NOT NULL
        CHECK (payment_mode IN ('Cash','Card','UPI','Net Banking'))
        DEFAULT 'Cash',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------
-- Customers 
-- -------------------------------------------------------------
INSERT INTO customers (full_name, email, phone, city, state, segment, joined_date) VALUES
('Arjun Sharma',    'arjun.sharma@mail.com',    '9876543001', 'Pune',       'Maharashtra', 'Retail',      '2022-01-15'),
('Priya Patel',     'priya.patel@mail.com',     '9123456001', 'Mumbai',     'Maharashtra', 'Online',      '2022-03-10'),
('Rahul Desai',     'rahul.desai@mail.com',     '9988776001', 'Delhi',      'Delhi',       'Corporate',   '2022-02-20'),
('Sneha Kulkarni',  'sneha.kulkarni@mail.com',  '9001122001', 'Bangalore',  'Karnataka',   'Wholesale',   '2022-04-05'),
('Vikram Nair',     'vikram.nair@mail.com',     '9871234001', 'Hyderabad',  'Telangana',   'Retail',      '2022-05-18'),
('Ananya Iyer',     'ananya.iyer@mail.com',     '9765432001', 'Chennai',    'Tamil Nadu',  'Online',      '2022-06-22'),
('Kiran Mehta',     'kiran.mehta@mail.com',     '9090901001', 'Pune',       'Maharashtra', 'Corporate',   '2022-07-30'),
('Divya Joshi',     'divya.joshi@mail.com',     '9090909001', 'Mumbai',     'Maharashtra', 'Retail',      '2022-08-14'),
('Rohan Verma',     'rohan.verma@mail.com',     '9112233001', 'Delhi',      'Delhi',       'Online',      '2022-09-01'),
('Meera Singh',     'meera.singh@mail.com',     '9654321001', 'Kolkata',    'West Bengal', 'Wholesale',   '2022-10-12'),
('Aditya Kumar',    'aditya.kumar@mail.com',    '9543210001', 'Bangalore',  'Karnataka',   'Corporate',   '2022-11-05'),
('Pooja Rao',       'pooja.rao@mail.com',       '9432109001', 'Hyderabad',  'Telangana',   'Retail',      '2023-01-18'),
('Suresh Pillai',   'suresh.pillai@mail.com',   '9321098001', 'Chennai',    'Tamil Nadu',  'Wholesale',   '2023-02-25'),
('Kavita Bhat',     'kavita.bhat@mail.com',     NULL,         'Pune',       'Maharashtra', 'Online',      '2023-03-08')
INSERT INTO customers (full_name, email, phone, city, state, segment, joined_date) VALUES
('Nikhil Gupta',    'nikhil.gupta@mail.com',    '9210987001', 'Kolkata',    'West Bengal', 'Retail',    '2023-04-20'),
('Ravi Shankar',    'ravi.shankar@mail.com',    '9000123001', 'Delhi',      'Delhi',       'Corporate', '2023-05-15'),
('Lalita Devi',     'lalita.devi@mail.com',     '9111222001', 'Mumbai',     'Maharashtra', 'Retail',    '2023-06-30'),
('Amit Verma',      'amit.verma@mail.com',      '9200001001', 'Bangalore',  'Karnataka',   'Online',    '2023-07-22'),
('Neha Sharma',     'neha.sharma@mail.com',     '9100001001', 'Hyderabad',  'Telangana',   'Wholesale', '2023-08-10'),
('Sanjay Iyer',     'sanjay.iyer@mail.com',     '9600001001', 'Chennai',    'Tamil Nadu',  'Corporate', '2023-09-05');

-- -------------------------------------------------------------
-- Products (across 5 categories)
-- -------------------------------------------------------------
INSERT INTO products (product_name, category, unit_price, cost_price, stock_qty) VALUES
-- Electronics
('Samsung 65" 4K TV',       'Electronics', 75000.00, 55000.00, 30),
('iPhone 15',               'Electronics', 80000.00, 62000.00, 50),
('Sony Headphones WH-1000', 'Electronics',  25000.00, 17000.00, 80),
('Men Formal Shirt',     'Clothing',      1500.00,   600.00, 200),
('Women Kurti',          'Clothing',      1200.00,   450.00, 250),
('Denim Jeans',             'Clothing',      2500.00,  1000.00, 150),
('Basmati Rice 5kg',        'Groceries',      650.00,   420.00, 500),
('Sunflower Oil 5L',        'Groceries',      800.00,   550.00, 300),
('Tata Tea Gold 500g',      'Groceries',      350.00,   200.00, 600),
('3-Seater Sofa',           'Furniture',    25000.00, 15000.00, 15),
('Queen Bed Frame',         'Furniture',    18000.00, 11000.00, 20),
('Study Table',             'Furniture',     8000.00,  4500.00, 35),
('Treadmill Pro 2000',      'Fitness',     45000.00, 32000.00, 20),
('Protein Powder 2kg',      'Fitness',      3200.00,  1800.00, 150),
('Resistance Bands Set',    'Fitness',      1500.00,   600.00, 200)

INSERT INTO products (product_name, category, unit_price, cost_price, stock_qty) VALUES
('Yoga Mat',                'Fitness',        999.00,   400.00, 300),   -- 16
('Adjustable Dumbbell Set', 'Fitness',      8500.00,  5000.00, 60),    -- 17
('Treadmill Pro X',         'Fitness',     45000.00, 32000.00, 20),    -- 18
('Office Chair',            'Furniture',    12000.00,  8000.00, 40),   -- 19
('Wardrobe Deluxe',         'Furniture',    30000.00, 22000.00, 15),   -- 20
('Gaming Mouse',            'Electronics',   2500.00,  1500.00, 120),  -- 21
('Air Fryer',               'Electronics',   8500.00,  6000.00, 35),   -- 22
('MacBook Air',             'Electronics',  95000.00, 78000.00, 18),   -- 23
('Protein Powder 2kg',      'Fitness',       3200.00,  1800.00, 150);  -- 24

-- -------------------------------------------------------------
-- Sales
-- -------------------------------------------------------------
INSERT INTO sales (customer_id, product_id, quantity, unit_price, discount_pct, sale_date, payment_mode) VALUES
(1,  2,  1, 80000.00, 5.00,  '2023-01-05', 'Card'),
(3,  5,  1, 65000.00, 0.00,  '2023-01-10', 'Net Banking'),
(5,  11, 5,   650.00, 0.00,  '2023-01-12', 'Cash'),
(7,  16, 1, 25000.00, 10.00, '2023-01-18', 'Card'),
(4,  1,  1, 75000.00, 8.00,  '2023-02-03', 'Net Banking'),
(6,  22, 1,  8500.00, 0.00,  '2023-02-07', 'Card'),
(8,  13, 4,   350.00, 5.00,  '2023-02-14', 'UPI'),
(9,  3,  1, 25000.00, 10.00, '2023-03-02', 'Card'),
(11, 24, 2,  3200.00, 0.00,  '2023-03-08', 'UPI'),
(13, 12, 3,   800.00, 0.00,  '2023-03-15', 'Cash'),
(15, 4,  1, 60000.00, 5.00,  '2023-04-04', 'Card'),
(2,  9,  3,  3500.00, 0.00,  '2023-04-10', 'Cash'),
(7,  14, 10,  100.00, 0.00,  '2023-04-16', 'UPI'),
(16, 2,  1, 80000.00, 0.00,  '2023-05-03', 'Card'),
(1,  11, 4,   650.00, 0.00,  '2023-05-09', 'Cash'),
(17, 5,  1, 65000.00, 5.00,  '2023-06-02', 'Net Banking'),
(12, 15, 2,   499.00, 0.00,  '2023-06-08', 'UPI'),
(18, 1,  1, 75000.00, 10.00, '2023-07-04', 'Card'),
(19, 3,  2, 25000.00, 5.00,  '2023-08-03', 'Card'),
(2,  5,  1, 65000.00, 0.00,  '2023-08-09', 'Net Banking'),
(14, 7,  4,  1200.00, 5.00,  '2023-08-15', 'Cash'),
(20, 4,  1, 60000.00, 0.00,  '2023-09-02', 'Card'),
(8,  17, 1, 18000.00, 0.00,  '2023-09-08', 'Net Banking'),
(4,  12, 5,   800.00, 5.00,  '2023-09-14', 'Cash'),
(1,  2,  1, 80000.00, 10.00, '2023-10-03', 'Card'),
(3,  1,  1, 75000.00, 12.00, '2023-10-07', 'Net Banking'),
(5,  4,  2, 60000.00, 8.00,  '2023-10-12', 'Card'),
(7,  5,  1, 65000.00, 5.00,  '2023-10-15', 'Net Banking'),
(9,  3,  2, 25000.00, 0.00,  '2023-10-18', 'Card'),
(11, 22, 2,  8500.00, 5.00,  '2023-10-20', 'UPI'),
(2,  6,  5,  1500.00, 0.00,  '2023-11-04', 'Cash'),
(6,  24, 2,  3200.00, 5.00,  '2023-11-10', 'UPI'),
(12, 18, 1,  8000.00, 0.00,  '2023-11-16', 'Card'),
(20, 8,  3,  2500.00, 5.00,  '2023-12-20', 'Cash'),
(1,  10, 2,  4500.00, 0.00,  '2023-12-26', 'UPI'),
(7,  11, 8,   650.00, 5.00,  '2024-01-20', 'Cash'),
(13, 7,  6,  1200.00, 10.00, '2024-02-14', 'Cash'),
(15, 17, 1, 18000.00, 0.00,  '2024-02-20', 'Net Banking'),
(2,  23, 1, 45000.00, 8.00,  '2024-03-18', 'Net Banking'),
(4,  13, 10,  350.00, 0.00,  '2024-03-25', 'UPI');