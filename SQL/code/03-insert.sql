USE lecture;
DESC members;

-- 데이터 입력 (Create)
INSERT INTO members (name, email) VALUES ('김민정', 'kim@a.com');
INSERT INTO members (name, email) VALUES ('이정윤', 'lee@a.com');

-- 여러줄, (col1, col2) 순서 잘 맞추기!
INSERT INTO members (email, name) VALUES 
('jeong@a.com', '정화영'), 
('park@a.com', '박희영');

-- 데이터 전체 조회 (*-> 모든 컬럼 이라는 뜻) (Read)
SELECT * FROM members;
-- 단일 데이터 조회 
SELECT * FROM members WHERE id=1;


