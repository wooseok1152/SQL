-- 1번 답
SELECT * FROM STUDENT;

SELECT DISTINCT T1.SNO, T1.SNAME FROM STUDENT T1, STUDENT T2 WHERE T1.SNAME = T2.SNAME AND T1.SNO != T2.SNO ORDER BY T1.SNAME;

-- 2번 답
SELECT * FROM PROFESSOR;
SELECT * FROM COURSE;

SELECT P.PNO, P.PNAME, P.SECTION, C.CNAME FROM PROFESSOR P LEFT JOIN COURSE C ON P.PNO = C.PNO ORDER BY P.SECTION;

-- 3번 답
SELECT * FROM SCORE;
SELECT * FROM COURSE;
SELECT * FROM PROFESSOR;

WITH THIS_SEMESTER_COURSE AS
(SELECT DISTINCT S.CNO, C.CNAME, C.ST_NUM, C.PNO 
 FROM SCORE S, COURSE C 
WHERE s.cno = C.CNO)
SELECT T.CNO, T.CNAME, P.PNAME FROM THIS_SEMESTER_COURSE T LEFT JOIN PROFESSOR P ON T.PNO = P.PNO ORDER BY t.st_num;