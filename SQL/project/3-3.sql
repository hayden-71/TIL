-- 고객별 누적 구매액 및 등급 산출

-- 각 고객의 누적 구매액을 구하고, sum~~~~~~~
-- 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.
WITH sumover as (
SELECT
	customer_id,
	invoice_date,
	total,
	sum(total)as 누적
FROM invoices
GROUP BY customer_id, invoice_date, total
)
	SELECT
		customer_id,
		total,
	PERCENT_RANK() OVER(order by 누적),
	CASE
	WHEN PERCENT_RANK() OVER(order by 누적) >= 0.8 THEN 'VIP'
	WHEN PERCENT_RANK() OVER(order by 누적) >= 0.2 THEN 'LOW'
	ELSE 'Normal'
	END as 등급
FROM sumover
ORDER BY 누적 DESC
limit 10