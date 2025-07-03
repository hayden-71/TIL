USE lecture;

SELECT length('hello sql');

-- 문자열 길이
SELECT nickname, length(nickname) FROM dt_demo;
SELECT name, char_length(name) AS '이름 길이' FROM dt_demo; -- 영어 외 다른 문자들은 char_length 써야 제대로 나옴


-- 문자열 연결
SELECT concat('hello', 'sql', ' ', '!!');
SELECT concat(name, '(', score, ')') AS info FROM dt_demo;

-- 대소문자 변환
SELECT
	nickname,
    upper(nickname) AS UN,
    lower(nickname) AS LN FROM dt_demo;
    
-- 부분 문자열 추출 (문자열, 시작점, 길이)
SELECT substring('hello sql!', 2, 4);
SELECT LEFT('hello sql!!', 5);
SELECT right('hello sql!!', 5);


SELECT * FROM dt_demo;


SELECT 
	description,
	concat(
		substring(description, 1, 5), '...'
	) AS intro,
	concat(
		LEFT(description, 3),
		'...',
		Right(description, 3)
	) AS summary
From dt_demo;

-- 문자열 치환
SELECT replace('a@test.com', 'test.com', 'gmail.com');
SELECT 
	description,
    REPLACE(description, '학생', '*바보*') AS 보안
FROM dt_demo;
