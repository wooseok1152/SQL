SELECT *
FROM STUDENT;

SELECT *
FROM SCORE;

SELECT *
FROM PROFESSOR;

SELECT *
FROM COURSE;

SELECT *
FROM SCGRADE;

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

/* 
WITH구문 내에 'INLINE'힌트와 'NO_MERGE'힌트를 사용하여, 해당 WITH구문을 inline view형식으로 사용하고 실제 테이블과 MERGE되지 않게 설정함
여러개의 WITH구문이 절차지향적으로 사용된 상황에서 각 WITH구문에 'INLINE'힌트와 'NO_MERGE'힌트를 동시에 사용하면, 의도한 절차대로 optimizer가 동작하게 됨
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE */
       CNO,
       CNAME,
       PNO
FROM COURSE
WHERE CNO >= '2000'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       A.CNO,
       A.CNAME,
       B.PNAME,
       B.ORDERS
FROM FIRST_WITH A, PROFESSOR B
WHERE A.PNO = B.PNO
),

THIRD_WITH AS (
SELECT /*+ INLINE NO_MERGE) */
       B.SNO,
       A.CNO,
       CNAME,
       B.RESULT,
       PNAME,
       ORDERS
FROM SECOND_WITH A, SCORE B
WHERE A.CNO = B.CNO
)

SELECT *
FROM THIRD_WITH;

/* 
참조되지 않은 View에 대해선 아무런 Operation이 발생하지 않음
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE FULL(COURSE) PARALLEL(COURSE 4)*/
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
WHERE CNO LIKE '%2%'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       SNO,
       CNO,
       RESULT,
       (SELECT /*+ NO_UNNEST */
               GRADE 
        FROM SCGRADE B
        WHERE B.HISCORE >= A.RESULT
              AND B.LOSCORE <= A.RESULT
       ) AS GRADE
FROM SCORE A
)

SELECT *
FROM SECOND_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/* 
참조된 inline view갯수만큼, 'VIEW'operation이 발생함
두 번째 inline view에선 단지 첫 번째 inline view 결과에 조건을 기입하였지만, 해당 inline view에 대해 'VIEW'operation이 발생함
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE FULL(COURSE) PARALLEL(COURSE 4)*/
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       *
FROM FIRST_WITH
WHERE TO_CHAR(RNK) LIKE '%1%'
)

SELECT *
FROM SECOND_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/* 
두 개의 view에 대해 'HASH JOIN'operation이 발생될 수 있음
Correlated Subquery에 대해선, 특정 join operation이 발생되지 않음
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE FULL(COURSE) PARALLEL(COURSE 4)*/
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
WHERE CNO LIKE '%2%'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       SNO,
       CNO,
       RESULT,
       (SELECT /*+  NO_UNNEST */
               GRADE 
        FROM SCGRADE B
        WHERE B.HISCORE >= A.RESULT
              AND B.LOSCORE <= A.RESULT
       ) AS GRADE
FROM SCORE A
),

THIRDE_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       B.SNO,
       A.CNAME,
       A.PNO,
       B.RESULT,
       B.GRADE
FROM FIRST_WITH A, SECOND_WITH B
WHERE A.CNO = B.CNO
      AND TO_CHAR(RNK) LIKE '%1%'
)

SELECT B.SNAME,
       A.CNAME,
       A.RESULT,
       A.GRADE
FROM THIRDE_WITH A, STUDENT B
WHERE A.SNO = B.SNO;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


/* 
'MATERIALZE'힌트로 인해 생성된 임시 테이블에 대해선, Table Scan이 발생함
*/  
WITH FIRST_WITH AS(
SELECT /*+ MATERIALIZE */
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
WHERE CNO LIKE '%2%'
),

SECOND_WITH AS (
SELECT /*+ MATERIALIZE */
       CNO,
       CNAME,
       PNO,
       RNK
FROM FIRST_WITH
WHERE TO_CHAR(RNK) LIKE '%1%'
),

THIRD_WITH AS (
SELECT /*+ MATERIALIZE */
       A.CNO,
       A.CNAME,
       B.PNAME,
       B.ORDERS,
       A.RNK
FROM SECOND_WITH A, PROFESSOR B
WHERE A.PNO = B.PNO
)

SELECT *
FROM THIRD_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));