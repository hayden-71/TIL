USE lecture;
-- [VIP 고객들]의 구매 내역 조회 (고객명, 고객유형, 상품명, 카테고리, 주문금액)
SELECT *
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';


-- 각 등급별 구매액 평균
SELECT
  c.customer_type,
  AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;

-- 그룹핑은 유니크한 정보로는 의미 없음. 안 묶이니까~~
