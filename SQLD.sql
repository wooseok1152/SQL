CREATE TABLE DEPT
(
 deptno VARCHAR2(4),
 deptname VARCHAR2(20),
 CONSTRAINT dptnopk PRIMARY KEY(deptno)
);

SELECT * FROM DEPT;

INSERT INTO DEPT VALUES('1000', '인사팀');
INSERT INTO DEPT VALUES('1001', '총무팀');

CREATE TABLE EMP
(
    empno number(10),
    ename varchar2(20),
    sal number(10,2) default 0,
    deptno varchar2(4) not null,
    createdate date default sysdate,
    CONSTRAINT empnopk primary key(empno),
    CONSTRAINT deptfk FOREIGN key(deptno) REFERENCES DEPT(deptno) ON DELETE CASCADE
);

INSERT INTO EMP VALUES(100, '임베스트', 1000, '1000', sysdate);
INSERT INTO EMP VALUES(101, '을지문덕', 2000, '1001', sysdate);

SELECT * FROM EMP;

DELETE FROM DEPT WHERE DEPTNO = '1000';
SELECT * FROM EMP;

ALTER TABLE EMP RENAME TO NEW_EMP;
SELECT * FROM NEW_EMP;

ALTER TABLE NEW_EMP ADD(age NUMBER(2) default 1);
SELECT * FROM NEW_EMP;

ALTER TABLE NEW_EMP MODIFY(ENAME VARCHAR2(40) NOT NULL);

ALTER TABLE NEW_EMP DROP COLUMN AGE;
SELECT * FROM new_emp;

ALTER TABLE NEW_EMP RENAME COLUMN ENAME TO NEW_ENAME;
SELECT * FROM new_emp;

CREATE TABLE TEST
(
    TEST_1 VARCHAR2(9),
    TEST_2 NUMBER(4)
);

INSERT INTO TEST VALUES('TEST', 4);
SELECT * FROM TEST;

DROP TABLE TEST;
SELECT * FROM new_emp;

CREATE VIEW T_EMP AS SELECT EMPNO, NEW_ENAME FROM NEW_EMP; 
SELECT * FROM T_EMP;

ALTER TABLE NEW_EMP NOLOGGING;
SELECT * FROM new_emp;

INSERT INTO new_emp VALUES(102, '가나다라', 3000, '1001', sysdate);
UPDATE new_emp SET SAL = 4000 WHERE SAL = 3000;
SELECT * FROM NEW_EMP;

DELETE FROM new_emp WHERE new_ename = '가나다라';

SELECT EMPNO, NEW_ENAME || '님' FROM NEW_EMP;

CREATE TABLE EMP
(
EMPNO NUMBER(10),
ENAME VARCHAR2(20),
SAL NUMBER(10),

CONSTRAINT EMPNO_PK PRIMARY KEY(EMPNO)
);

INSERT INTO EMP VALUES(1000, '임베스트', 20000);
INSERT INTO EMP VALUES(1001, '조조', 20000);
INSERT INTO EMP VALUES(1002, '관우', 20000);
INSERT INTO EMP VALUES(999, '가나다라', 10000);

SELECT /*+ INDEX_DESC(EMP EMPNO_PK) */ * FROM EMP;

SELECT * FROM EMP ORDER BY EMPNO DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL,NULL,'ALLSTATS LAST'));

SELECT * FROM EMP;

SELECT DISTINCT SAL FROM EMP;

SELECT EMPNO, ENAME, SAL AS 연봉 FROM EMP E WHERE E.SAL = 20000;

SELECT * FROM EMP E WHERE e.sal != 10000;

SELECT * FROM EMP E WHERE e.sal BETWEEN 20000 AND 30000;

INSERT INTO EMP VALUES(1003, 'HIHI', 15000);

SELECT * FROM EMP E WHERE E.SAL IN (10000, 15000);

SELECT * FROM EMP E WHERE e.sal != 10000;

SELECT * FROM EMP E WHERE NOT E.SAL = 10000;

SELECT * FROM EMP E WHERE E.ENAME LIKE '임%';

SELECT * FROM EMP E WHERE E.ENAME LIKE '임베스_'; 

INSERT INTO EMP(EMPNO, ename) VALUES(1004, 'BYE');
SELECT * FROM EMP E WHERE SAL IS NULL;

SELECT EMPNO, ENAME, NVL(SAL, 0) AS FIEXED FROM EMP;

SELECT EMPNO, ENAME, NVL2(SAL, 1, 0) AS FIEXED FROM EMP;

ALTER TABLE EMP ADD(DEPNO VARCHAR2(4));
UPDATE EMP set depno = '1000' WHERE EMPNO = 1000;
UPDATE EMP set depno = '1000' WHERE EMPNO = 1001;
UPDATE EMP set depno = '1000' WHERE EMPNO = 1002;
UPDATE EMP set depno = '1001' WHERE EMPNO = 1003;
UPDATE EMP set depno = '1001' WHERE EMPNO = 1004;
UPDATE EMP set depno = '1001' WHERE EMPNO = 999;
ALTER TABLE EMP ADD CONSTRAINT FK_DEPNO FOREIGN KEY(DEPNO) REFERENCES DEPT(DEPTNO);
ALTER TABLE EMP RENAME COLUMN DEPNO TO DEPTNO;
SELECT * FROM EMP;

SELECT DEPTNO, SUM(SAL) AS SALLARY_SUM FROM EMP GROUP BY DEPTNO HAVING SUM(SAL) < 30000;

INSERT INTO DEPT VALUES('1000', '인사팀');

SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO;

UPDATE EMP SET SAL = 30000 WHERE EMPNO = 1001;

SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO;

SELECT DEPTNO, VARIANCE(SAL) FROM EMP GROUP BY DEPTNO;

SELECT * FROM EMP;

SELECT to_number(DEPTNO) FROM DEPT;

SELECT to_char(EMPNO) FROM EMP;

SELECT 'AB'||'CD' FROM DUAL;

SELECT TRIM('   ABCDEF   ') FROM DUAL;

SELECT EXTRACT(YEAR FROM SYSDATE), EXTRACT(MONTH FROM SYSDATE), EXTRACT(DAY FROM SYSDATE) FROM DUAL;

SELECT MOD(10, 3) FROM DUAL;

SELECT CEIL(10.3) FROM DUAL;

SELECT FLOOR(10.3) FROM DUAL;

SELECT ROUND(10.34, 1) FROM DUAL;

SELECT TRUNC(10.34, 0) FROM DUAL;

SELECT * FROM EMP;

/*DEPT 테이블의 DEPTNO 컬럼 타입 변경하는 방법*/

-- 먼저 DEPT 테이블과 DEPT 테이블을 참조하는 테이블의 FORIGEN KEY 제약 조건을 삭제한다.
ALTER TABLE EMP DROP CONSTRAINT FK_DEPNO;
ALTER TABLE NEW_EMP DROP CONSTRAINT DEPTFK;
ALTER TABLE DEPT DROP CONSTRAINT DPTNOPK;

-- 컬럼 유형을 변경하기 위해선 해당 컬럼에 데이터가 없어야 하기 때문에, TMP 테이블을 활용하여 컬럼 유형을 변경한다.
CREATE TABLE DEPT_TMP AS SELECT * FROM DEPT;
DELETE DEPT;
ALTER TABLE DEPT MODIFY(DEPTNO NUMBER(20));
INSERT INTO DEPT SELECT * FROM DEPT_TMP;

-- 컬럼 유형을 변경하기 위해선 해당 컬럼에 데이터가 없어야 하기 때문에, TMP 테이블을 활용하여 컬럼 유형을 변경한다.
CREATE TABLE EMP_TMP AS SELECT * FROM EMP;
DELETE EMP;
ALTER TABLE EMP MODIFY(DEPTNO NUMBER(20));
INSERT INTO EMP SELECT * FROM EMP_TMP;
DROP TABLE EMP_TMP;

-- 앞에서 제거해줬던 제약조건들을 다시 설정해준다.
ALTER TABLE DEPT ADD CONSTRAINT PK_DEPTNO PRIMARY KEY(DEPTNO);
ALTER TABLE EMP ADD CONSTRAINT FK_DEPTNO FOREIGN KEY(DEPTNO) REFERENCES DEPT(DEPTNO);

SELECT DECODE(EMPNO, 1000, 'TRUE', 'FALSE') FROM EMP;

SELECT 
    CASE
        WHEN EMPNO = 1000 THEN 'A'
        WHEN EMPNO = 1001 THEN 'B'
        ELSE 'C'
    END
    FROM EMP;
    
SELECT * FROM(SELECT ROWNUM AS LIST, ENAME FROM EMP) WHERE LIST <= 3;

SELECT * FROM(SELECT ROWNUM AS LIST, ENAME FROM EMP) WHERE LIST BETWEEN 2 AND 4;

WITH VIEWDATA AS (SELECT * FROM EMP) SELECT * FROM VIEWDATA;

SELECT * FROM VIEWDATA;

GRANT SELECT ON EMP TO us1152;

GRANT CREATE SESSION TO us1152;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO us1152;
GRANT SELECT ON EMP TO us1152;

SELECT * FROM SYSTEM.EMP;

GRANT UNLIMITED TABLESPACE TO US1152;
GRANT ALL ON EMP TO US1152;

show user;

REVOKE SELECT ON EMP FROM US1152;

SELECT * FROM EMP;

INSERT INTO EMP VALUES(1005, '마바사', 13000, '1000');
SELECT * FROM EMP;

UPDATE EMP SET ENAME = '유비' WHERE ENAME = '조조';
ROLLBACK;
SELECT * FROM EMP;

SELECT * FROM EMP WHERE SAL > NULL;

SELECT 1+NULL FROM DUAL;

SELECT TRUNC(10.34, 0) FROM DUAL;

SELECT ROUND(10.34, 1) FROM DUAL;

SELECT * FROM EMP ORDER BY ENAME DESC;

INSERT INTO DEPT VALUES(1002, '개발팀');
INSERT INTO DEPT VALUES(1003, '영업팀');
COMMIT;

SELECT * FROM DEPT;

SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO != DEPT.DEPTNO;

SELECT * FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO AND EMP.ENAME LIKE '임%';

SELECT DEPTNO FROM EMP
INTERSECT
SELECT DEPTNO FROM DEPT;

SELECT * FROM EMP, DEPT;

SELECT * FROM EMP LEFT OUTER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM EMP RIGHT OUTER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM EMP FULL OUTER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM EMP
UNION
SELECT * FROM EMP;

SELECT * FROM EMP
UNION ALL
SELECT * FROM EMP;

INSERT INTO DEPT VALUES('1002', '영업팀');

SELECT DEPTNO FROM DEPT
MINUS
SELECT DEPTNO FROM EMP;

CREATE TABLE NEW_EMP
(
EMPNO NUMBER(10) PRIMARY KEY,
ENAME VARCHAR2(20),
DEPTNO NUMBER(10),
MGR NUMBER(10),
JOB VARCHAR2(20),
SAL NUMBER(10)
);

INSERT INTO NEW_EMP VALUES(1000, 'TEST1', 20, NULL, 'CLERK', 800);
INSERT INTO NEW_EMP VALUES(1001, 'TEST2', 30, 1000, 'SALESMAN', 1600);
INSERT INTO NEW_EMP VALUES(1002, 'TEST3', 30, 1000, 'SALESMAN', 1250);
INSERT INTO NEW_EMP VALUES(1003, 'TEST4', 20, 1000, 'MANAGER', 2975);
INSERT INTO NEW_EMP VALUES(1004, 'TEST5', 30, 1000, 'SALESMAN', 1250);
INSERT INTO NEW_EMP VALUES(1005, 'TEST6', 30, 1001, 'MANAGER', 2850);
INSERT INTO NEW_EMP VALUES(1006, 'TEST7', 10, 1001, 'MANAGER', 2450);
INSERT INTO NEW_EMP VALUES(1007, 'TEST8', 20, 1006, 'ANALYST', 3000);
INSERT INTO NEW_EMP VALUES(1008, 'TEST9', 30, 1006, 'PRESIDENT', 5000);
INSERT INTO NEW_EMP VALUES(1009, 'TEST10', 30, 1002, 'SALESMAN', 1500);
INSERT INTO NEW_EMP VALUES(1010, 'TEST11', 20, 1002, 'CLERK', 1100);
INSERT INTO NEW_EMP VALUES(1011, 'TEST12', 30, 1001, 'CLERK', 950);
INSERT INTO NEW_EMP VALUES(1012, 'TEST13', 20, 1000, 'ANALYST', 3000);
INSERT INTO NEW_EMP VALUES(1013, 'TEST14', 10, 1000, 'CLERK', 1300);
INSERT INTO NEW_EMP VALUES(1014, 'TEST15', 30, 1005, 'SALESMAN', 1300);

COMMIT;

SELECT * FROM new_emp;

SELECT * FROM NEW_EMP;

SELECT LEVEL, LPAD(' ', 4 * (LEVEL-1) ) || EMPNO, MGR, SYS_CONNECT_BY_PATH(EMPNO, '|') FROM NEW_EMP START WITH MGR IS NULL CONNECT BY PRIOR EMPNO = MGR;

SELECT ENAME, DEPTNO, JOB
FROM new_emp
WHERE DEPTNO = (SELECT DEPTNO FROM new_emp WHERE ENAME = 'TEST1');

SELECT * FROM NEW_EMP;

SELECT deptno, sal FROM NEW_EMP WHERE sal > 2000;

SELECT EMPNO, ENAME, SAL FROM NEW_EMP WHERE SAL > ALL (SELECT SAL FROM NEW_EMP WHERE deptno = 20);

SELECT EMPNO, ENAME FROM (SELECT EMPNO, ENAME, DEPTNO FROM NEW_EMP WHERE SAL > 2000);

SELECT EMPNO, ENAME, MGR FROM NEW_EMP a WHERE EXISTS(SELECT * FROM NEW_EMP b WHERE b.MGR = a.MGR);