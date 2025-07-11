-- 월별 매출 및 전월 대비 증감률

-- 각 연월(YYYY-MM)별 총 매출과, 전월 대비 매출 증감률을 구하세요. LAG?
-- 결과는 연월 오름차순 정렬하세요.

WITH monthly_sales AS (
	SELECT
		DATE_TRUNC('month', invoice_date) AS 월,
		SUM(total) as 월매출
	FROM invoices
	GROUP BY 월
	ORDER BY 월
),
before AS (
	SELECT
		TO_CHAR(월, 'YYYY-MM') as 연월,
		월매출,
		LAG(월매출, 1) over(order by 월) as 지난달
	FROM monthly_sales
)
 SELECT
	월매출,
	월매출 - 지난달 as 증감액,
	CASE
		WHEN 지난달 IS NULL THEN NULL
		ELSE ROUND((월매출 - 지난달) * 100 / 지난달, 2)::TEXT || '%'
	END AS 증감률
FROM before
ORDER BY 연월 ASC
;
