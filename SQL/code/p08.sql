USE practice;
CREATE TABLE sales AS SELECT * FROM lecture.sales;
CREATE TABLE products AS SELECT * FROM lecture.products;

-- 단일값 서브쿼리
-- 1-1. 평균 이상 매출 주문들 (성과가 좋은 주문들)
-- 평균
SELECT AVG(total_amount) FROM sales;
-- 평균 이상 주문들
SELECT * FROM sales
WHERE total_amount >= (SELECT AVG(total_amount) FROM sales);

-- 1-2. 최고 매출 지역|의 모든 주문들
	-- 최고 매출 지역? -- 각 지역별 매출 총합
SELECT region, SUM(total_amount)
FROM sales
GROUP BY region;

SELECT region  -- 대구
FROM sales
GROUP BY region
ORDER BY SUM(total_amount) DESC LIMIT 1;

SELECT * FROM sales
WHERE region = (최고매출지역);

-- --------------------------------------------------------- 아래로는.. 고민의 흔적..
SELECT 					-- 이렇게 쓰니까 지역별 최고매출이 나오잖여... 
	region AS 지역,
	MAX(total_amount) AS 지역별최고매출
FROM sales
GROUP BY region;

-- 최고 매출
SELECT MAX(total_amount) FROM sales;
-- 지역
SELECT region, total_amount
FROM sales
WHERE total_amount = (SELECT MAX(total_amount) FROM sales);

SELECT * FROM sales
WHERE region IN (SELECT region FROM sales WHERE total_amount = (SELECT MAX(total_amount) FROM sales));


-- 여러데이터(벡터) 서브쿼리
-- 2-2. 재고부족(50개 미만)| 제품의 매출 내역
SELECT * FROM products -- > *를 products_name으로 바꿔
WHERE stock_quantity < 50;

SELECT * FROM sales
WHERE product_name IN (
SELECT product_name FROM products
WHERE stock_quantity <50);

-- ----------------------------------------------- 고민의 흔적들..
SELECT quantity FROM sales WHERE quantity < 50 ;
SELECT 
	product_name AS 제품명,
    total_amount AS 매출내역
FROM sales
WHERE quantity IN (SELECT quantity FROM sales WHERE quantity < 50 );


-- 2-3. 상위 3개 매출 지역의 주문들
-- 상위 매출 지역 3개
SELECT region FROM sales
GROUP BY region
ORDER BY SUM(total_amount) DESC
LIMIT 3;

SELECT * FROM sales
WHERE 

SELECT region FROM sales WHERE SUM(total_amount) = MAX(total_amount);

-- 2-4. 상반기(24-01-01~06-30)에 주문한 고객들의, 하반기 주문 내역
SELECT *,
'하반기주문' AS 구분
FROM sales
WHERE customer_id IN(
	SELECT DISTINCT customer_id FROM sales WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30')
AND order_date BETWEEN '2024-07-01' AND '2024-12-31'
ORDER BY customer_id, order_date;

SELECT DISTINCT customer_id FROM sales WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30';