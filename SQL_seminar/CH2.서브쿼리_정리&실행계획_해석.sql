-- 스칼라 서브쿼리 예시1
SELECT (SELECT STD_DT FROM SYSTEM.STD_DT_TABLE WHERE SEMESTER = '20/01') AS STD_DT,
       A.SNO,
       A.SNAME,
       B.CNAME,
       C.RESULT
FROM SYSTEM.STUDENT A,
     SYSTEM.COURSE B,
     SYSTEM.SCORE C
WHERE A.SNO = C.SNO
      AND B.CNO = C.CNO;
      
-- 스칼라 서브쿼리 예시2(SCALAR SUBQUERY이면서 동시에 CORRELATED SUBQUERY)
SELECT A.SNO,
       A.SNAME,
       (SELECT X.CNAME FROM SYSTEM.COURSE X WHERE X.CNO = B.CNO) AS CNAME,
       B.RESULT
FROM SYSTEM.STUDENT A,
     SYSTEM.SCORE B
WHERE A.SNO = B.SNO;  
      
-- CORRELATED SUBQUERY 예시(SCALAR SUBQUERY이면서 동시에 CORRELATED SUBQUERY)
SELECT A.BSNSS_DT,
       A.STND_IS_CD,
       A.CRNCY_CD,
       A.CLS_PRC,
       (SELECT B.RATE 
        FROM SYSTEM.EXCHANGE_RATE_CLS_PRC_BY_DT B
        WHERE B.STD_DT = (SELECT MAX(C.STD_DT)
                          FROM SYSTEM.EXCHANGE_RATE_CLS_PRC_BY_DT C
                          WHERE C.CRNCY_CD = A.CRNCY_CD
                                AND C.STD_DT <=  A.BSNSS_DT 
                         )
             AND B.CRNCY_CD = A.CRNCY_CD
        ) AS RATE,
       TRUNC(A.CLS_PRC * (SELECT B.RATE 
                          FROM SYSTEM.EXCHANGE_RATE_CLS_PRC_BY_DT B
                          WHERE B.STD_DT = (SELECT MAX(C.STD_DT)
                                            FROM SYSTEM.EXCHANGE_RATE_CLS_PRC_BY_DT C
                                            WHERE C.CRNCY_CD = A.CRNCY_CD
                                                  AND C.STD_DT <=  A.BSNSS_DT 
                                           )
                                AND B.CRNCY_CD = A.CRNCY_CD
                   )
            ) AS KRW_CLS_PRC
FROM SYSTEM.CLS_PRC_BY_DT A;

-- 인라인뷰 예시1(INLINE VIEW 1개 사용)
SELECT SNAME,
       CASE WHEN GRADE = 'A' THEN CNT ELSE 0 END AS A_CNT,
       CASE WHEN GRADE = 'B' THEN CNT ELSE 0 END AS B_CNT,
       CASE WHEN GRADE = 'C' THEN CNT ELSE 0 END AS C_CNT,
       CASE WHEN GRADE = 'D' THEN CNT ELSE 0 END AS D_CNT,
       CASE WHEN GRADE = 'F' THEN CNT ELSE 0 END AS F_CNT
FROM (
    SELECT A.SNAME,
           D.GRADE,
           COUNT(*) AS CNT
    FROM SYSTEM.STUDENT A,
         SYSTEM.COURSE B,
         SYSTEM.SCORE C,
         SYSTEM.SCGRADE D
    WHERE A.SNO = C.SNO
          AND B.CNO = C.CNO
          AND C.RESULT <= D.HISCORE
          AND C.RESULT >= D.LOSCORE
          AND A.SNO IN ('944503', '925602')
    GROUP BY A.SNAME, D.GRADE
    ORDER BY A.SNAME, D.GRADE
);

-- 인라인뷰 예시2(INLINE VIEW 2개 사용)
SELECT SNAME,
       SUM(A_CNT) AS A_CNT,
       SUM(B_CNT) AS B_CNT,
       SUM(C_CNT) AS C_CNT,
       SUM(D_CNT) AS D_CNT,
       SUM(F_CNT) AS F_CNT
FROM (
    SELECT SNAME,
           CASE WHEN GRADE = 'A' THEN CNT ELSE 0 END AS A_CNT,
           CASE WHEN GRADE = 'B' THEN CNT ELSE 0 END AS B_CNT,
           CASE WHEN GRADE = 'C' THEN CNT ELSE 0 END AS C_CNT,
           CASE WHEN GRADE = 'D' THEN CNT ELSE 0 END AS D_CNT,
           CASE WHEN GRADE = 'F' THEN CNT ELSE 0 END AS F_CNT
    FROM (
        SELECT A.SNAME,
               D.GRADE,
               COUNT(*) AS CNT
        FROM SYSTEM.STUDENT A,
             SYSTEM.COURSE B,
             SYSTEM.SCORE C,
             SYSTEM.SCGRADE D
        WHERE A.SNO = C.SNO
              AND B.CNO = C.CNO
              AND C.RESULT <= D.HISCORE
              AND C.RESULT >= D.LOSCORE
              AND A.SNO IN ('944503', '925602')
        GROUP BY A.SNAME, D.GRADE
        ORDER BY A.SNAME, D.GRADE
    )
)
GROUP BY SNAME;

-- 메인쿼리만 사용하여 세 테이블을 조인하던 것을 인라인뷰를 활용하여 조인하는 방식으로 변환(해당 방식 사용 권장하지 않음)
SELECT X1.SNO,
       X1.SNAME,
       X2.CNAME,
       X1.RESULT
FROM (
    SELECT A.SNO,
           A.SNAME,
           B.CNO,
           B.RESULT
    FROM SYSTEM.STUDENT A,
         SYSTEM.SCORE B
    WHERE A.SNO = B.SNO
) X1,
SYSTEM.COURSE X2
WHERE X1.CNO = X2.CNO;
      
-- 네스티드 서브쿼리 예시
SELECT /*+ LEADING(A B) USE_NL(B) */
       A.ENAME,
       A.JOB,
       A.SAL,
       B.DNAME
FROM SYSTEM.EMP A,
     SYSTEM.DEPT B
WHERE A.DNO = B.DNO
      AND ENO IN (SELECT /*+ NO_UNNEST PUSH_SUBQ */ C.ENO FROM SYSTEM.BEST_EMP C);
      
-- WITH 예시
WITH COUNT_BY_STDNT_N_GRADE AS (
    SELECT A.SNAME,
           D.GRADE,
           COUNT(*) AS CNT
    FROM SYSTEM.STUDENT A,
         SYSTEM.COURSE B,
         SYSTEM.SCORE C,
         SYSTEM.SCGRADE D
    WHERE A.SNO = C.SNO
          AND B.CNO = C.CNO
          AND C.RESULT <= D.HISCORE
          AND C.RESULT >= D.LOSCORE
          AND A.SNO IN ('944503', '925602')
    GROUP BY A.SNAME, D.GRADE
),

TMP_PIVOT_TABLE AS (
    SELECT SNAME,
           CASE WHEN GRADE = 'A' THEN CNT ELSE 0 END AS A_CNT,
           CASE WHEN GRADE = 'B' THEN CNT ELSE 0 END AS B_CNT,
           CASE WHEN GRADE = 'C' THEN CNT ELSE 0 END AS C_CNT,
           CASE WHEN GRADE = 'D' THEN CNT ELSE 0 END AS D_CNT,
           CASE WHEN GRADE = 'F' THEN CNT ELSE 0 END AS F_CNT
    FROM COUNT_BY_STDNT_N_GRADE
)

SELECT SNAME,
       SUM(A_CNT) AS A_CNT,
       SUM(B_CNT) AS B_CNT,
       SUM(C_CNT) AS C_CNT,
       SUM(D_CNT) AS D_CNT,
       SUM(F_CNT) AS F_CNT
FROM TMP_PIVOT_TABLE
GROUP BY SNAME;
