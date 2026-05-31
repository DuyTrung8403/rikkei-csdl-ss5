CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          product_name VARCHAR(100) NOT NULL,
                          category VARCHAR(50) NOT NULL
);


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



-- 1.Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
-- Hiển thị: product_name, total_revenue

SELECT
    p.product_name,
    SUM(o.total_price) total_revenue
FROM products p
         LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.product_id
HAVING SUM(o.total_price) = (
    SELECT MAX(total_revenue)
    FROM (SELECT
              p.product_name,
              SUM(o.total_price) total_revenue
          FROM products p
                   LEFT JOIN orders o on p.product_id = o.product_id
          GROUP BY p.product_id) t);

-- 2.Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
SELECT
    p.category,
    SUM(o.total_price) total_sales
FROM products p
         LEFT JOIN orders o on p.product_id = o.product_id
GROUP BY p.category;