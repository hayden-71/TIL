-- 23-one-to-many
USE lecture;

SELECT 
	c.customer_id, 
	c.customer_name,
    COUNT(s.id) AS 주문횟수,
    GROUP_CONCAT(s.product_name) AS 주문제품들 -- concatanate 글자끼리 더해
FROM customers c
LEFT JOIN sales s ON c.customer_id=s.customer_id -- 주문 안한 사람들도 보고 싶으니까 레프트조인
GROUP BY c.customer_id, c.customer_name;