-- practice db 이동
-- userinfo 테이블에
-- 데이터 5건 넣기 (별명, 핸드폰) -> 별명 bob 포함하세요
-- 전체 조회 (중간중간 계속 실행하면서 모니터링)
-- id가 3인 사람 조회
-- 별명이 bob인 사람을 조회
-- 별명이 bob인 사람의 핸드폰 번호를 01099998888로 수정 (id로 수정)
-- 별명이 bob인 사람 삭제 (id로 수정)

USE practice;
DESC userinfo;
INSERT INTO userinfo (nickname, phone) VALUES
('cindy', '01077776666'),
('bob', '0103333222'),
('steve', '01022221111'),
('mira', '01044442222'),
('rumi', '01019994444');
SELECT * FROM userinfo;

SELECT * FROM userinfo WHERE id=3;

SELECT * FROM userinfo WHERE nickname='bob';

UPDATE userinfo SET phone='01099998888' WHERE id=7;

DELETE FROM userinfo WHERE id=7;

INSERT INTO userinfo (nickname, phone) VALUES ('cindy', '010222222');

SELECT * FROM userinfo WHERE nickname='cindy';