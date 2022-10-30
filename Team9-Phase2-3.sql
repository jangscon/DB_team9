--1)
--구독자 수가 100만명 이상인 채널의 채널 이름과 채널 설명을 반환
SELECT  c.channel_name, c.description
FROM    channel c
WHERE   c.subscriber_num >= 1000000
ORDER BY    c.channel_name;

--2)
--평점 1점을 준 사용자의 닉네임과 그 채널 이름을 반환
SELECT  u.nickname, c.channel_name
FROM    customer u, rating r, channel c
WHERE   u.customer_id = r.customer_id
AND     r.channel_id = c.channel_id
AND     r.rating = 1
ORDER BY    c.channel_name;

--3)
--댓글이 작성된 채널 이름, 댓글의 내용, 추천 수를 반환
SELECT      c.channel_name, m.message, count(*) AS heart_num
FROM        recommendation r, comments m, channel c
WHERE       r.comment_id = m.comment_id
AND         m.channel_id = c.channel_id
GROUP BY    c.channel_name, m.message
ORDER BY    c.channel_name, m.message;

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
        AND     c1.channel_name = '총몇명'
    )
    INTERSECT
    (
        SELECT  g2.genre_num
        FROM    channel c2, genre g2, has h2
        WHERE   c2.channel_id = h2.channel_id
        AND     g2.genre_num = h2.genre_num
        AND     c2.channel_name = '장삐쭈'
    )
);