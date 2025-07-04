-- 20- subquery3

USE lecture;

-- 각 카테고리 별 평균매출 중에서 50만원 이상
SELECT
	s.category AS 카테고리,
    AVG(s.total_amount) AS 평균매출
FROM sales s GROUP BY s.category
HAVING 평균매출>=500000; -- having은 그룹핑한 결과값에만

-- 인라인 뷰(VIEW) => 내가 만든 테이블
SELECT *
FROM (
	SELECT
	s.category AS 카테고리,
    AVG(s.total_amount) AS 평균매출
	FROM sales s GROUP BY s.category
) AS category_summary 	-- 파생테이블(VIEW) 만들어서 FROM에 넣기~~
WHERE 평균매출 >= 500000;

-- 1. 카테고리별 매출 분석 후 필터링
-- 카테고리명, 주문건수, 총매출, 평균매출 [0<= 저단가 <40000 <= 중단가 <800000 <고단가]

SELECT
	카테고리,
    주문건수,
    총매출,
    평균매출,
    CASE
		WHEN 평균매출 >= 800000 THEN '고단가'
        WHEN 평균매출 >= 400000 THEN '중단가'
        ELSE '저단가'
	END AS 단가구분
FROM ( -- 이제 이게 내가 분석할 테이블~~~
 SELECT
	category AS 카테고리,
    count(*) AS 주문건수,
    SUM(total_amount) AS 총매출,
    AVG(total_amount) AS 평균매출
 FROM sales
 GROUP BY category
 ) AS c_a
WHERE 평균매출>=300000;

-- 영업사원별 성과 등급 분류 [영업사원, 총매출액, 주문건수, 평균주문액, 매출등급, 주문등급]
-- 매출등급: 총매출[0< c <= 1백 < b <= 3백 < A <= 5백 < S]
-- 주문등급: 주문건수 [ 0 <= C < 15 <= B < 30 <= A]
SELECT
	sales_rep AS 사원,
    SUM(total_amount) AS 총매출액,
    COUNT(*) AS 주문건수,
    AVG(total_amount) AS 평균주문액
FROM sales
GROUP BY sales_rep;

SELECT
	사원, 총매출액, 주문건수, 평균주문액,
    CASE
		WHEN 총매출액 >= 15000000 THEN 'S'
        WHEN 총매출액 >= 3000000 THEN 'A'
        WHEN 총매출액 >= 1000000 THEN 'B'
        ELSE 'C'
	END AS 매출등급,
    CASE
		WHEN 주문건수 >= 25 THEN 'A'
        WHEN 주문건수 >= 15 THEN 'B'
        ELSE 'C'
    END AS 주문등급
    FROM
    (SELECT
	sales_rep AS 사원,
    SUM(total_amount) AS 총매출액,
    COUNT(*) AS 주문건수,
    AVG(total_amount) AS 평균주문액
	FROM sales
	GROUP BY sales_rep) AS 사원별_분석