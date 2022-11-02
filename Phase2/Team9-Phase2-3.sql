--1)
--구독자 수가 100만명 이상인 채널의 채널 이름과 채널 설명을 반환
SELECT  c.channel_name, c.description
FROM    channel c
WHERE   c.subscriber_num >= 1000000
ORDER BY    c.channel_name;

-- gmail을 사용하는 유저의 이름, 닉네임 , 이메일을 출력
SELECT u.name , u.nickname , u.email
FROM CUSTOMER u
WHERE u.email LIKE '%@gmail.com';

--2)
--평점 1점을 준 사용자의 닉네임과 그 채널 이름을 반환
SELECT  u.nickname, c.channel_name
FROM    customer u, rating r, channel c
WHERE   u.customer_id = r.customer_id
AND     r.channel_id = c.channel_id
AND     r.rating = 1
ORDER BY    c.channel_name;

-- 	유튜브 채널중 코미디 장르를 가지고 있는 채널에서 활동하는 performer의 이름과 캐릭터 , 활동 채널 이름을 출력
SELECT DISTINCT c.channel_name , p.name , p.character
FROM CHANNEL c, PERFORMER p , HAS h , GENRE g , PARTICIPATION pa
WHERE c.channel_id = h.channel_id
AND h.genre_num = g.genre_num
AND g.genre_name = 'Comedy'
AND pa.channel_id = c.channel_id
AND pa.performer_id = p.performer_id;

--3)
--댓글이 작성된 채널 이름, 댓글의 내용, 추천 수를 반환
SELECT      c.channel_name, m.message, count(*) AS heart_num
FROM        recommendation r, comments m, channel c
WHERE       r.comment_id = m.comment_id
AND         m.channel_id = c.channel_id
GROUP BY    c.channel_name, m.message
ORDER BY    c.channel_name, m.message;

-- 	10개 이상의 채널에서 사용된 장르의 이름과 해당 장르를 가지는 채널 수 출력
SELECT g.genre_name , COUNT(*)
FROM HAS h , GENRE g
WHERE h.genre_num = g.genre_num
GROUP BY g.genre_name
HAVING COUNT(*) >= 10;


--4)
--어떤 장르에 대해 평균보다 높은 평점을 준 사람을 장르 이름, 닉네임, 평점 순으로 반환
SELECT  g.genre_name, u.nickname, r.rating
FROM    customer u, rating r, channel c, genre g, has h
WHERE   u.customer_id = r.customer_id
AND     r.channel_id = c.channel_id
AND     c.channel_id = h.channel_id
AND     g.genre_num = h.genre_num
AND     r.rating > (
    SELECT  avg(r2.rating)
    FROM    rating r2, channel c2, has h2
    WHERE   r2.channel_id = c2.channel_id
    AND     c2.channel_id = h2.channel_id
    AND     h2.genre_num = h.genre_num
)
ORDER BY    g.genre_name, r.rating DESC;

-- 	모든 채널의 평균 구독자 수보다 구독자수가 크거나 같은 채널의 이름, 구독자 수를 출력
SELECT c.channel_name ,  c.subscriber_num
FROM CHANNEL c
WHERE c.subscriber_num >=
		(select AVG(subscriber_num)
		  from channel);


--5)
--채널의 장르로 'Makeup' 단 하나만을 가지는 채널의 ID, 이름, 구독자 수를 반환
SELECT  c.channel_id, c.channel_name, c.subscriber_num
FROM    channel c
WHERE   NOT EXISTS (
    (
        SELECT  *
        FROM    genre g1, has h1
        WHERE   c.channel_id = h1.channel_id
        AND     g1.genre_num = h1.genre_num
    )
    MINUS
    (
        SELECT  *
        FROM    genre g2, has h2
        WHERE   c.channel_id = h2.channel_id
        AND     g2.genre_num = h2.genre_num
        AND     g2.genre_name = 'Makeup'
    )
);


-- 구독자가 100만명 이상인 채널에 댓글은 단 사람의 닉네임과 채널이름 , 댓글내용을 중복없이 춣력
SELECT DISTINCT u.nickname , ch.channel_name , c.message
FROM COMMENTS c , CUSTOMER u , channel ch
WHERE c.customer_id = u.customer_id
    AND c.channel_id = ch.channel_id
    AND EXISTS (
            SELECT channel_id
			FROM channel
			WHERE subscriber_num >= 1000000
);

--6)
--장르 중 'Critics'가 포함된 채널에 작성된 댓글을 반환
SELECT  c.channel_name, m.message
FROM    comments m, channel c
WHERE   m.channel_id = c.channel_id
AND     c.channel_id IN (
    SELECT  c1.channel_id
    FROM    channel c1, genre g1, has h1
    WHERE   c1.channel_id = h1.channel_id
    AND     g1.genre_num = h1.genre_num
    AND     g1.genre_name = 'Critics'
)
ORDER BY    c.channel_name, m.message;

--	토탈뷰가 1억뷰 이상인 채널의 장르 이름을 중복없이 출력
SELECT distinct genre_name
FROM GENRE
WHERE genre_num IN
	(
		SELECT h.genre_num
		FROM HAS h , CHANNEL c
		WHERE h.channel_id = c.channel_id
			AND c.total_views >= 100000000

	);

--7)
--채널의 평가자 수가 가장 많은 채널(들)의 채널 이름, 설명, 평가자 수를 반환
WITH    number_of_evaluators AS
    (   SELECT  c.channel_id, count(*) AS number_of_evaluators
        FROM    channel c, rating r
        WHERE   c.channel_id = r.channel_id
        GROUP BY    c.channel_id)
SELECT  c1.channel_name, c1.description, n1.number_of_evaluators
FROM    channel c1, number_of_evaluators n1
WHERE   c1.channel_id = n1.channel_id
AND     n1.number_of_evaluators = (
    SELECT  max(n2.number_of_evaluators)
    FROM    number_of_evaluators n2)
ORDER BY    channel_name;


-- Actor 역을 맡고 있고 이름이 B로 시작하는 performer의 id와 이름을 출력
SELECT  performer_id, name
FROM (
	SELECT *
	FROM PERFORMER p
	WHERE p.character = 'Actor'
)
WHERE name LIKE 'B%';


--8)
--장르 이름에 'A, a'가 포함된 채널의 등장인물 중 이름에 'A, a'가 포함된 사람을 반환
--장르 이름에 모두 'A, a'가 포함되는 경우,
--중복 제거를 위해 SELECT에 장르 이름을 포함하지 않고, DISTINCT 사용
SELECT  DISTINCT c.channel_name, f.name
FROM    channel c, performer f, participation p, genre g, has h
WHERE   c.channel_id = p.channel_id
AND     c.channel_id = h.channel_id
AND     f.performer_id = p.performer_id
AND     g.genre_num = h.genre_num
AND     (f.name LIKE '%A%' OR f.name LIKE '%a%')
AND     (g.genre_name LIKE '%A%' OR g.genre_name LIKE '%a%')
ORDER BY    c.channel_name, f.name;


--유튜버와 그의 체널 이름 , 구독자수를 출력하고 구독자수를 내림차순으로 정렬한 후 출력한다.
SELECT channel_name , name  , subscriber_num
FROM CHANNEL c , YOUTUBER y
WHERE c.youtuber_id = y.youtuber_id
ORDER BY subscriber_num DESC;



--9)
--채널의 관리자 이름, 채널 이름, 총 조회수, 구독자 수, 평균 평점을 반환
--평균 평점 순으로 내림차순 정렬하되, 평점이 중복될 경우 채널 이름으로 사전순 정렬함
SELECT  y.name AS manager_name, c.channel_name, c.total_views, c.subscriber_num,
    round(avg(r.rating), 1) AS average_rating
FROM    rating r, channel c, youtuber y
WHERE   r.channel_id = c.channel_id
AND     c.youtuber_id = y.youtuber_id
GROUP BY    y.name, c.channel_name, c.total_views, c.subscriber_num
ORDER BY    round(avg(r.rating), 1) DESC, c.channel_name;

-- 장르이름과 장르마다 유튜브에 참여하고 있는 참여자의 숫자의 합을 출력하는데 숫자의 합을 내림차순으로 정렬해 출력
SELECT genre_name , COUNT(*)
FROM participation p , performer pf , channel c , has h , genre g
WHERE p.performer_id = pf.performer_id
	AND p.channel_id = c.channel_id
	AND h.channel_id = c.channel_id
 	AND h.genre_num = g,genre_num
GROUP BY genre_name
ORDER BY COUNT(*) DESC;


--10)
--'총몇명', '장삐쭈' 채널이 공통적으로 가지고 있는 장르의 이름을 반환
SELECT  g.genre_name
FROM    genre g
WHERE   g.genre_num in (
    (
        SELECT  g1.genre_num
        FROM    channel c1, genre g1, has h1
        WHERE   c1.channel_id = h1.channel_id
        AND     g1.genre_num = h1.genre_num
        AND     c1.channel_name = '�Ѹ��'
    )
    INTERSECT
    (
        SELECT  g2.genre_num
        FROM    channel c2, genre g2, has h2
        WHERE   c2.channel_id = h2.channel_id
        AND     g2.genre_num = h2.genre_num
        AND     c2.channel_name = '�����'
    )
);

-- 장르 이름의 길이가 6자 이상 , 7자 미만인 (오직 6자) 장르이름 출력
SELECT g.genre_name
FROM genre g
WHERE g.genre_num in (
	(
		SELECT *
		FROM genre g1
		WHERE LENGTH(g1.genre_name) >= 6
	)
	MINUS
	(
		SELECT *
		FROM genre g2
		WHERE LENGTH(g2.genre_name) < 7
	)
);
