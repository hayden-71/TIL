USE lecture;

-- 특정 컬럼을 기준으로 정렬함
-- ASC 오름차순 | DESC 내림차순

SELECT * FROM students;

-- 이름 ㄱㄴㄷ 순으로 정렬 -> Default 정렬 방식=ASC
SELECT * FROM students ORDER BY name;
SELECT * FROM students ORDER BY name ASC; -- 위와 결과 동일
SELECT * FROM students ORDER BY name DESC;

-- 테이블 구조 변경 -> 컬럼 추가 -> grade varchar(1) -> 기본값 B
-- 데이터 변경. id 1~3은 A, id 3~5은 C
ALTER TABLE students ADD COLUMN grade VARCHAR(1) DEFAULT 'B';
UPDATE students SET grade = 'A' WHERE id<=3;
UPDATE students SET grade = 'B' WHERE id between 4 and 5;
UPDATE students SET grade= 'C' WHERE id between 6 and 8;

-- 다중 컬럼 정렬 -> 앞에 말한게 우선 정렬
SELECT * FROM students ORDER BY
age ASC,
grade DESC;

SELECT * FROM students ORDER BY
grade DESC,
age ASC;

-- 나이가 40 미만인 학생들 중에서 학점순 - 나이 많은 순으로 상위 5명 뽑기
SELECT * FROM students WHERE age<40
ORDER BY grade ASC, age DESC
LIMIT 5;