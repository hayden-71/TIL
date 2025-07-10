-- pg-11-ntile-percent
-- NTILE 균등하게 나누기 NTILE(4) 4등분

WITH customer_totals AS (
	SELECT
		customer_id,
		sum(amount) as 총구매금액,
		count(*) as 구매횟수
	from orders
	group by customer_id
),
customer_grade AS(
SELECT
	customer_id,
	총구매금액,
	구매횟수,
	NTILE(4) OVER(ORDER BY 총구매금액) AS 분위4,
	NTILE(10) OVER(ORDER BY 총구매금액) AS 분위10
FROM customer_totals
order by 총구매금액 DESC
)
SELECT
 c.customer_name,
 cg.총구매금액,
 cg.구매횟수,
 CASE
 	when 분위4=1 THEN 'BRONZE'
	when 분위4=2 THEN 'SLIVER'
	when 분위4=2 THEN 'GOLD'
	ELSE 'VIP'
 END AS 고객등급
from customer_grade cg
inner join customers c on cg.customer_id=c.customer_id;

-- PERCENT_RANK()
SELECT
	product_name,
	category,
	price,
	RANK() OVER(order by price) AS 가격순위,
	PERCENT_RANK() OVER(order by price) AS 백분위순위,
	CASE
		WHEN PERCENT_RANK() OVER(order by price) <= 0.9 THEN '최고가(상위10%)'
		WHEN PERCENT_RANK() OVER(order by price) <= 0.7 THEN '고가(상위30%)'
		WHEN PERCENT_RANK() OVER(order by price) <= 0.3 THEN '중간가(상위70%)'
		ELSE '저가(하위30%)'
	END AS 가격등급
FROM products;


-- 카테고리별 처음등장/마지막등장 (파티션에서의 최고/최저를 찾는 윈도우 함수)
SELECT
	category,
	product_name,
	price,
	FIRST_VALUE(product_name) over(
		partition by category
		order by price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING -- 파티션의 모든행을 봐라
	) AS 최고가상품명,
	FIRST_VALUE(price) over(
	partition by category
	order by price DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최고가격,
-- 
	LAST_VALUE(product_name) over(
		partition by category
		order by price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가상품명,
	LAST_VALUE(price) over(
	partition by category
	order by price DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가격
FROM products
