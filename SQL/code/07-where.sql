-- SELECT 컬럼 FROM 테이블 WHERE 조건 ORDER BY 정렬기준 LIMIT 개수

USE lecture;
DROP TABLE students;	
CREATE TABLE students(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20),
age INT);

DESC students;

INSERT INTO students (name, age) VALUES
('김민정',30),
('고희정',27),
('김단솔',31),
('신정인',40),
('정화영',63),
('김재성',80),
('이정윤',19),
('홍규리',13);

SELECT * FROM students;

SELECT * FROM students WHERE name='김민정';
SELECT * FROM students WHERE age>=20; -- 이상

SELECT * FROM students WHERE id<>1; -- 해당 조건이 아닌
SELECT * FROM students WHERE id!=1; -- 위와 같은 수식

SELECT * FROM students WHERE age BETWEEN 20 AND 40; -- 20이상 40이하
SELECT * FROM students WHERE id IN (1,3,4,6); -- id가 ()인 데이터

-- 문자열 패턴 LIKE (% -> 있을수도 없을수도 있다.  _ -> 정확히 개수만큼 글자가 있다.)
-- 이씨만 찾기
SELECT * FROM students WHERE name LIKE '김%';
-- '정'이라는 글자가 들어가는 사람
SELECT * FROM students WHERE name LIKE '%정%';
-- 이메일이 gmail인 사람
SELECT * FROM students WHERE email LIKE '%@gamil%';

-- 이름이 정확히 3글자인 김씨
SELECT * FROM students WHERE name LIKE '김__';




