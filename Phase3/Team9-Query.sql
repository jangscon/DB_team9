--Type 1
SELECT c.channel_id
  FROM channel c
 WHERE c.channel_name LIKE ?
   AND c.channel_name LIKE ?
    OR c.description LIKE ?
   AND c.description LIKE ?;

--Type 2
  SELECT g.genre_name
    FROM channel c, has h, genre g
   WHERE c.channel_id = h.channel_id
     AND h.genre_num = g.genre_num
     AND c.channel_id = ?
ORDER BY g.genre_name;

--Type 4
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

--Type 5
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

--Type 6
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y
 WHERE c.youtuber_id = y.youtuber_id
   AND c.channel_id IN (
SELECT c.channel_id
  FROM channel c
 WHERE c.subscriber_num > ?
   AND c.subscriber_num < ?);

--Type 7
  WITH id_total_views AS (
SELECT c.channel_id
  FROM channel c
 WHERE c.total_views > ?
   AND c.total_views < ?)
SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description
  FROM channel c, youtuber y, id_total_views i
 WHERE c.youtuber_id = y.youtuber_id
   AND c.channel_id = i.channel_id;

--Type 8
  SELECT p2.name, p2.character
    FROM channel c, participation p1, performer p2
   WHERE c.channel_id = p1.channel_id
     AND p1.performer_id = p2.performer_id
     AND c.channel_id = ?
ORDER BY p2.name;

--Type 10
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