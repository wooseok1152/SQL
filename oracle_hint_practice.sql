/*
��ü���� �����ȹ�� ��ȯ�ϴ� ��� : 'gather_plan_statistics'��Ʈ�� ������ �������� �����Ų ��, 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));'������ ����
'ROWNUM'�÷��� SELECT���� �����ϸ�, �ǵ��� ������ ��Ĵ�� ������ �����ų �� ����
'ROWNUM'�÷��� SELECT���� �����ϸ� ���� FULL SCAN�� �߻�������, hint�� ����Ͽ� INDEX SCAN�� �߻��ϵ��� ���� �� ����
*/
SELECT /*+ gather_plan_statistics INDEX(STUDENT STUDENT_SNO_PK)*/
       ROWNUM,
       SNO
FROM STUDENT
WHERE SNO <= '910000';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
Trace��ȯ�ϴ� ���
*/
-- trace�� � �������� ��Ÿ�������� ���� ����(level�� ������ ��������, �� �� ��ü���� Trace�� ��ȯ���� �� ����)
alter session set events '10046 trace name context forever, level 1';

-- Trace�� Ȯ���� DML ������ �����ϱ� ��, ���� ������ DML���� ���� �� Trace������ ��ȯ�ϵ��� ���� 
ALTER SESSION SET SQL_TRACE=TRUE;

-- ���� ������ DML���� ���� �� Trace������ ��ȯ���� �ʵ��� ����
ALTER SESSION SET SQL_TRACE=FALSE;

-- Trace���ϸ� �����ڸ� �߰��� �����ϵ��� ����
ALTER SESSION SET TRACEFILE_IDENTIFIER = 'CHOI2';

-- Trace���� ���� ��� Ȯ��
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
LEADING��Ʈ�� ����ؼ�, ���̺� ���� ������ ������ �� ����
���� ���ٵ� ���̺��� Join�� Driving ���̺��� ��
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
Nested Loop Join�� ���̺� �� ��� �ϳ��� ���� �÷��� ���� �ε����� ������ �� �߻��� �� ����
���� ���ÿ� ���Ե� ��� ���̺��� �ε����� �������� ����
�׷��Ƿ� �ƹ��� 'USE_NL'��Ʈ�� �����ߴ���, Nested Loop Join�� �߻����� ����
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
'NO_MERGE'��Ʈ�� ����Ͽ�, inline view�� ����� �ÿ� ���� ���̺�� MERGE���� �ʰ� ������ �� ����
Global Hint�� ����Ͽ�, inline view �� ���ټ����� ������ �� ����
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
WITH���� ���� 'INLINE'��Ʈ�� 'NO_MERGE'��Ʈ�� ����Ͽ�, �ش� WITH������ inline view�������� ����ϰ� ���� ���̺�� MERGE���� �ʰ� ������
�������� WITH������ �������������� ���� ��Ȳ���� �� WITH������ 'INLINE'��Ʈ�� 'NO_MERGE'��Ʈ�� ���ÿ� ����ϸ�, �ǵ��� ������� optimizer�� �����ϰ� ��
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
�������� ���� View�� ���ؼ� �ƹ��� Operation�� �߻����� ����
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
������ inline view������ŭ, 'VIEW'operation�� �߻���
�� ��° inline view���� ���� ù ��° inline view ����� ������ �����Ͽ�����, �ش� inline view�� ���� 'VIEW'operation�� �߻���
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
�� ���� view�� ���� 'HASH JOIN'operation�� �߻��� �� ����
Correlated Subquery�� ���ؼ�, Ư�� join operation�� �߻����� �ʰ� 'FILTER' operation�� �߻���
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
'MATERIALZE'��Ʈ�� ���� ������ �ӽ� ���̺� ���ؼ�, Table Scan�� �߻���
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
WITH������ ���� ������ view�� ������ �����Ǹ�, ������ Ƚ����ŭ �ش� view�� ���� Table Scan�� �߻���
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
scalar subquery�� ���� ���� ��ȹ
scalar subquery������ŭ table scan�� �߻���
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
