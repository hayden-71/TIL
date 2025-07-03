-- 15-having
USE lecture;

SELECT
	category,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액
FROM sales
WHERE total_amount >= 100000
GROUP BY category;

-- WHERE / HAVING 차이점
SELECT
	category,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액
FROM sales
WHERE total_amount >= 1000000 -- 원본 데이터에 필터를 걸고, 그룹핑
GROUP BY category;

SELECT
	category,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액
FROM sales
GROUP BY category
HAVING 총매출액 >= power(10, 7); -- 피벗테이블에 필터를 건다

-- 복합 HAVING: 활성 지역 찾기(주문건수 >= 20, 고객수 >=15)
SELECT
	region AS 지역,
    COUNT(*) AS 주문건수,
    COUNT(DISTINCT customer_id) AS 고객수,
    SUM(total_amount) AS 총매출액,
    round(AVG(total_amount)) AS 평균주문액
FROM sales
GROUP BY region
HAVING 주문건수 >= 20 AND 고객수 >=15;

-- 우수 영업사원 => 달 평균 매출액이 50만원이상
SELECT
	sales_rep AS 영업사원,
    COUNT(*) AS 사원별판매건수,
    COUNT(DISTINCT customer_id) AS 'sales_rep 별 사원별고객수',
    SUM(total_amount) AS 사원별총매출,
	COUNT(DISTINCT DATE_format(order_date, '%Y-%m')) AS 활동개월수, -- 날짜 쓰는거 헷갈림
    ROUND
		(SUM(total_amount) / COUNT(DISTINCT DATE_format(order_date, '%Y-%m')) 
        )AS 월평균매출
FROM sales
GROUP BY sales_rep
HAVING 월평균매출 >= 500000
ORDER BY 월평균매출 DESC;

