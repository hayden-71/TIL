-- 29-exists

-- 전자제품을 구매(sales)한 고객 정보(customers)
SELECT
	customer_id, customer_name, customer_type
FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM sales WHERE category='전자제품'); -- 1, 2, 3, 4, 5, 6 전부 불러와서 하나씩 대조
    
-- EXISTS 가져와서 찾는게 아니라, 전자제품 산적 있어 없어!! 효율이 좋다
SELECT
	customer_id, customer_name, customer_type
FROM customers c
WHERE EXISTS (
	SELECT 1 FROM sales s WHERE s.customer_id=c.customer_id
    AND s.category ='전자제품');

-- EXITS (~한 적이 있는)
-- 전자제품과 의류를 모두 구매해본적이 있고, 50만원 이상 구매 이력도 가진 고객을 찾자
SELECT *
FROM customers c
WHERE
	EXISTS (SELECT 1 FROM sales s1 WHERE s1.customer_id=c.customer_id AND s1.category='전자제품')
    AND
    EXISTS (SELECT 1 FROM sales s2 WHERE s2.customer_id=c.customer_id AND s2.category='의류')
	AND
    EXISTS (SELECT 1 FROM sales s3 WHERE s3.customer_id=c.customer_id AND s3.total_amount >= 500000);

-- 다른 방법
SELECT c.customer_id, c.customer_name
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE s.category IN ('전자제품', '의류') -- 전자제품 또는 의류 구매 이력 필터링 (초벌)
GROUP BY c.customer_id, c.customer_name
HAVING
    COUNT(DISTINCT CASE WHEN s.category = '전자제품' THEN 1 ELSE NULL END) > 0 -- 전자제품 구매 이력 확인
    AND COUNT(DISTINCT CASE WHEN s.category = '의류' THEN 1 ELSE NULL END) > 0 -- 의류 구매 이력 확인
    AND SUM(s.total_amount) >= 500000; -- 총 구매액 50만원 이상 확인

