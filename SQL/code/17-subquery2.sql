-- 17-subquery2
USE lecture;
-- Scala -> 한개의 데이터
-- Vector -> 한줄로 이루어진 데이터
-- Matrix -> 행과 열로 이루어진 데이터
SELECT * FROM customers;

-- 1. 모든 VIP의 id
SELECT customer_id FROM customers WHERE customer_type = 'VIP';

-- [모든 VIP]의 주문내역
select *
from customers
where customer_type = 'vip';

SELECT * -- 비효율
FROM sales
WHERE customer_id IN ('c001', 'c005');

SELECT *
FROM sales
WHERE customer_id IN (
	SELECT customer_id FROM customers 
    WHERE customer_type = 'VIP'
)
ORDER BY total_amount DESC;


-- 2. [전자제품을 구매한] 고객들의 모든 주문
SELECT DISTINCT customer_id FROM sales WHERE category='전자제품';

SELECT * FROM sales
WHERE customer_id IN (       				-- 구매했던적이 있는 사람들 넣기
	SELECT DISTINCT customer_id 
    FROM sales WHERE category='전자제품' )
ORDER BY customer_id, total_amount DESC;
