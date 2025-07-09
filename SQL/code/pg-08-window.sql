-- pg-08-window
-- window 함수 -> over() 구문



-- row_number() -> 줄세우기 [ROW_NUMBER() OVER(ORDER BY 정렬기준)]
-- 주문 금액이 높은 순서로

-- 주문날짜 최신인 순서대로 번호 매기기
SELECT
	order_id,
	customer_id,
	order_date,
	row_number() over(order by order_date desc) as 최신주문, -- 무지성 정렬
	rank() over(order by order_date desc) as 랭크, 			-- 랭크
	dense_rank() over(order by order_date desc) as 덴스랭크	-- 밀집해서 다같이 1등, 다같이 2등
from orders
order by 최신주문
limit 30;




-- 7월 매출 TOP 3 고객 찾기
-- [이름, (해당고객)7월구매액, 순위]
-- CTE
-- 1. 고객별 7월의 총구매액 구하기 [고객id, 이름, 총구매액]
-- 2. 기존 컬럼에 번호 붙이기 [고객id, 이름, 구매액, 순위]
-- 3. 보여주기

SELECT

from orders o








-- 각 지역에서 총구매액 1위 고객

WITH regional_customer as (
SELECT
	c.customer_id as 아이디,
	c.region as 지역,
	sum(o.amount) as 고객별구매액
from customers c
inner join orders o ON o.customer_id = c.customer_id 
group by c.customer_id, c.region
)
SELECT
	아이디,
	지역,
	고객별구매액,
	rank() over(order by 고객별구매액 desc) as 랭크
from regional_customer rc
order by 랭크
;


