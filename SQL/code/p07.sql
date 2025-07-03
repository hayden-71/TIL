-- p07

USE practice;

CREATE TABLE dt_demo2 AS SELECT * FROM lecture.dt_demo;

SELECT * FROM dt_demo2;

-- 종합 정보 표시
-- id -- name -- 닉네임 (null -> '미설정')
-- 출생년도 (19xx년생) -- 나이 (timestampdiff로 나이만 표시)
-- 점수 (소수 1자리 반올림, null -> 0) -- 등급 (A >= 90 / B >= 80 / C >= 70 / D)
-- 상태 (is_active 가 1 이면 '활성' / 0 '비활성')
-- 연령대 (청년 < 30 < 청장년 < 50 < 장년)

SELECT
	id, name,
    ifnull(nickname, '미설정') AS 닉네임,
    date_format(birth, '%Y년생') AS 출생년도,
    timestampdiff(year, birth, curdate()),
    -- 점수 (소수 1자리 반올림, null -> 0) 
    round(IFnull(score, 0), 1) AS 점수, -- 아하!!!!!!!!!
    -- IF(score IS NOT NULL, round(score, 1), 0) AS 점수 라고 써도 됨
    CASE
		WHEN score>=90 THEN 'A'
        WHEN SCORE>=80 THEN 'B'
        WHEN SCORE>=70 THEN 'C'
        ELSE 'D'
	END AS 등급,
 IF(is_active=0, '비활성', '활성') AS 상태

FROM dt_demo2;

SELECT
	id, name, 
    ifnull(nickname, '미설정') AS 닉네임,
	DATE_FORMAT(birth, '%Y년생') AS 출생년도, -- YEAR(birth) AS 출생 이렇게 쓰면 '년생'이라는 말을 못 넣음
    timestampdiff(year, birth, curdate()) AS 나이,
    round(score, 1) AS 점수,
	CASE
		WHEN score>=90 THEN 'A'
        WHEN score>=80 THEN 'B'
        WHEN score>=70 THEN 'C'
        ELSE 'D'
	END AS 등급,
    IF(is_active=1, '활성', '비활성') AS 상태,
    CASE
		WHEN  timestampdiff(year, birth, curdate())<30 THEN '청년'
        WHEN  timestampdiff(year, birth, curdate())<50 THEN '청장년'
        ELSE '장년'
END AS 연령대
FROM dt_demo2;
