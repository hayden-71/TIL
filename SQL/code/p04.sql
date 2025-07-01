USE practice;

DESC userinfo;
SELECT * FROM userinfo;

INSERT INTO userinfo (nickname, phone, email) VALUES
('김철수', '01112345378', 'kim@test.com'),
('이영희', NULL, 'lee@gmail.com'),
('박민수', '01612345637', NULL),
('최영수', '01745367894', 'choi@naver.com');

-- id가 3이상
SELECT * FROM userinfo WHERE id>=3;
-- email이 gmail이거나 naver인 사람 --or 연산
SELECT * FROM userinfo WHERE email LIKE '%@gmail%' OR email LIKE '%naver.com';
-- 이름이 김철수, 박민수 2명 뽑기 -- 헤더를 잘못 입력해서 결과값 안 나왔었음
SELECT * FROM userinfo WHERE nickname IN ('김철수','박민수');
SELECT * FROM userinfo WHERE nickname='김철수' OR nickname='박민수';

-- 이메일이 비어있는 사람들
SELECT * FROM userinfo WHERE email IS NULL; -- =null이라고 써서 오류 뜸.. 널이 값이 아니라서.. IS NULL이라고 써야 됨
SELECT * FROM userinfo WHERE email IS NOT NULL; -- email이 있는 사람들

-- 이름에 수 글자가 들어간 사람들
SELECT * FROM userinfo WHERE nickname LIKE '%수%';
-- 핸드폰 번호 010으로 시작하는 사람들 -> 010이 10으로 인식돼서 결과값이 안 나옴
SELECT * FROM userinfo WHERE phone LIKE '010%';

-- 이름에 'i'가 있고, 폰번호 010, gmail 쓰는 사람
SELECT * FROM userinfo WHERE 
nickname LIKE '%i%' AND 
phone LIKE '10%' AND 
email LIKE '%@gamil%';

-- 성이 김/이 둘중 하난데 gmail 씀
SELECT * FROM userinfo WHERE
-- nickname LIKE '김%' OR
nickname LIKE '이%'
AND email LIKE '%gmail.com';