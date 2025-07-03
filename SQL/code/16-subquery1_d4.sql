-- 16-subquery-basic day4
USE lecture;

-- 서브 쿼리
-- 1.［매출 평균］보다 더 높은 금액을 주문한 판매데이터 (*) 보여줘
SELECT AVG(total_amount) FROM sales;  -- 매출평균
SELECT * FROM sales WHERE total_amount > 612862;  -- 이 수식 문제점? 매출값이 달라질 경우, 어떻게 할 건디..

SELECT * FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales);

-- 2. [평균매출보다 더 주문한] 금액 차이
SELECT
	product_name AS 이름,
    total_amount AS 판매액수,
    Round(total_amount - (SELECT AVG(total_amount) FROM sales), 0) AS 평균차이
FROM sales
-- 평균보다 더 주문한 (총매출액>평균매출액)
WHERE total_amount > (SELECT AVG(total_amount) FROM sales);


-- 3. [sales에서 가장 비싼] 주문
SELECT MAX(total_amount) FROM sales;
-- SELECT * FROM sales ORDER BY total_amount DESC LIMIT 1 -이건 효율의 문제.. 전체를 n번 정렬해서 가져온것

SELECT *
FROM sales
WHERE total_amount = (SELECT MAX(total_amount) FROM sales);


-- 4. [가장 최근 주문일]의 주문데이터
SELECT MAX(order_date) FROM sales;

SELECT *
FROM sales
WHERE order_date = (SELECT MAX(order_date) FROM sales);

-- 5. [주문액수 평균]과 가장 유사한 주문데이터 5개 (값이 +일수도 -일수도 있음. 절대값 써야...)
SELECT AVG(total_amount) FROM sales;

SELECT 
	customer_id,
    product_name,
    order_date,
    total_amount,
    ABS((SELECT AVG(total_amount) FROM sales) - total_amount) AS 평균과의차이
FROM sales
ORDER BY 평균과의차이
LIMIT 5;