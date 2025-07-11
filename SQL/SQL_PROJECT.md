# 프로젝트 데이,,
- 1, 2 문제는 쉬웠음
- 특히나 3-4, 3-5는 머리 터짐

상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요

PERCENT_RANK() OVER(order by 누적),
	CASE
	WHEN PERCENT_RANK() OVER(order by 누적) >= 0.8 THEN 'VIP'
	WHEN PERCENT_RANK() OVER(order by 누적) >= 0.2 THEN 'LOW'
	ELSE 'Normal'
	END as 등급

- 최적화는 다음 기회에....