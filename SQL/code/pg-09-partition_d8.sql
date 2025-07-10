-- pg-09-partition

-- 체육대회 1, 2, 3학년 -> 한번에!! "1학년 순위, 전체 순위"를 확인할 수 있다

SELECT 
	region,
	customer_id,
	amount,
	row_number() over(order by amount DESC) as 전체순위,
	row_number() over(partition by region order by amount DESC) as 지역순위
FROM orders
limit 10;


-- SUM() -> SUM() OVER()
-- 일별 누적 매출액

with daily_sales as (
	SELECT
		order_date,
		sum(amount) as 일매출
	from orders
	where order_date between '2024-06-01' and '2024-08-31'
	group by order_date
	order by order_date
)
SELECT
	order_date,
	일매출,
	-- 범위 내에서 '주문일을 기준으로' 계속 누적!
	sum(일매출) over(order by order_date) as 누적매출,
	-- 범위 내에서 PARTITION 바뀔 때 초기화 (지금은 'month' 단위!)
	sum(일매출) over(
		partition by date_trunc('month', order_date)
		order by order_date
		)as 월누적매출
from daily_sales;


-- AVG() OVER()
-- 일 매출 이동평균
with daily_sales as (
	SELECT
		order_date,
		sum(amount) as 일매출,
		count(*) as 주문수
	from orders
	where order_date between '2024-06-01' and '2024-08-31'
	group by order_date
	order by order_date)
SELECT 
	order_date,
	일매출,
	주문수,
	round(avg(일매출) over(
		order by order_date
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW -- 앞에 6행+현재 행= 7
	)) as 이동평균7일,
	round(avg(일매출) over(
		order by order_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	)) as 이동평균3일
FROM daily_sales;



-- 카테고리별 인기상품 top 5
WITH 카테고리별 as (
	SELECT
		p.category as 카테고리,
		p.product_id as id,
		p.product_name as 제품명,
		p.price as 제품가격,
		count(o.order_id) as 주문건수 -- 이 부분 빠뜨림
		sum(o.quantity) as 판매개수,
		sum(o.amount) as 총매출
	FROM products p
	LEFT JOIN orders o on p.product_id = o.product_id -- 판매가 아예 안 된 상품도 볼래!
	GROUP by p.category, p.product_id, p.product_name, p.price -- 제품명이 같은경우도 있잖아? id 다르니까 써주기~
),
ranked as(
SELECT
	*,
	row_number() over(PARTITION BY 카테고리 order by 총매출 DESC) AS 매출순위, -- 그냥 쭈루룩 번호 매기기
	dense_rank() over(PARTITION BY 카테고리 order by 판매개수 DESC) AS 판매순위 -- 같은값 있어도, 다음등수로 건너뛰지 x
FROM 카테고리별
)
SELECT -- pt부분이니까 확실하게 order by도 해주면 좋다~
 *
FROM ranked
WHERE 매출순위 <=5 ;








