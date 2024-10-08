-- Add Primary Key to Customers Table
ALTER TABLE customers
ADD CONSTRAINT customers PRIMARY KEY (customer_id);

-- Add Primary Key to Categories Table
ALTER TABLE categories
ADD CONSTRAINT categories PRIMARY KEY (category_id);

-- Add Primary Key to Suppliers Table
ALTER TABLE suppliers
ADD CONSTRAINT suppliers PRIMARY KEY (supplier_id);

-- Add Primary Key to Products Table
ALTER TABLE products
ADD CONSTRAINT products PRIMARY KEY (product_id);

-- Add Primary Key to Orders Table
ALTER TABLE orders
ADD CONSTRAINT orders PRIMARY KEY (order_id);

-- Add Composite Primary Key to OrderDetails Table
ALTER TABLE order_details
ADD CONSTRAINT order_details PRIMARY KEY (order_id,product_id);

-- Add Foreign Key from Products to Suppliers Table
ALTER TABLE products
ADD CONSTRAINT suppliers FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

-- Add Foreign Key from Products to Categories Table
ALTER TABLE products
ADD CONSTRAINT products FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- Add Foreign Key from Orders to Customers Table
ALTER TABLE orders
ADD CONSTRAINT orders FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Add Foreign Key from Orders to Employees Table
ALTER TABLE orders
ADD CONSTRAINT employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

-- Add Foreign Key from Orders to Shippers Table
ALTER TABLE orders
ADD CONSTRAINT shippers FOREIGN KEY (ship_via) REFERENCES shippers(shipper_id);

-- Add Foreign Key from OrderDetails to Orders Table
ALTER TABLE order_details
ADD CONSTRAINT orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- Add Foreign Key from OrderDetails to Products Table
ALTER TABLE order_details
ADD CONSTRAINT products FOREIGN KEY (product_id) REFERENCES products(product_id);

