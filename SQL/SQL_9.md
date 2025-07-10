# window함수
- row_number() over(order by amount DESC) 전체순위라면, row_number() over(**partition by region** order by amount DESC) 지역 순위
    - partition by date_trunc('month', order_date): order_date에서 month단위로 잘라. 이런 것도 있군...

- 이동평균
    - avg(일매출) over(
		order by order_date
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW -- 앞에 6행+현재 행= 7
	)

- 위치 함수
    - LAG(월매출, 1) OVER (ORDER BY 월)
    : 월매출을 1칸 전, order by 정렬기준
    - LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date): 주문일 1칸 후, id로 나눠, 주문일 정렬 