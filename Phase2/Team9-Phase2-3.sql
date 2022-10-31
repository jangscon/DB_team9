--1)
--������ ���� 100���� �̻��� ä���� ä�� �̸��� ä�� ������ ��ȯ
SELECT  c.channel_name, c.description
FROM    channel c
WHERE   c.subscriber_num >= 1000000
ORDER BY    c.channel_name;

--2)
--���� 1���� �� ������� �г��Ӱ� �� ä�� �̸��� ��ȯ
SELECT  u.nickname, c.channel_name
FROM    customer u, rating r, channel c
WHERE   u.customer_id = r.customer_id
AND     r.channel_id = c.channel_id
AND     r.rating = 1
ORDER BY    c.channel_name;

--3)
--����� �ۼ��� ä�� �̸�, ����� ����, ��õ ���� ��ȯ
SELECT      c.channel_name, m.message, count(*) AS heart_num
FROM        recommendation r, comments m, channel c
WHERE       r.comment_id = m.comment_id
AND         m.channel_id = c.channel_id
GROUP BY    c.channel_name, m.message
ORDER BY    c.channel_name, m.message;

--4)
--� �帣�� ���� ��պ��� ���� ������ �� ����� �帣 �̸�, �г���, ���� ������ ��ȯ
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
--ä���� �帣�� 'Makeup' �� �ϳ����� ������ ä���� ID, �̸�, ������ ���� ��ȯ
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
--�帣 �� 'Critics'�� ���Ե� ä�ο� �ۼ��� ����� ��ȯ
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
--ä���� ���� ���� ���� ���� ä��(��)�� ä�� �̸�, ����, ���� ���� ��ȯ
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
--�帣 �̸��� 'A, a'�� ���Ե� ä���� �����ι� �� �̸��� 'A, a'�� ���Ե� ����� ��ȯ
--�帣 �̸��� ��� 'A, a'�� ���ԵǴ� ���,
--�ߺ� ���Ÿ� ���� SELECT�� �帣 �̸��� �������� �ʰ�, DISTINCT ���
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
--ä���� ������ �̸�, ä�� �̸�, �� ��ȸ��, ������ ��, ��� ������ ��ȯ
--��� ���� ������ �������� �����ϵ�, ������ �ߺ��� ��� ä�� �̸����� ������ ������
SELECT  y.name AS manager_name, c.channel_name, c.total_views, c.subscriber_num,
    round(avg(r.rating), 1) AS average_rating
FROM    rating r, channel c, youtuber y
WHERE   r.channel_id = c.channel_id
AND     c.youtuber_id = y.youtuber_id
GROUP BY    y.name, c.channel_name, c.total_views, c.subscriber_num
ORDER BY    round(avg(r.rating), 1) DESC, c.channel_name;

--10)
--'�Ѹ��', '�����' ä���� ���������� ������ �ִ� �帣�� �̸��� ��ȯ
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