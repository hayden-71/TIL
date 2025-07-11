-- 각 고객의 최근 구매 내역
-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.

-- 서브쿼리 조인

SELECT
	i.customer_id, i.invoice_id, i.invoice_date, i.total
FROM invoices i
INNER JOIN (
			select
				customer_id,
				max(invoice_date) as max
			from invoices
			group by customer_id
			order by max(invoice_date) DESC
)as lately
on i.customer_id=lately.customer_id
	AND i.invoice_date=lately.max
GROUP BY i.customer_id, i.invoice_id, i.invoice_date, i.total
limit 5;



SELECT i.customer_id, i.invoice_id, i.invoice_date, i.total
FROM invoices i
WHERE i.invoice_date = (
    SELECT MAX(invoice_date)
    FROM invoices
    WHERE customer_id = i.customer_id
);





-- 윈도우 함수
SELECT
    customer_id, invoice_id, invoice_date, total
FROM (
    SELECT
        customer_id,
        invoice_id,
        invoice_date,
        total,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY invoice_date DESC, invoice_id DESC) as rn
    FROM invoices
) AS ranked_invoices
WHERE
    rn = 1
limit 10;