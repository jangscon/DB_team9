실행 및 사용 방법:
	이클립스 프로젝트. Java SE 8, ojdbc8.jar 필요

	Username: university
	Password: comp322

	Team9-Phase2-1-modified.sql (DDL)
	Team9-Phase2-2.sql (INSERT)
	차례로 실행하여 DB 생성 후 사용

기능 설명:
	메인 페이지:
		전체 채널 리스트의 간략한 정보(채널 ID, 구독자 수, 총 조회수, 장르, 채널 이름)를 출력

		메뉴:
			1. 정렬 방식 변경 (채널 이름 사전순, 구독자 수 내림차순, 총 조회수 내림차순)
			2. 상세 정보를 확인하기 위한 채널 선택 (Primary Key인 채널 ID 입력)
			3. 채널 검색 (채널 검색 화면으로 넘어감)
			4. 종료

	검색 페이지:
		채널 검색을 위한 항목들을 설정함
		키워드(채널 이름, 채널 설명): 띄어쓰기를 이용해 구분하여 최대 2개까지 입력 가능함. 그 이상 입력 시 앞의 두개만 반영됨.
		구독자 수, 총 조회수: 상한값, 하한값 구분하여 메뉴로 만들어 두었음.
		장르: 띄어쓰기를 이용해 구분하여 최대 2개까지 입력 가능함. 그 이상 입력 시 앞의 두개만 반영됨.

		메뉴:
			1. 키워드 검색
			2. 구독자 수 하한값
			3. 구독자 수 상한값
			4. 총 조회수 하한값
			5. 총 조회수 상한값
			6. 장르
			7. 설정한 조건들을 이용하여 검색 수행
			8. 이전 페이지로
			9. 종료

	검색 결과 페이지:
		검색 페이지에서 설정한 조건들을 이용하여 검색한 결과를 출력함
		채널의 상세 정보(채널 ID, 구독자 수, 총 조회수, 관리자, 장르, 출연진, 채널 이름, 채널 설명)를 출력

		메뉴:
			1. 정렬 방식 변경 (채널 이름 사전순, 구독자 수 내림차순, 총 조회수 내림차순)
			2. 상세 정보를 확인하기 위한 채널 선택 (Primary Key인 채널 ID 입력)
			3. 채널 검색 (채널 검색 화면으로 넘어감)
			4. 종료

	채널 정보 페이지:
		메인 페이지, 검색 결과 페이지에서 선택한 채널의 상세 정보를 출력함
		선택한 채널에 대해 평점을 매기고, 덧글을 작성할 수 있음

		메뉴:
			1. 채널 평가 (1 ~ 10점)
			2. 덧글 작성
			3. 뒤로 가기 (메인 페이지, 검색 결과 페이지 중 어느 곳에서 넘어왔는지 정보를 저장해 둠)
			4. 종료

유의 사항:
	장르, 출연진 속성은 값을 여러 개 가질 수 있기 때문에 테이블을 분리해둔 상태이므로,
	채널 정보를 출력할 때 장르, 출연진을 위한 쿼리문을 따로 작성하여 반환된 결과 리스트를 출력하였음

	채널 평가, 덧글 작성 기능을 위해 로그인 기능을 구현하려 했으나 생략하고 고객 ID 중 하나를 가져와 사용하였음

	채널 평가 기능에서 원래는 유저별로 채널을 한 번씩만 평가할 수 있도록 만들고자 했으나,
	테스트하는 과정에서 평점을 다르게 입력할 경우 여러 번 평가가 가능한 것을 확인하였음.
	RATING 엔티티가 rating을 partial key로 가지는 weak 엔티티로, 테이블로 변환할 때 rating이 키에 포함되어 문제가 생겼음.
	RATING 엔티티를 M:N relation으로 변경하고, rating을 제외한 유저 ID, 채널 ID를 키로 가지는 테이블로 수정해야 함.

	그 외 없는 메뉴를 입력한 경우, 숫자를 입력해야 할 때 다른 값을 입력한 경우 등 오류가 발생할 경우 경고문을 출력하고 다시 입력 대기 상태로 돌아감.

제작 환경:
	Windows 11, Eclipse 20.06

쿼리 수정사항:
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