-- pg-06-CTE
-- Common Table Expression -> 쿼리 속의 '이름이 있는' 임시 테이블

WITH avg_order AS (
	select avg(amount) as avg_amount
	FROM orders
)
SELECT c.customer_name, o.amount, ao.avg_amount -- PT
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN avg_order ao ON o.amount > ao.avg_amount
LIMIT 10;

-- 요구사항: 1. 각 지역별 고객 수와, 지역별 주문 수를 계산하세요
-- 2. 지역별 평균 주문 금액도 함께 표시하세요
-- 3. 고객 수가 많은 지역 순으로 정렬하세요

-- 지역별 고객 수 먼저 구하고
with region_summary as (
SELECT
 c.region as 지역명,
 count(Distinct c.customer_id) as 고객수,
 count(o.order_id) as 주문수,
 AVG(o.amount) as 평균주문금액
FROM customers c
LEFT join orders o ON c.customer_id = o.customer_id
GROUP BY c.region
)
SELECT
	지역명,
	고객수,
	주문수,
	ROUND(평균주문금액) AS 평균주문금액
FROM region_summary
ORDER BY 고객수 DESC
;

-- 1. 각 상품의 총 판매량과 총 매출액을 계산하세요
-- 2. 상품 카테고리별로 그룹화하여 표시하세요
-- 3. 각 카테고리 내에서 매출액이 높은 순서로 정렬하세요
-- 4. 각 상품의 평균 주문 금액도 함께 표시하세요

-- 힌트: 먼저 상품별 판매 통계를 CTE로 만들어보세요
-- products 테이블과 orders 테이블을 JOIN하세요
-- 카테고리별로 정렬하되, 각 카테고리 내에서는 매출액 순으로 정렬하세요

with 카테고리별 as (
SELECT
 p.category as 카테고리,
 p.product_name as 제품명,
 sum(o.quantity) as 총판매량,
 sum(o.amount) as 총매출액,
 avg(o.amount) as 평균주문금액
from products p
inner join orders o on p.product_id = o.product_id
group by p.category, p.product_name
)
SELECT
	카테고리, 제품명, 총판매량, 총매출액, 평균주문금액
from 카테고리별
order by 카테고리, 총매출액 desc;

-- 

WITH product_sales AS (
-- 상품별 판매통계
SELECT
 p.category AS 카테고리,
 p.product_name AS 제품명,
 p.price AS 상품가격,
 sum(o.quantity) AS 총판매량,
 sum(o.amount) AS 총매출액, 
 count(o.order_id) AS 주문건수,
 avg(o.amount) AS 평균매출액
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category, p.product_name, p.price
)
SELECT -- 프레젠테이션
	카테고리,
	제품명,
	총판매량, 
	총매출액,
	ROUND(평균매출액) as 평균매출액,
	주문건수,
	상품가격
FROM product_sales
order by 카테고리, 총매출액 DESC;



-- 카테고리별 매출 비중 분석
WITH product_sales AS ( -- with 이름 as 뽑을 데이터
	SELECT
 	 p.category AS 카테고리,
 	 p.product_name AS 제품명,
 	 p.price AS 상품가격,
 	 sum(o.quantity) AS 총판매량,
 	 sum(o.amount) AS 제품총매출액, 
 	 count(o.order_id) AS 주문건수,
 	 avg(o.amount) AS 평균매출액
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category, p.product_name, p.price
), 		-- 두번째 CTE 시작
category_total AS (
	select
		카테고리,
		sum(제품총매출액) AS 카테고리총매출액
	from product_sales -- 위에서 쓴 CTE를 바로 쓸 수 있다~~!!
	group by 카테고리
)
SELECT 	-- 프레젠테이션
	ps.카테고리,
	ps.제품명,
	ps.제품총매출액,
	ct.카테고리총매출액,
	round(ps.제품총매출액*100 / ct.카테고리총매출액, 2) as 카테고리매출비용
FROM product_sales ps
INNER JOIN category_total ct ON ps.카테고리=ct.카테고리
ORDER by ps.카테고리, ps.제품총매출액 DESC;




-- 고객 구매금액에 따라 vip / 일반 / 신규로 나누어 등급통계를 보자
-- [등급, 등급별 회원수, 등급별 구매액총합, 등급별 평균주문수]]
-- 상위 20%, 전체평균보다높음, 나머지 신규

-- 1. 고객별 총 구매 금액 + 주문수
WITH customer_total AS (
	SELECT
		customer_id,
		SUM(amount) as 총구매액,
		COUNT(*) AS 총주문수
	FROM orders
	GROUP BY customer_id
),
-- 2. 구매 금액 기준 계산
purchase_threshold AS (
	SELECT
		AVG(총구매액) AS 일반기준,
		-- 상위 20% 기준값 구하기
		PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY 총구매액) AS vip기준
	FROM customer_total
),
-- 3. 고객 등급 분류
customer_grade AS (
	SELECT
		ct.customer_id,
		ct.총구매액,
		ct.총주문수,
		CASE 
			WHEN ct.총구매액 >= pt.vip기준 THEN 'VIP'
			WHEN ct.총구매액 >= pt.일반기준 THEN '일반'
			ELSE '신규'
		END AS 등급
	FROM customer_total ct
	CROSS JOIN purchase_threshold pt -- 한개의 값에 모든 데이터들을 대치하고 싶어~
)
-- 4. 등급별 통계 출력
SELECT
	등급,
	COUNT(*) AS 등급별고객수,
	SUM(총구매액) AS 등급별총구매액,
	ROUND(AVG(총주문수), 2) AS 등급별평균주문수
FROM customer_grade
GROUP BY 등급









-- 내가 하다가 만 거.......... -> 합칠필요 없었음. Orders에 있음
WITH 고객별총구매금액 AS (
SELECT
	customer_id as 고객아이디,
	sum(amount) as 총구매액,
	count(distinct order_id) as 주문수
FROM orders
GROUP by customer_id
),

-- 구매금액기준 AS (
select
	count(고객별총구매금액.customer_id) as 고객수,
	COUNT(SUM(customer_id) * 0.20) as 상위20퍼,
	avg(총구매액) as 평균구매금액
FROM 고객별총구매금액;
),

고객등급분류 AS (
SELECT
	고객등급분류,
	case
	when A.총주문금액 >= 상위20퍼 THEN 'vip'
	when A.총주문금액 >= B.평균구매금액 THEN '일반'
	ELSE '신규'
	END AS 등급
FROM 고객별총구매금액 A, 구매금액기준계산 B
GROUP by 고객등급분류 C
)

SELECT
	C.등급,
	B.고객수
from A, B, 고객등급분류
group by C.등급, B.고객수;

