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
      
-- 스칼라 서브쿼리 예시2
SELECT A.SNO,
       A.SNAME,
       (SELECT X.CNAME FROM SYSTEM.COURSE X WHERE X.CNO = B.CNO) AS CNAME,
       B.RESULT
FROM SYSTEM.STUDENT A,
     SYSTEM.SCORE B
WHERE A.SNO = B.SNO;

-- '스칼라 서브쿼리 예시2'를 메인쿼리만 사용하는 방식으로 수정(해당 방식 사용 권장)
SELECT A.SNO,
       A.SNAME,
       B.CNAME,
       C.RESULT
FROM SYSTEM.STUDENT A,
     SYSTEM.COURSE B,
     SYSTEM.SCORE C
WHERE A.SNO = C.SNO
      AND B.CNO = C.CNO;
      
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

-- 메인쿼리만 사용하여 세 테이블을 조인하던 것을, 서브쿼리를 활용하여 조인하는 방식으로 변환(해당 방식 사용 권장하지 않음)
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