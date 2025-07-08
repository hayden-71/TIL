-- pg-04-index

-- 인덱스 조회
SELECT
	tablename,
	indexname,
	indexdef
FROM pg_indexes
WHERE tablename IN ('large_orders','large_customers');

ANALYZE large_orders;
ANALYZE large_customers;

-- 실제 운영에서는 X (캐시 날리기)
SELECT pg_stat_reset();

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE customer_id='cust-25000.' --37506 / 108.151ms

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE amount BETWEEN 800000 AND 1000000 -- 46296 / 266.395ms

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE region='서울' AND amount > 500000 AND order_date >= '2024-07-08'
; -- 39587 / 199.655ms

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE region='서울'
ORDER BY amount DESC -- 39802 / 131.839ms
LIMIT 100;


-- INDEX 추가하기
CREATE INDEX idx_orders_customer_id ON large_orders(customer_id);
CREATE INDEX idx_orders_amount ON large_orders(amount);
CREATE INDEX idx_orders_region ON large_orders(region);

-- 복합 INDEX
create index idx_orders_region_amount ON large_orders(region, amount);

explain analyze
select * from large_orders
where region = '서울' AND amount > 800000; -- 265 -> 131ms


create index idx_orders_id_order_date ON large_orders(customer_id, order_date);

explain analyze
select * from large_orders
where customer_id = 'CUST-25000.'
and order_date >= '2024-07-01'
order by order_date DESC; -- 0.144 -> 0.091ms

-- 복합 INDEX 순서도 영향을 미친다

-- INDEX 순서 가이드라인
-- 고유값이 많을 때
select
	count(distinct region) as 고유지역수,
	count(*) as 전체행수,
	round(count(distinct region)*100 / count(*), 2) as 선택도
from large_orders; -- 선택도 0.0007%

select
	count(distinct amount) as 고유금액수,
	count(*) as 전체행수
from large_orders; -- 선택도 99%


