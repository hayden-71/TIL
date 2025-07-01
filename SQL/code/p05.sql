USE PRACTICE;
SHOW TABLES;
SELECT * FROM userinfo;

ALTER TABLE userinfo ADD COLUMN age INT DEFAULT 20;
UPDATE userinfo SET age=30 WHERE id BETWEEN 6 and 9;

-- 이름 오름차순 상위 3명
-- email gmail인 사람들 나이순으로 정렬
-- 나이많은 사람들 중에 핸드폰번호 오름차순 3명의 이름, 폰번, 나이만 확인
-- 이름 오름차순 상위 3명인데, 가장 이름이 빠른 사람은 제외하고 3명
SELECT * FROM userinfo ORDER BY nickname LIMIT 3;
SELECT * FROM userinfo WHERE email LIKE '%@gmail.com'
ORDER BY age;
SELECT nickname, phone, age  FROM userinfo WHERE age>=30
ORDER BY phone;
SELECT * FROM userinfo ORDER BY nickname -- 페이지네이션
LIMIT 3 OFFSET 1; 