SELECT *
FROM STUDENT;

SELECT *
FROM SCORE;

SELECT *
FROM PROFESSOR;

SELECT *
FROM COURSE;

/*
LEADING힌트를 사용해서, 테이블 접근 순서를 설정할 수 있음
먼저 접근된 테이블이 Join시 Driving 테이블이 됨
*/
SELECT /*+ LEADING(B A) */
       B.SNO,
       A.CNAME,
       B.RESULT
FROM COURSE A,
     SCORE B
WHERE A.CNO = B.CNO AND
      A.CNO >= '2000';

SELECT /*+ LEADING(A B) */
       B.SNO,
       A.CNAME,
       B.RESULT
FROM (SELECT *
      FROM COURSE
      WHERE CNO >= '2000'
     ) A,
     SCORE B
WHERE A.CNO = B.CNO;

/* 
Nested Loop Join은 테이블 중 적어도 하나의 조인 컬럼에 대해 인덱스가 존재할 때 발생될 수 있음
밑의 예시에 기입된 모든 테이블에는 인덱스가 존재하지 않음
그러므로 아무리 'USE_NL'힌트를 기입했더라도, Nested Loop Join이 발생되지 않음
*/
SELECT /*+ LAEDING(A C B) USE_NL(C) USE_NL(B)*/
       B.SNO,
       b.sname,
       A.CNO,
       C.RESULT
FROM COURSE A,
     STUDENT B,
     SCORE C
WHERE A.CNO = C.CNO AND
      B.SNO = C.SNO;

/* 
'NO_MERGE'힌트를 사용하여, inline view를 사용할 시에 실제 테이블과 MERGE되지 않게 설정할 수 있음
Global Hint를 사용하여, inline view 내 접근순서를 설정할 수 있음
*/      
SELECT /*+ LEADING(SCORE SECOND_INLINE_VIEW FIRST_INLINE_VIEW) LEADING(SECOND_INLINE_VIEW.B SECOND_INLINE_VIEW.A) USE_HASH(SECOND_INLINE_VIEW) USE_HASH(FIRST_INLINE_VIEW)  */
       SCORE.SNO,
       FIRST_INLINE_VIEW.CNAME,
       SECOND_INLINE_VIEW.PNAME,
       SCORE.RESULT
FROM   (SELECT /*+ NO_MERGE */
               CNO,
               CNAME
        FROM COURSE
        WHERE CNO >= '2000'
        ) FIRST_INLINE_VIEW, 
       (SELECT /*+ NO_MERGE */
               A.CNO,
               B.PNAME
        FROM  COURSE A, PROFESSOR B
        WHERE A.PNO = B.PNO
       ) SECOND_INLINE_VIEW, 
       SCORE
WHERE  FIRST_INLINE_VIEW.CNO = SECOND_INLINE_VIEW.CNO AND
       SECOND_INLINE_VIEW.CNO = SCORE.CNO;      



      
WITH A AS(
SELECT /*+ INLINE */
       CNO,
       CNAME
FROM COURSE
WHERE CNO >= '2000'
),

B AS (
SELECT /*+ INLINE LEADING(B A) */
       A.CNO,
       B.PNAME
FROM  COURSE A, PROFESSOR B
WHERE A.PNO = B.PNO
)

SELECT /*+ LEADING(C A B) */
       C.SNO,
       A.CNAME,
       B.PNAME,
       C.RESULT
FROM   A, B, SCORE C
WHERE  A.CNO = B.CNO AND
       B.CNO = C.CNO;





SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

