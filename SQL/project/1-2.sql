-- 모든 앨범과 해당 아티스트 이름 출력
-- 각 앨범의 title과 해당 아티스트의 name을 출력하고, 앨범 제목 기준 오름차순 정렬하세요.

SELECT
	a.title,
	b.name
FROM albums a
INNER JOIN artists b ON b.artist_id = a.artist_id
ORDER BY a.title ASC
