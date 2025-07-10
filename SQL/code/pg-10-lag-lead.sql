-- pg-10-lag-lead

-- LAG() - 이전 값을 가져온다.
-- 전월 대비 매출 분석

-- 매달 매출을 확인
-- 위 테이블의 증감률 컬럼 추가

WITH monthly_sales AS (
	SELECT
		date_trunc('month', order_date) as 월,
		sum(amount) as 월매출
	FROM orders
	GROUP by 월
),
with 월매출변화 as (
SELECT
	to_char(월, 'YYYY-MM') as 년월,
	월매출,
	LAG(월매출, 1) OVER (ORDER BY 월) as 전월매출
from monthly_sales
ORDER by 월
)

SELECT
	월매출 - 전월매출 as 증감액,
	case
		WHEN 전월매출 IS NULL THEN NULL -- 이렇게 표시해야 계산을 안 하니까
		ELSE round(
			(월매출 - 전월매출) *100 -- 매출변동
			/ 
			전월매출 -- 저번달
			, 2)::text || '%' 
			END as 증감률
from 월매출변화;


-- 고객별 다음 구매를 예측?
-- [고객id, 주문일, 구매액, 다음구매일, 구매간격(일수), 다음구매액수, 금액차이]
-- 고객별로 파티션 필요
-- order by customer_id, order_date LIMIT 10

SELECT
	customer_id,
	order_date,
	amount,
	LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
	LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매금액
FROM orders
ORDER BY customer_id, order_date ;


-- [고객id, 주문일, 금액, 구매 순서(ROW_NUMBER),
--	이전구매간격, 다음구매간격
-- 금액변화=(이번-저번), 금액변화율
-- 누적 구매 금액(SUM OVER)
-- [추가]누적 평균 구매 금액 (AVG OVER)

WITH 구매예측 as (
SELECT
	customer_id as id,
	row_number() over(partition by customer_id order by order_date) as 구매순서, -- 이거 약간 헷갈림
	order_date as 주문일,
	amount as 구매액,
	LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매일,
	LEAD(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 다음구매금액,
	LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 이전구매일,
	LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS 이전구매금액
from orders
)
SELECT
	*,
	주문일-이전구매일 as 이전구매간격,
	다음구매일-주문일 as 다음구매간격,
	구매액-이전구매금액 as 이전금액, -- 이번에 더 많이 샀으면 +가 나와야 하니까 순서~~!
	CASE
		when 이전구매금액 IS NULL THEN NULL
		else round((구매액-이전구매금액)*100 / 이전구매금액, 2)::text||'%'
	end as 금액변화율, -- 각 구매마다의 변화율
	-- 누적 구매 통계
	sum(구매액) over(partition by id order by 주문일) as 누적구매금액,
	avg(구매액) over(partition by id order by 주문일
		-- ROWS between unbounded preceding and current row 현재 행~ 맨앞까지.... 혹시 보게 되면 알아라~!
		-- ROWS between 2 preceding and current row 현재 행 포함 총 3개
		) as 누적평균금액,
	-- 고객 구매 단계 분류
	CASE
		when 구매순서 = 1 THEN '첫구매'
		when 구매순서 <= 3 THEN '초기고객'
		when 구매순서 <= 10 THEN '일반고객'
		else 'vip고객'
	END AS 고객단계
FROM 구매예측
order by id, 주문일
-- 한명씩 보고 싶으면 WHERE id='CUST-00001'
limit 10






