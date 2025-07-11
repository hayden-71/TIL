
-- 최근 1년(마지막 인보이스 기준 12개월) 동안,
-- 각 월별 신규 고객 수(new_customers),  -> 각 달마다 해당 달에 역대 최초 구매(Invoice 확인)한 고객
-- 해당 월에 구매한 기존 고객 수(retained_customers)를 구하세요.
-- (힌트: 고객별 첫 구매월과 인보이스월 비교, CTE 활용)

WITH first_invoice AS (
		SELECT
			customer_id,
			MIN(invoice_date) as 첫구매
		FROM invoices
		GROUP BY customer_id
), 
lately_invoice AS (
		SELECT
			MAX(invoice_date) as 마지막구매
		FROM invoices
),
recent_invoice as (SELECT
	i.invoice_id,
	i.customer_id,
	i.invoice_date as 구매일,
	DATE_TRUNC('month', i.invoice_date) as 기준,
	DATE_TRUNC('month', fi.첫구매) as 첫구매월
FROM invoices i
INNER JOIN first_invoice fi ON i.customer_id=fi.customer_id
CROSS JOIN lately_invoice li
WHERE
        i.invoice_date >= (li.마지막구매 - INTERVAL '12 months')
        AND i.invoice_date <= li.마지막구매
)
SELECT
	ri.기준,
	COUNT (distinct CASE
		WHEN date_trunc('month', ri.기준) = ri.첫구매월 THEN ri.customer_id
		END) as new_customers
FROM recent_invoice ri
GROUP BY ri.기준
;

COUNT(DISTINCT CASE -- 해당 월에 구매한 신규 고객 (해당 월에 첫 구매를 한 고객)
        WHEN DATE_TRUNC('month', ri.first_purchase_date) = ri.purchase_month THEN ri.customer_id
    END) AS new_customers,



WITH CustomerFirstPurchase AS (
    -- 1. 각 고객의 첫 구매일(최초 인보이스 날짜)을 찾습니다.
    SELECT
        customer_id,
        MIN(invoice_date) AS first_purchase_date
    FROM
        invoices
    GROUP BY
        customer_id
),
LastInvoiceDate AS (
    -- 2. 전체 데이터셋에서 가장 마지막 인보이스 날짜를 찾습니다.
    SELECT
        MAX(invoice_date) AS max_overall_invoice_date
    FROM
        invoices
),
RecentInvoices AS (
    -- 3. 마지막 인보이스 날짜 기준으로 최근 12개월(1년) 내의 인보이스만 필터링합니다.
    SELECT
        i.customer_id,
        i.invoice_id,
        i.invoice_date,
        cfp.first_purchase_date,
        DATE_TRUNC('month', i.invoice_date) AS purchase_month -- 구매 월 추출
    FROM
        invoices i
    INNER JOIN
        CustomerFirstPurchase cfp ON i.customer_id = cfp.customer_id
    CROSS JOIN
        LastInvoiceDate lid
    WHERE
        i.invoice_date >= (lid.max_overall_invoice_date - INTERVAL '12 months')
        AND i.invoice_date <= lid.max_overall_invoice_date
)
SELECT
    ri.purchase_month,
    COUNT(DISTINCT CASE -- 해당 월에 구매한 신규 고객 (해당 월에 첫 구매를 한 고객)
        WHEN DATE_TRUNC('month', ri.first_purchase_date) = ri.purchase_month THEN ri.customer_id
    END) AS new_customers,
    COUNT(DISTINCT CASE -- 해당 월에 구매한 기존 고객 (첫 구매일이 해당 월보다 이전인 고객)
        WHEN DATE_TRUNC('month', ri.first_purchase_date) < ri.purchase_month THEN ri.customer_id
    END) AS existing_customers
FROM
    RecentInvoices ri
GROUP BY
    ri.purchase_month
ORDER BY
    ri.purchase_month ASC;