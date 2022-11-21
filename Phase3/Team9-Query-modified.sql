--comments.comment_id 자동으로 순서를 매기기 위해 시퀀스 생성
--Team9-Phase2-1-modified.sql 파일에 추가하였음
CREATE SEQUENCE comments_seq START WITH 367;

--Type 1 수정
SELECT c.channel_id
  FROM channel c
 WHERE c.channel_name LIKE ?
   AND c.channel_name LIKE ?
    OR c.description LIKE ?
   AND c.description LIKE ?;

--Type 2 수정
  SELECT g.genre_name
    FROM channel c, has h, genre g
   WHERE c.channel_id = h.channel_id
     AND h.genre_num = g.genre_num
     AND c.channel_id = ?
ORDER BY g.genre_name;

--Type 3 수정
  SELECT c1.channel_id, AVG(r.rating)
    FROM channel c1, rating r, customer c2
   WHERE c1.channel_id = r.channel_id
     AND r.customer_id = c2.customer_id
GROUP BY c1.channel_id
  HAVING c1.channel_id = ?;

--Type 4 수정
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y
 WHERE c.youtuber_id = y.youtuber_id
   AND c.channel_id IN (
SELECT c.channel_id
  FROM channel c
 WHERE c.channel_name LIKE ?
   AND c.channel_name LIKE ?
    OR c.description LIKE ?
   AND c.description LIKE ?);

--Type 5 수정
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y
 WHERE c.youtuber_id = y.youtuber_id
   AND NOT EXISTS (
SELECT g.genre_num
  FROM genre g
 WHERE g.genre_name in (?, ?)
 MINUS
SELECT h.genre_num
  FROM has h
 WHERE c.channel_id = h.channel_id);

--Type 6 수정
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y
 WHERE c.youtuber_id = y.youtuber_id
   AND c.channel_id IN (
SELECT c.channel_id
  FROM channel c
 WHERE c.subscriber_num > ?
   AND c.subscriber_num < ?);

--Type 7 수정
  WITH id_total_views AS (
SELECT c.channel_id
  FROM channel c
 WHERE c.total_views > ?
   AND c.total_views < ?)
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y, id_total_views i
 WHERE c.youtuber_id = y.youtuber_id
   AND c.channel_id = i.channel_id;

--Type 8 수정
  SELECT p2.name, p2.character
    FROM channel c, participation p1, performer p2
   WHERE c.channel_id = p1.channel_id
     AND p1.performer_id = p2.performer_id
     AND c.channel_id = ?
ORDER BY p2.name;

--Type 9 수정
--comments 테이블과 recommendation 테이블을 join할 때
--추천 수가 0으로, recommendation 테이블에 존재하지 않는 comment도 반환되어야 하므로 LEFT OUTER JOIN을 사용하였고
--추천 수에 관련된 속성이 null인 행은 COUNT에 포함하지 않기 위해 COUNT(*) 대신 COUNT(r.customer_id) 사용
  SELECT c2.comment_id, c2.message, COUNT(r.customer_id) AS heart_num
    FROM channel c1, comments c2 LEFT OUTER JOIN recommendation r ON c2.comment_id = r.comment_id
   WHERE c1.channel_id = c2.channel_id
     AND c1.channel_id = ?
GROUP BY c2.comment_id, c2.message
ORDER BY heart_num DESC;

--Type 10 수정
   SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
     FROM channel c, youtuber y
    WHERE c.youtuber_id = y.youtuber_id
      AND c.channel_id IN (
   SELECT c.channel_id
     FROM channel c
    WHERE c.channel_name LIKE ?
      AND c.channel_name LIKE ?
       OR c.description LIKE ?
      AND c.description LIKE ?
INTERSECT
   SELECT c.channel_id
     FROM channel c
    WHERE c.subscriber_num > ?
      AND c.subscriber_num < ?
INTERSECT
   SELECT c.channel_id
     FROM channel c
    WHERE c.total_views > ?
      AND c.total_views < ?
INTERSECT
   SELECT c.channel_id
     FROM channel c, has h, genre g
    WHERE c.channel_id = h.channel_id
      AND h.genre_num = g.genre_num
      AND g.genre_name = ?
INTERSECT
   SELECT c.channel_id
     FROM channel c, has h, genre g
    WHERE c.channel_id = h.channel_id
      AND h.genre_num = g.genre_num
      AND g.genre_name = ?);