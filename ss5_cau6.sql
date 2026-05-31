CREATE TABLE departments
(
    dept_id   SERIAL PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees
(
    emp_id    SERIAL PRIMARY KEY,
    emp_name  VARCHAR(100),
    dept_id   INT REFERENCES departments (dept_id),
    salary    NUMERIC(10, 2),
    hire_date DATE
);

CREATE TABLE projects
(
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id      INT REFERENCES departments (dept_id)
);


INSERT INTO departments (dept_name)
VALUES ('Phòng Công nghệ thông tin'),
       ('Phòng Nhân sự'),
       ('Phòng Marketing');


INSERT INTO employees (emp_name, dept_id, salary, hire_date)
VALUES ('Nguyễn Văn An', 1, 15000000.00, '2024-03-15'),
       ('Trần Thị Bình', 1, 18000000.00, '2023-06-20'),
       ('Lê Văn Cường', 2, 12000000.00, '2025-01-10'),
       ('Phạm Minh Đức', 3, 14500000.00, '2024-08-01'),
       ('Hoàng Thu Thủy', NULL, 11000000.00, '2026-02-15');


INSERT INTO projects (project_name, dept_id)
VALUES ('Phát triển Hệ thống ERP', 1),
       ('Xây dựng Website Công ty', 1),
       ('Tuyển dụng Nhân sự mùa hè', 2),
       ('Chiến dịch Quảng cáo Tết', 3);


-- 1. ALIAS: Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
-- dùng bí danh bảng ngắn (employees as e,departments as d).

SELECT
    e.emp_name "Ten NV",
    e.salary "Luong",
    d.dept_name "Phong ban"
FROM employees e
    JOIN departments d on d.dept_id = e.dept_id;

-- 2. Aggregate Functions: Tính:
-- Tổng quỹ lương toàn công ty
SELECT SUM(e.salary) "Tong quy luong"
FROM employees e ;

-- Mức lương trung bình
SELECT AVG(e.salary) "Tong quy luong"
FROM employees e ;

-- Lương cao nhất, thấp nhất
SELECT MIN(e.salary) "Tong quy luong"
FROM employees e ;

SELECT MAX(e.salary) "Tong quy luong"
FROM employees e ;

-- Số nhân viên
SELECT COUNT(e.emp_id) "Tong quy luong"
FROM employees e ;


-- 3. GROUP BY / HAVING: Tính mức lương trung bình của từng phòng ban chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
SELECT
    d.dept_name,
    AVG(e.salary) "Luong TB theo phong ban"
FROM employees e
    JOIN departments d on d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 15000000;

-- 4. JOIN: Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
SELECT
    p.project_name "Ten du an",
    d.dept_name "Phong ban phu trach",
    STRING_AGG(e.emp_name, ', ') AS "Ten NV"
FROM projects p
    JOIN departments d on d.dept_id = p.dept_id
    JOIN employees e on d.dept_id = e.dept_id
GROUP BY p.project_name, d.dept_name ;

-- 5. Subquery: Tìm nhân viên có lương cao nhất trong mỗi phòng ban
SELECT
    e.emp_name "Ten NV",
    e.salary "Luong",
    d.dept_name "Phong ban"
FROM employees e
    JOIN departments d on d.dept_id = e.dept_id
WHERE (e.salary, e.dept_id) IN (
    SELECT
        Max(e.salary) "max_salary_by_department",
        d.dept_id
    FROM employees e
             JOIN departments d on d.dept_id = e.dept_id
    group by d.dept_id
    );

