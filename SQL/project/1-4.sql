-- 국가별 고객 수 집계
-- 각 국가(country)별로 고객 수를 집계하고, 고객 수가 많은 순서대로 정렬하세요.

SELECT
	country,
	count(*) AS customer_count
FROM customers
GROUP by country
ORDER by count(*) DESC
limit 10