-- Tạo bảng customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
            REFERENCES customers(customer_id)
);

-- Tạo bảng order_items
CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
            REFERENCES orders(order_id)
);

-- Insert dữ liệu vào customers
INSERT INTO customers (customer_id, customer_name, city)
VALUES
    (1, 'Nguyễn Văn A', 'Hà Nội'),
    (2, 'Trần Thị B', 'Đà Nẵng'),
    (3, 'Lê Văn C', 'Hồ Chí Minh'),
    (4, 'Phạm Thị D', 'Hà Nội');

-- Insert dữ liệu vào orders
INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES
    (101, 1, '2024-12-20', 3000),
    (102, 2, '2025-01-05', 1500),
    (103, 1, '2025-02-10', 2500),
    (104, 3, '2025-02-15', 4000),
    (105, 4, '2025-03-01', 800);

-- Insert dữ liệu vào order_items
INSERT INTO order_items (item_id, order_id, product_id, quantity, price)
VALUES
    (1, 101, 1, 2, 1500),
    (2, 102, 2, 1, 1500),
    (3, 103, 3, 5, 500),
    (4, 104, 2, 4, 1000);


-- 1Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
-- a Chỉ hiển thị khách hàng có tổng doanh thu > 2000
-- b Dùng ALIAS: total_revenue và order_count
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_price) AS total_revenue,
    COUNT(o.order_id) AS order_count
FROM customers c
         LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING SUM(o.total_price) > 2000;

-- 2Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó

SELECT
    c.customer_name,
    SUM(o.total_price) total_revenue
FROM customers c
         LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_price) > (SELECT
    AVG(total_revenue) "Doanh thu trung binh"
FROM (
    SELECT
    SUM(o.total_price) total_revenue
    FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_id
    ) t);



-- 3Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
SELECT
    c.city,
    SUM(o.total_price) AS total_revenue
FROM customers c
         LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY
    c.city
HAVING SUM(o.total_price) = (SELECT MAX(total_revenue) FROM (SELECT
    SUM(o.total_price) AS total_revenue
    FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY
    c.city) t);

-- 4(Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
-- Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
SELECT
    c.customer_name "Tên khách hàng",
    c.city "Tên Thành phố",
    SUM(oi.quantity) "Tổng sản phẩm đã mua",
    SUM(oi.quantity * oi.price) "Tổng chi tiêu"
FROM customers c
    JOIN orders o on c.customer_id = o.customer_id
    JOIN order_items oi on o.order_id = oi.order_id
GROUP BY c.customer_name, c.city ;

