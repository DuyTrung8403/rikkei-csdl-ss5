CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);


-- 3. Tạo bảng đơn hàng (orders)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL,
    total_price NUMERIC(12, 2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, category)
VALUES (1, 'Laptop Dell', 'Electronics'),
       (2, 'IPhone 15', 'Electronics'),
       (3, 'Bàn học gỗ', 'Furniture'),
       (4, 'Ghế xoay', 'Furniture');

INSERT INTO orders (order_id, product_id, quantity, total_price)
VALUES (101, 1, 2, 2200),
       (102, 2, 3, 3300),
       (103, 3, 5, 2500),
       (104, 4, 4, 1600),
       (105, 1, 1, 1100);



-- 1.Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
-- Đặt bí danh cột như sau:
-- total_sales cho tổng doanh thu
-- total_quantity cho tổng số lượng
SELECT
    p.category,
    SUM(o.total_price) total_sales,
    SUM(o.quantity) total_quantity
FROM products p
    LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.category;


-- 2.Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
SELECT
    p.category,
    SUM(o.total_price) total_sales,
    SUM(o.quantity) total_quantity
FROM products p
         LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.category
HAVING SUM(o.total_price) >2000;

-- 3.Sắp xếp kết quả theo tổng doanh thu giảm dần
SELECT
    p.category,
    SUM(o.total_price) total_sales,
    SUM(o.quantity) total_quantity
FROM products p
         LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.category ORDER BY total_sales DESC;