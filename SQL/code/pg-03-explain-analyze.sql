-- pg-03-explain-analyze

-- 실행 계획을 보자
EXPLAIN
SELECT * FROM large_customers WHERE customer_type='VIP';

-- Seq Scan on large_customers  (cost=0.00 .. 3746.00 rows반환행수=10210 width한줄평균용량=160byte)
-- cost = 낮을수록 좋은 점수 / rows * width = 총 메모리 사용량
--   Filter: (customer_type = 'VIP'::text)

-- 실행 + 통계
EXPLAIN ANALYZE
SELECT * FROM large_customers WHERE customer_type='VIP';

-- "Seq Scan on large_customers  (cost=0.00..3746.00 rows=10210 width=160)
-- 실제시간 (actual time=0.146..16.321 rows=9955 loops=1 한번 실행됐다)"
-- Seq scan
-- 인덱스 없고
-- 테이블 대부분의 행을 읽어야 하고
-- 순차 스캔이 빠를 때 자동적으로 시퀀스 스캔을 함


-- EXPLAIN 옵션들

-- 버퍼 사용량 포함
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- 상세 정보 포함(수다스러움)
EXPLAIN (ANALYZE, VERBOSE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- JSON 형태
EXPLAIN (ANALYZE, VERBOSE, BUFFERS, FORMAT JSON)
SELECT * FROM large_customers WHERE loyalty_points > 8000;


-- 진단
EXPLAIN ANALYZE
SELECT
	c.customer_name,
	COUNT(o.order_id)
FROM large_customers c
LEFT JOIN large_orders o ON c.customer_name = o.customer_id -- 잘못된 join 조건
GROUP BY c.customer_name;



