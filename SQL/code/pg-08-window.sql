-- pg-08-window.sql
-- window 함수 -> OVER() 구문

-- 전체구매액 평균
SELECT AVG(amount) FROM orders;
-- 고객별 구매액 평균
SELECT
	customer_id,
	AVG(amount)
FROM orders
GROUP BY customer_id;

-- 각 데이터와 전체 평균을 동시에 확인
SELECT
	order_id,
	customer_id,
	amount,
	AVG(amount)	OVER() as 전체평균
FROM orders
LIMIT 10;

-- ROW_NUMBER() -> 줄세우기 [ROW_NUMBER() OVER(ORDER BY 정렬기준)]
-- 주문 금액이 높은 순서로
SELECT
	order_id,
	customer_id,
	amount,
	ROW_NUMBER() OVER (ORDER BY amount DESC) as 호구번호
FROM orders
ORDER BY 호구번호
LIMIT 20 OFFSET 40; -- offset 얼마나 건너뛰고 가져올지

-- 연습) 주문 횟수가 많은 순서 + 주문한 상품들
with 주문횟수 as (
SELECT
	customer_id,
	count(order_id) as 총주문횟수
FROM orders
group by customer_id
order by 총주문횟수 DESC
)
SELECT
	o.customer_id,
	총주문횟수,
	p.product_name
from orders o
left join products p on o.product_id = p.product_id
inner join 주문횟수 C on C.customer_id= o.customer_id
order by 총주문횟수 DESC, customer_id;

-- 주문 날짜가 최신인 순서대로 번호 매기기
SELECT
	order_id,
	customer_id,
	amount,
	order_date,
	ROW_NUMBER() OVER (ORDER BY order_date DESC) as 최신주문순서,
	RANK() OVER (ORDER BY order_date DESC) as 랭크,
	DENSE_RANK() OVER (ORDER BY order_date DESC) as 덴스랭크
FROM orders
ORDER BY 최신주문순서
LIMIT 20;


-- 7월 매출 TOP 3 고객 찾기
-- [이름, (해당고객)7월구매액, 순위]
-- CTE
-- 1. 고객별 7월의 총구매액 구하기 [고객id, 총구매액]
-- 2. 기존 컬럼에 번호 붙이기 [고객id, 구매액, 순위]
-- 3. 보여주기

WITH july_sales AS (
	SELECT
		customer_id,
		SUM(amount) AS 월구매액
	FROM orders
	WHERE order_date BETWEEN '2024-07-01' AND '2024-07-31'
	GROUP BY customer_id
),
ranking AS (
	SELECT
		customer_id,
		월구매액,
		ROW_NUMBER() OVER(ORDER BY 월구매액 DESC) AS 순위
	FROM july_sales
)
SELECT
	r.customer_id,
	c.customer_name,
	r.월구매액,
	r.순위
FROM ranking r
INNER JOIN customers c ON r.customer_id=c.customer_id
WHERE r.순위 <= 10;



-- 각 지역에서 총구매액 1위 고객 => ROW_NUMBER() 로 숫자를 매기고, 이 컬럼의 값이 1인 사람
-- [지역, 고객이름, 총구매액]
-- CTE
-- 1. 지역-사람별 "매출 데이터" 생성 [지역, 고객id, 이름, 해당 고객의 총 매출]
-- 2. "매출데이터" 에 새로운 열(ROW_NUMBER) 추가

with region_customer as (
SELECT
	c.region as 지역,
	c.customer_id as id,
	c.customer_name as 고객명,
	sum(o.amount) as 총구매액
FROM orders o
INNER join customers c ON c.customer_id = o.customer_id
GROUP by c.region, c.customer_id, c.customer_name
),
매출데이터 as(
SELECT -- FROM 테이블에서 가져올 수 있는것만!!
	 지역,
	 고객명,
	 총구매액,
	 row_number() over(partition by 지역 order by 총구매액 DESC) as 순위
FROM region_customer rc
)
SELECT 지역, 고객명, 총구매액, 순위
FROM 매출데이터
WHERE 순위 = 1
 ;

