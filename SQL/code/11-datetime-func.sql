-- 11-datetime-func.sql

USE lecture;
SELECT * FROM dt_demo;
DESC dt_demo;
DROP dt_demo;


CREATE TABLE dt_demo (
    id          INT         AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(20) NOT NULL,
    nickname    VARCHAR(20),
    birth       DATE,
    score       FLOAT,
    salary      DECIMAL(20, 3),
    description TEXT,
    is_active   BOOL        DEFAULT TRUE,
    created_at  DATETIME    DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO dt_demo (name, nickname, birth, score, salary, description)
VALUES
('김철수', 'kim', '1995-01-01', 88.75, 3500000.50, '우수한 학생입니다.'),
('이영희', 'lee', '1990-05-15', 92.30, 4200000.00, '성실하고 열심히 공부합니다.'),
('박민수', 'park', '1988-09-09', 75.80, 2800000.75, '기타 사항 없음'),
('유태영', 'yu', '2002-07-01', 71.23, 8400000, '학생이 아님');

-- 데이터 확인
SELECT * FROM dt_demo;











-- 현재 날짜/시간
-- 날짜 + 시간
SELECT now() AS 지금시간;
SELECT current_timestamp;

-- 날짜
SELECT curdate();
SELECT current_date;

-- 시간
SELECT curtime();
SELECT current_time;

SELECT 
	name,
	birth AS 원본,
    date_format(birth, '%y년 %m월 %d일') AS 한국식,
    date_format(birth, '%Y-%m') AS 년월,
    date_format(birth, '%M %D, %Y') AS 영문식,
    date_format(birth, '%w') AS 요일번호, -- 일요일 0 기준
    date_format(birth, '%W') AS 요일이름
FROM dt_demo;

SELECT 
	created_at AS 원본시간,
    date_format(created_at, '%Y-%m-%d %H:%i') AS 분까지만,
    date_format(created_at, '%p %h:%i') AS 12시간
    from dt_demo;
    
-- 날짜 계산 함수
SELECT
	name,
    birth,
    datediff(curdate(), birth) AS 살아온날들,
    -- timestampdiff (결과 단위, 날짜1, 날짜2)
    timestampdiff(YEAR, birth, curdate()) AS 나이
FROM dt_demo;

-- 더하기/빼기
SELECT
	name, birth,
    date_add(birth, interval 100 day) AS 백일후,
    date_add(birth, interval 1 year) AS 돌,
    date_sub(curdate(), interval 10 month) AS 등장
FROM dt_demo;

-- 계정 생성 후 경과 시간
SELECT
	name, created_at,
    timestampdiff(hour, created_at, now()) AS 가입후시간,
    timestampdiff(DAY, created_at, now()) AS 가입후일수
FROM dt_demo;

-- 날짜 추출
select
	name, birth,
    -- birth -> date정보
    YEAR(birth),
    MONTH(birth),
    DAY(birth),
    dayofweek(birth) AS 요일번호,
    dayname(birth) AS 요일,
    QUARTER(birth) AS 분기
FROM dt_demo;

-- 월별, 연도별
SELECT
	year(birth) AS 출생년도,
    COUNT(*) AS 인원수
FROM dt_demo
GROUP BY year(birth)
ORDER BY 출생년도;

SELECT
	year(birth) DIV 10