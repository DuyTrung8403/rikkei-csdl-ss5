CREATE TABLE customers
(
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (customer_id),
    order_date   DATE,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE order_items
(
    item_id      SERIAL PRIMARY KEY,
    order_id     INT REFERENCES orders (order_id),
    product_name VARCHAR(100),
    quantity     INT,
    price        NUMERIC(10, 2)
);

INSERT INTO customers (customer_name, city)
VALUES ('Nguyễn Văn A', 'Hà Nội'),
       ('Trần Thị B', 'Đà Nẵng'),
       ('Lê Hoàng C', 'TP Hồ Chí Minh');


INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2026-05-20', 1550000.00),
       (1, '2026-05-25', 450000.00),
       (2, '2026-05-28', 2300000.00);

INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES (1, 'Bàn làm việc gỗ', 1, 1200000.00),
       (1, 'Ghế xoay văn phòng', 1, 350000.00),
       (2, 'Chuột máy tính không dây', 1, 450000.00),
       (3, 'Màn hình máy tính 24 inch', 1, 2300000.00);


-- 1. ALIAS:
-- Hiển thị danh sách tất cả các đơn hàng với các cột:
-- Tên khách (customer_name)
-- Ngày đặt hàng (order_date)
-- Tổng tiền (total_amount)

SELECT c.customer_name "Tên khách",
       o.order_date    "Ngày đặt hàng",
       o.total_amount  "Tổng tiền"
FROM customers c
         JOIN orders o on c.customer_id = o.customer_id;


-- 2. Aggregate Functions:
-- Tính các thông tin tổng hợp:
-- Tổng doanh thu (SUM(total_amount))
SELECT SUM(o.total_amount) "Tổng doanh thu"
FROM orders o;

-- Trung bình giá trị đơn hàng (AVG(total_amount))
SELECT AVG(o.total_amount) "Trung bình giá trị đơn hàng"
FROM orders o;

-- Đơn hàng lớn nhất (MAX(total_amount))
SELECT MAX(o.total_amount) "Đơn hàng lớn nhất"
FROM orders o;

-- Đơn hàng nhỏ nhất (MIN(total_amount))
SELECT MIN(o.total_amount) "Đơn hàng nhỏ nhất"
FROM orders o;

-- Số lượng đơn hàng (COUNT(order_id))
SELECT COUNT(o.order_id) "So lương đơn hàng"
FROM orders o;


-- 3. GROUP BY / HAVING:
-- Tính tổng doanh thu theo từng thành phố
-- chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000

SELECT c.city              "Thành phố",
       SUM(o.total_amount) "Tong doanh thu"
FROM orders o
         JOIN customers c on c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000;


-- 4. JOIN: Liệt kê tất cả các sản phẩm đã bán, kèm:
-- Tên khách hàng
-- Ngày đặt hàng
-- Số lượng và giá
-- (JOIN 3 bảng customers, orders, order_items)

SELECT oi.product_name "Ten san phảm",
       c.customer_name "Tên KH",
       o.order_date    "Ngày đặt hàng",
       oi.quantity     "Số lượng",
       oi.price        "Giá"
FROM order_items oi
         JOIN orders o on o.order_id = oi.order_id
         JOIN customers c on c.customer_id = o.customer_id;

-- 5. Subquery:
-- Tìm tên khách hàng có tổng doanh thu cao nhất.
-- Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
SELECT c.customer_name,
       SUM(o.total_amount) "sum_total_amount"
FROM customers c
         JOIN orders o on c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) = (SELECT MAX(sum_total_amount)
                              FROM (SELECT SUM(o.total_amount) "sum_total_amount"
                                    FROM customers c
                                             JOIN orders o on c.customer_id = o.customer_id
                                    GROUP BY c.customer_name) t);







