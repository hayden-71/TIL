-- pg-05-various-index

-- data structure (graph, tree, list, hash)

-- B-Tree 인덱스 생성 (기본값)
CREATE INDEX <index_name> ON <table_name>(<col_name>)
-- 범위 검색 BETWEEN, >, <
-- 정렬 ORDER BY
-- 부분 일치 LIKE

-- Hash 인덱스
CREATE INDEX <index_name> ON <table_name> USING hash(<col_name>)
-- 정확한 일치 검색 =
-- 범위, 정렬 X

-- 부분 인덱스
CREATE INDEX <index_name> ON <table_name>(<col_name>)
WHERE 조건='blah'
-- 특정 조건의 데이터만 자주 검색한다
-- 공간/비용 절약 됨


-- 인덱스를 사용 못하는 경우
-- 함수 사용
SELECT * FROM users WHERE UPPER(name) = 'JOHN'
-- 타입 변환 (age는 숫자인데 문자 넣음)
SELECT * FROM users WHERE age='25'
-- 앞쪽 와일드 카드
SELECT * FROM users WHERE LIKE='%김'
-- 부정 조건
SELECT * FROM users WHERE age != 25

-- 해결방법
-- 함수기반 인덱싱
