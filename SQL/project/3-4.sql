-- 국가별 재구매율(Repeat Rate)

-- 각 국가별로 전체 고객 수, 2회 이상 구매한 고객 수, 재구매율을 구하세요.
-- 결과는 재구매율 내림차순 정렬.

-- 국가별로 고객수 count
SELECT
	i.billing_country,
	count(c.customer_id)
FROM invoices i
INNER JOIN customers c ON c.customer_id = i.customer_id
GROUP BY billing_country
WHERE i.total >= 2
LIMIT 5;

-- ----------

WITH CustomerInvoiceCounts AS (
    -- 각 고객별로 총구매수를 계산합니다.
    SELECT
        customer_id,
        COUNT(invoice_id) AS 구매횟수 -- 각 고객이 구매한 횟수
    FROM invoices
    GROUP BY customer_id
),
CountryInfo AS (
    -- 고객의 국가 정보와 위에서 계산한 구매 횟수를 연결합니다.
    SELECT
        c.customer_id,
        c.country AS customer_country,
        cic.구매횟수
    FROM customers c
    INNER JOIN CustomerInvoiceCounts cic ON c.customer_id = cic.customer_id
),
counting as (
SELECT
    ci.customer_country,
    COUNT(DISTINCT ci.customer_id) AS 국가별고객수,
    COUNT(DISTINCT CASE WHEN ci.구매횟수 >= 2 THEN ci.customer_id END) AS 재구매고객수
FROM CountryInfo ci
GROUP BY ci.customer_country
ORDER BY ci.customer_country
)
SELECT
*,
(재구매고객수/국가별고객수)*100 as 재구매율
FROM counting;