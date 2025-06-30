USE lecture;

-- 모든 컬럼, 모든 조건
SELECT * FROM members;

-- 모든 컬럼, id 2
SELECT * FROM members WHERE id=2;

-- 컬럼 이름+이메일, 모든 레코드
SELECT name, email FROM members;

-- 컬럼 이름, 이름=김민정
SELECT name FROM members WHERE name='김민정';

