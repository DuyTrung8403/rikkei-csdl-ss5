CREATE TABLE students
(
    student_id SERIAL PRIMARY KEY,
    full_name  VARCHAR(100),
    major      VARCHAR(50)
);

CREATE TABLE courses
(
    course_id   SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit      INT
);

CREATE TABLE enrollments
(
    student_id INT REFERENCES students (student_id),
    course_id  INT REFERENCES courses (course_id),
    score      NUMERIC(5, 2)
);


INSERT INTO students (full_name, major)
VALUES ('Nguyễn Trung Kiên', 'Information Technology'),
       ('Phạm Minh Hải', 'Data Science'),
       ('Trần Thu Thảo', 'Business Administration'),
       ('Lê Hoàng Nam', 'Information Technology');


INSERT INTO courses (course_name, credit)
VALUES ('Cơ sở dữ liệu SQL', 3),
       ('Lập trình Python', 4),
       ('Toán cao cấp', 3);


INSERT INTO enrollments (student_id, course_id, score)
VALUES (1, 1, 8.50),
       (1, 2, 9.00),
       (2, 2, 7.25),
       (2, 3, 5.80),
       (3, 1, 9.50),
       (4, 3, 4.50);


-- 1. ALIAS:
-- Liệt kê danh sách sinh viên cùng tên môn học và điểm
-- dùng bí danh bảng ngắn (vd. s, c, e) và bí danh cột như Tên sinh viên, Môn học, Điểm

SELECT
    s.full_name "Tên SV",
    c.course_name "Tên môn",
    e.score "Điểm"
FROM students s
    JOIN enrollments e on s.student_id = e.student_id
    JOIN courses c on c.course_id = e.course_id;

-- 2. Aggregate Functions: Tính cho từng sinh viên:
-- Điểm trung bình
SELECT
    s.full_name "Tên SV",
    AVG(e.score) "Điểm TB"
FROM students s
         JOIN enrollments e on s.student_id = e.student_id
         JOIN courses c on c.course_id = e.course_id
GROUP BY s.full_name;

-- Điểm cao nhất
SELECT
    s.full_name "Tên SV",
    MAX(e.score) "Điểm cao nhất"
FROM students s
         JOIN enrollments e on s.student_id = e.student_id
         JOIN courses c on c.course_id = e.course_id
GROUP BY s.full_name;

-- Điểm thấp nhất
SELECT
    s.full_name "Tên SV",
    MIN(e.score) "Điểm thấp nhất"
FROM students s
         JOIN enrollments e on s.student_id = e.student_id
         JOIN courses c on c.course_id = e.course_id
GROUP BY s.full_name;

-- 3. GROUP BY / HAVING: Tìm ngành học (major) có điểm trung bình cao hơn 7.5
SELECT
    s.major,
    AVG(e.score)
FROM students s
    JOIN enrollments e on s.student_id = e.student_id
GROUP BY s.major
HAVING AVG(e.score) > 7.5;

-- 4. JOIN: Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
SELECT
    s.full_name "Ten SV",
    c.course_name "Mon hoc",
    c.credit "So tin chi",
    e.score "Diem"
FROM students s
    JOIN enrollments e on s.student_id = e.student_id
    JOIN courses c on c.course_id = e.course_id;


-- 5. Subquery: Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường Gợi ý: dùng AVG(score) trong subquery
SELECT s.full_name,
       AVG(e.score)
FROM students s
         JOIN enrollments e on s.student_id = e.student_id
GROUP BY s.full_name
HAVING AVG(e.score) > (SELECT AVG(e.score)
                       FROM students s
                                JOIN enrollments e on s.student_id = e.student_id);

