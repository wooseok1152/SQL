/*
구체적인 실행계획을 반환하는 방법 : 'gather_plan_statistics'힌트를 기입한 쿼리문을 실행시킨 후, 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));'쿼리문 실행
'ROWNUM'컬럼을 SELECT문에 기입하면, 의도한 절차와 방식대로 쿼리를 실행시킬 수 있음
'ROWNUM'컬럼를 SELECT문에 기입하면 보통 FULL SCAN이 발생하지만, hint를 사용하여 INDEX SCAN이 발생하도록 만들 수 있음
*/
SELECT /*+ gather_plan_statistics INDEX(STUDENT STUDENT_SNO_PK)*/
       ROWNUM,
       SNO
FROM STUDENT
WHERE SNO <= '910000';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
Trace반환하는 방법
*/
-- trace가 어떤 형식으로 나타나는지에 대해 설정(level이 높으면 높을수록, 좀 더 구체적인 Trace를 반환받을 수 있음)
alter session set events '10046 trace name context forever, level 1';

-- Trace를 확인할 DML 쿼리를 실행하기 전, 현재 세션이 DML쿼리 실행 후 Trace파일을 반환하도록 설정 
ALTER SESSION SET SQL_TRACE=TRUE;

-- 현재 세션이 DML쿼리 실행 후 Trace파일을 반환하지 않도록 설정
ALTER SESSION SET SQL_TRACE=FALSE;

-- Trace파일명에 구분자를 추가로 기입하도록 설정
ALTER SESSION SET TRACEFILE_IDENTIFIER = 'CHOI2';

-- Trace파일 저장 경로 확인
SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';


SELECT *
FROM SCORE;

SELECT /*+ INDEX_DESC(PROFESSOR PROFESSOR_PNO_PK) */
       *
FROM PROFESSOR;

SELECT * 
FROM COURSE;

SELECT *
FROM SCGRADE;

/*
LEADING힌트를 사용해서, 테이블 접근 순서를 설정할 수 있음
먼저 접근된 테이블이 Join시 Driving 테이블이 됨
*/
SELECT /*+ gather_plan_statistics LEADING(B A) */
       ROWNUM,
       B.SNO,
       A.CNAME,
       B.RESULT
FROM COURSE A,
     SCORE B
WHERE A.CNO = B.CNO AND
      A.CNO >= '2000';
      
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));    

SELECT *
FROM COURSE;

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
       ROWNUM,
       CNO,
       CNAME,
       PNO
FROM COURSE
WHERE CNO >= '2000'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       ROWNUM,
       A.CNO,
       A.CNAME,
       B.PNAME,
       B.ORDERS
FROM FIRST_WITH A, PROFESSOR B
WHERE A.PNO = B.PNO
),

THIRD_WITH AS (
SELECT /*+ INLINE NO_MERGE) */
       ROWNUM,
       B.SNO,
       A.CNO,
       CNAME,
       B.RESULT,
       PNAME,
       ORDERS
FROM SECOND_WITH A, SCORE B
WHERE A.CNO = B.CNO
)

SELECT /*+ gather_plan_statistics LEADING(B A) */ *
FROM THIRD_WITH;

SELECT  * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/* 
참조되지 않은 View에 대해선 아무런 Operation이 발생하지 않음
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE FULL(COURSE) PARALLEL(COURSE 4)*/
       ROWNUM,
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
WHERE CNO LIKE '%2%'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       ROWNUM,
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

SELECT /*+ gather_plan_statistics LEADING(B A) */ *
FROM SECOND_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/* 
참조된 inline view갯수만큼, 'VIEW'operation이 발생함
두 번째 inline view에선 단지 첫 번째 inline view 결과에 조건을 기입하였지만, 해당 inline view에 대해 'VIEW'operation이 발생함
*/  
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE FULL(COURSE) PARALLEL(COURSE 4)*/
       ROWNUM,
       CNO,
       CNAME,
       PNO,
       ROW_NUMBER() OVER(ORDER BY CNO DESC) AS RNK
FROM COURSE
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       ROWNUM,
       CNO,
       CNAME,
       PNO,
       RNK
FROM FIRST_WITH
WHERE TO_CHAR(RNK) LIKE '%1%'
)

SELECT /*+ gather_plan_statistics */ *
FROM SECOND_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/* 
두 개의 view에 대해 'HASH JOIN'operation이 발생될 수 있음
Correlated Subquery에 대해선, 특정 join operation이 발생되지 않고 'FILTER' operation이 발생함
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

SELECT /*+ gather_plan_statistics */
       CNO,
       CNAME,
       PNAME,
       ORDERS,
       RNK
FROM THIRD_WITH;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
WITH구문을 통해 생성된 view가 여러번 참조되면, 참조된 횟수만큼 해당 view에 대한 Table Scan이 발생함
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
      B.PNO,
      A.PNAME,
      B.CNO
FROM PROFESSOR A, FIRST_WITH B
WHERE A.PNO = B.PNO
),

THIRD_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       B.SNO,
       B.CNO,
       B.RESULT
FROM FIRST_WITH A, SCORE B
WHERE A.CNO = B.CNO
)

SELECT /*+ gather_plan_statistics */
       B.SNO,
       B.CNO,
       A.PNO,
       A.PNAME,
       B.RESULT
FROM   SECOND_WITH A, THIRD_WITH B
WHERE  A.CNO = B.CNO;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
scalar subquery에 대한 실행 계획
scalar subquery갯수만큼 table scan이 발생함
*/
WITH FIRST_WITH AS(
SELECT /*+ INLINE NO_MERGE */
       CNO,
       CNAME,
       PNO
FROM COURSE
WHERE CNO >= '1000'
),

SECOND_WITH AS (
SELECT /*+ INLINE NO_MERGE */
       SNO,
       SNAME
FROM STUDENT
WHERE SNO LIKE '%1%'
)

SELECT /*+ gather_plan_statistics */
       (SELECT CNAME FROM FIRST_WITH WHERE CNO = '2358'),
       (SELECT SNAME FROM SECOND_WITH WHERE SNO = '915301'),
       (SELECT SNAME FROM SECOND_WITH WHERE SNO = '905301'),
       (SELECT SNAME FROM SECOND_WITH WHERE SNO = '915304')
FROM DUAL;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


SELECT *
FROM COURSE;
