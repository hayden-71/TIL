-- 장르별 상위 3개 아티스트 및 트랙 수

-- 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(artist_id, name, track_count)를 구하세요.
-- 동점일 경우 아티스트 이름 오름차순 정렬.

-- 장르별 트랙수 정렬

WITH genre_artist_track AS (
	SELECT
		g.name as genre,
		art.name,
		art.artist_id,
		count(t.track_id) as 트랙수
	FROM genres g
	INNER JOIN tracks t ON t.genre_id = g.genre_id
	INNER JOIN albums a ON a.album_id = t.album_id
	INNER JOIN artists art ON art.artist_id = a.artist_id
	GROUP BY genre, art.name, art.artist_id
	Order by 트랙수 DESC
),
ranked AS (
	SELECT
		*,
		ROW_NUMBER() over(partition by genre order by 트랙수 DESC) as 순위
	FROM genre_artist_track
)
	SELECT
	*
	FROM ranked
WHERE 순위 <= 3
order by genre DESC, 트랙수 DESC;





RankedArtists AS (
    SELECT
        genre_name,
        artist_id,
        artist_name,
        track_count,
        -- 각 장르 내에서 트랙 수 기준 내림차순, 아티스트 이름 기준 오름차순으로 순위 부여
        ROW_NUMBER() OVER (PARTITION BY genre_name ORDER BY track_count DESC, artist_name ASC) AS rn
    FROM
        ArtistTrackCounts
)
SELECT
    genre_name,
    artist_id,
    artist_name,
    track_count
FROM
    RankedArtists
WHERE
    rn <= 3 -- 순위가 3위 이하인 아티스트만 선택 (상위 3명)
ORDER BY
    genre_name ASC,    -- 장르 이름 오름차순 정렬
    track_count DESC,  -- 해당 장르 내에서 트랙 수 내림차순 정렬
    artist_name ASC;   -- 트랙 수가 같으면 아티스트 이름 오름차순 정렬