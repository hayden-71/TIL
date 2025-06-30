-- practice db 사용
-- 스키마 확인 & 데이터 확인 (주기적으로)
-- user info에 email 컬럼 추가 40글자 제한, 중복 안 됨, 기본값은 ex@gmail.com
-- nickname 길이제한 100자로 늘리기
-- reg_date 컬럼 삭제
-- 실제 한 명의 email을 수정하기

USE practice;
DESC userinfo;
SELECT * FROM userinfo;
ALTER TABLE userinfo ADD COLUMN email VARCHAR(40);
ALTER TABLE userinfo
ALTER COLUMN email SET DEFAULT 'ex@gmail.com';
ALTER TABLE userinfo MODIFY nickname VARCHAR(100);
ALTER TABLE userinfo DROP COLUMN reg_date;

UPDATE userinfo SET email='abc@gmail.com' WHERE id=6;