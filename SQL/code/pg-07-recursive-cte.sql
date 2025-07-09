-- pg-07-recursive-cte.sql
-- recursive 재귀

WITH RECURSIVE numbers AS (
	-- 초기값
	select 1 as num
	-- 
	UNION ALL
	-- 재귀부분
	select num + 1
	FROM numbers
	WHERE num < 10 -- 종료시키는 부분
)
SELECT * FROM numbers;

SELECT * FROM employees;

WITH RECURSIVE org_chart AS (
	SELECT 
		employee_id,
		employee_name,
		manager_id,
		department,
		1 AS 레벨,
		employee_name::text AS 조직구조
	FROM employees
	WHERE manager_id IS NULL -- >여기까지 한 줄. 시작포인트를 만든 것!
	UNION ALL -- 상하로 합쳐. 중복이 있어도 가져와.
	SELECT 
		e.employee_id,
		e.employee_name,
		e.manager_id,
		e.department,
		oc.레벨 + 1,
		(oc.조직구조 || '>>' || e.employee_name)::text
	FROM employees e
	INNER JOIN org_chart oc ON e.manager_id=oc.employee_id -- 1줄(CEO)가 내 상사인 사람들(조건을 만족할 때까지)
)
SELECT * FROM org_chart
order by 레벨;

SELECT 'a'||'b'; -- 파이프는 걍 concat 같은거







