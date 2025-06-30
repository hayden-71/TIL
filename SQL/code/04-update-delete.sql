SELECT * FROM members;

-- Update (데이터 수정)
UPDATE members SET name='정발산', email='jung@a.com' WHERE id=3;
-- 원치 않는 케이스 (name이 같으면 동시 수정)
UPDATE members SET name='No name' WHERE name='김민정';

-- Delete (데이터 삭제)
DELETE FROM members WHERE id=3;
-- 테이블 모든 데이터 삭제
DELETE FROM members;
