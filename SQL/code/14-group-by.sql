-- 14-group-by 중복적으로 등장하는 애들을 그룹핑 하겠다

USE lecture;

-- 카테고리별 매출 (피벗테이블 행=카테고리, 값=매출액)
SELECT
	category AS 카테고리,  -- 그룹핑 기준인 얘가 없으면 표에서 읽기 어려워....
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출,
    AVG(total_amount) AS 평균매출
FROM sales
GROUP BY category -- 카테고리별로 묶어줘
ORDER BY 총매출 DESC;

-- 지역별 매출 분석
SELECT
	region AS 지역,
	COUNT(*) AS 주문건수,
    SUM(total_amount) AS 매출액,
    -- 지역별 고객수
    COUNT(DISTINCT customer_id) AS 고객수,
    COUNT(*)/COUNT(DISTINCT customer_id) AS 고객당주문수,
    ROUND(
		SUM(total_amount)/ COUNT(DISTINCT customer_id)) AS 고객당평균매출액
	-- SUM(IF(region='서울', total_amount, 0))/  COUNT(DISTINCT customer_id) AS 지역별고객당평균매출액 되나...?
FROM sales
GROUP BY region;

-- 다중 그룹핑
SELECT
	region AS 지역,
	category AS 카테고리,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액,
    round(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY region, category
ORDER BY 지역, 총매출액 DESC;

-- 영업사원 월별 성과
SELECT
	sales_rep,
    DATE_FORMAT(order_date, '%Y-%m') AS 월, -- 이걸 맨 앞으로 해도 보기 좋음
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 월매출액,
    format(SUM(total_amount), 0) AS easy월매출액,
    ROUND(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY sales_rep, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 월, 월매출액 DESC;

-- MAU 측정
SELECT
	DATE_FORMAT(order_date, '%Y-%m') AS 월,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 월매출액,
    COUNT(DISTINCT customer_id) AS 월활성고객수
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

-- 요일별 매출 패턴
SELECT
	DATE_FORMAT(order_date, '%W') AS 요일,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액,
    round(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY DATE_FORMAT(order_date, '%W')
ORDER BY 총매출액 DESC;

SELECT
	DAYNAME(order_date) AS 요일,
    DAYOFWEEK(order_date) AS 요일번호,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액,
    round(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY 요일, 요일번호
ORDER BY 요일 DESC;