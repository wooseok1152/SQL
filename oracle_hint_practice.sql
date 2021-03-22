SELECT *
FROM STUDENT;

SELECT *
FROM SCORE;

SELECT *
FROM PROFESSOR;

SELECT *
FROM COURSE;

/*
LEADING��Ʈ�� ����ؼ�, ���̺� ���� ������ ������ �� ����
���� ���ٵ� ���̺��� Join�� Driving ���̺��� ��
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

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));