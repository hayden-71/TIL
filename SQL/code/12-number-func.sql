-- 12-number-func
USE lecture;

-- 소수점(실수) 관련 함수들
SELECT
	name,
    score AS 원점수,
    round(score) AS 반올림,
    round(score, 1) AS 소수1반올림,
    ceil(score) AS 올림,
    floor(score) AS 내림,
    truncate(score, 1) AS 소수1버림 -- 내림이랑 버림은 음수일때 차이가 큼. Truncate 길이를 줄이다
FROM dt_demo;

-- 사칙연산
SELECT
	10 + 5 AS plus,
    10 - 5 AS minus,
    10 * 5 AS multyply,
    10 / 5 AS divide,
    10 DIV 3 AS 몫,
    10 % 3 AS 나머지,
    MOD(10, 3) AS 나머지2, -- modulo 나머지
    power(10, 3) AS 거듭제곱, -- 10^2 스퀘어 10^3 큐브
    sqrt(16) AS 루트,
    abs(-10) AS 절댓값;

SELECT * FROM dt_demo;

-- 홀수 짝수 구하기
SELECT
	id, name,
    id % 2 AS 나머지,
    CASE
		WHEN id % 2 = 0 THEN '짝수'
        ELSE '홀수'
	END AS 홀짝
FROM dt_demo;

-- 조건문 IF, CASE
SELECT
	name, score,
	IF(score>=80, '우수', '보통') AS 평가 -- >결과가 OX일때
FROM dt_demo;

SELECT
	name, 
    ifnull(score, 0) AS 점수, -- 대상이 null값이면 0으로
    CASE
		WHEN score>=90 THEN 'A'  -- 케이스 짤때, 위에 있을수록 더 좁은 조건이어야 함
		WHEN score>=80 THEN 'B'
		WHEN score>=70 THEN 'C'
		ELSE 'D'
	END AS 학점
FROM dt_demo;

-- INSERT INTO dt_demo(name) VALUES ('이상한');



