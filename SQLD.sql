CREATE TABLE dept (
    deptno    VARCHAR2(4),
    deptname  VARCHAR2(20),
    CONSTRAINT dptnopk PRIMARY KEY ( deptno )
);

SELECT
    *
FROM
    dept;

INSERT INTO dept VALUES (
    '1000',
    '인사팀'
);

INSERT INTO dept VALUES (
    '1001',
    '총무팀'
);

CREATE TABLE emp (
    empno       NUMBER(10),
    ename       VARCHAR2(20),
    sal         NUMBER(10, 2) DEFAULT 0,
    deptno      VARCHAR2(4) NOT NULL,
    createdate  DATE DEFAULT sysdate,
    CONSTRAINT empnopk PRIMARY KEY ( empno ),
    CONSTRAINT deptfk FOREIGN KEY ( deptno )
        REFERENCES dept ( deptno )
            ON DELETE CASCADE
);

INSERT INTO emp VALUES (
    100,
    '임베스트',
    1000,
    '1000',
    sysdate
);

INSERT INTO emp VALUES (
    101,
    '을지문덕',
    2000,
    '1001',
    sysdate
);

SELECT
    *
FROM
    emp;

DELETE FROM dept
WHERE
    deptno = '1000';

SELECT
    *
FROM
    emp;

ALTER TABLE emp RENAME TO new_emp;

SELECT
    *
FROM
    new_emp;

ALTER TABLE new_emp ADD (
    age NUMBER(2) DEFAULT 1
);

SELECT
    *
FROM
    new_emp;

ALTER TABLE new_emp MODIFY (
    ename VARCHAR2(40) NOT NULL
);

ALTER TABLE new_emp DROP COLUMN age;

SELECT
    *
FROM
    new_emp;

ALTER TABLE new_emp RENAME COLUMN ename TO new_ename;

SELECT
    *
FROM
    new_emp;

CREATE TABLE test (
    test_1  VARCHAR2(9),
    test_2  NUMBER(4)
);

INSERT INTO test VALUES (
    'TEST',
    4
);

SELECT
    *
FROM
    test;

DROP TABLE test;

SELECT
    *
FROM
    new_emp;

CREATE VIEW t_emp AS
    SELECT
        empno,
        new_ename
    FROM
        new_emp;

SELECT
    *
FROM
    t_emp;

ALTER TABLE new_emp NOLOGGING;

SELECT
    *
FROM
    new_emp;

INSERT INTO new_emp VALUES (
    102,
    '가나다라',
    3000,
    '1001',
    sysdate
);

UPDATE new_emp
SET
    sal = 4000
WHERE
    sal = 3000;

SELECT
    *
FROM
    new_emp;

DELETE FROM new_emp
WHERE
    new_ename = '가나다라';

SELECT
    empno,
    new_ename || '님'
FROM
    new_emp;

CREATE TABLE emp (
    empno  NUMBER(10),
    ename  VARCHAR2(20),
    sal    NUMBER(10),
    CONSTRAINT empno_pk PRIMARY KEY ( empno )
);

INSERT INTO emp VALUES (
    1000,
    '임베스트',
    20000
);

INSERT INTO emp VALUES (
    1001,
    '조조',
    20000
);

INSERT INTO emp VALUES (
    1002,
    '관우',
    20000
);

INSERT INTO emp VALUES (
    999,
    '가나다라',
    10000
);

SELECT /*+ INDEX_DESC(EMP EMPNO_PK) */ 
        *
FROM
    emp;

SELECT
    *
FROM
    emp
ORDER BY
    empno DESC;

SELECT
    *
FROM
    TABLE ( dbms_xplan.display_cursor(NULL, NULL, 'ALLSTATS LAST') );

SELECT
    *
FROM
    emp;

SELECT DISTINCT
    sal
FROM
    emp;

SELECT
    empno,
    ename,
    sal AS 연봉
FROM
    emp e
WHERE
    e.sal = 20000;

SELECT
    *
FROM
    emp e
WHERE
    e.sal != 10000;

SELECT
    *
FROM
    emp e
WHERE
    e.sal BETWEEN 20000 AND 30000;

INSERT INTO emp VALUES (
    1003,
    'HIHI',
    15000
);

SELECT
    *
FROM
    emp e
WHERE
    e.sal IN ( 10000, 15000 );

SELECT
    *
FROM
    emp e
WHERE
    e.sal != 10000;

SELECT
    *
FROM
    emp e
WHERE
    NOT e.sal = 10000;

SELECT
    *
FROM
    emp e
WHERE
    e.ename LIKE '임%';

SELECT
    *
FROM
    emp e
WHERE
    e.ename LIKE '임베스_';

INSERT INTO emp (
    empno,
    ename
) VALUES (
    1004,
    'BYE'
);

SELECT
    *
FROM
    emp e
WHERE
    sal IS NULL;

SELECT
    empno,
    ename,
    nvl(sal, 0) AS fiexed
FROM
    emp;

SELECT
    empno,
    ename,
    nvl2(sal, 1, 0) AS fiexed
FROM
    emp;

ALTER TABLE emp ADD (
    depno VARCHAR2(4)
);

UPDATE emp
SET
    depno = '1000'
WHERE
    empno = 1000;

UPDATE emp
SET
    depno = '1000'
WHERE
    empno = 1001;

UPDATE emp
SET
    depno = '1000'
WHERE
    empno = 1002;

UPDATE emp
SET
    depno = '1001'
WHERE
    empno = 1003;

UPDATE emp
SET
    depno = '1001'
WHERE
    empno = 1004;

UPDATE emp
SET
    depno = '1001'
WHERE
    empno = 999;

ALTER TABLE emp
    ADD CONSTRAINT fk_depno FOREIGN KEY ( depno )
        REFERENCES dept ( deptno );

ALTER TABLE emp RENAME COLUMN depno TO deptno;

SELECT
    *
FROM
    emp;

SELECT
    deptno,
    SUM(sal) AS sallary_sum
FROM
    emp
GROUP BY
    deptno
HAVING
    SUM(sal) < 30000;

INSERT INTO dept VALUES (
    '1000',
    '인사팀'
);

SELECT
    deptno,
    AVG(sal)
FROM
    emp
GROUP BY
    deptno;

UPDATE emp
SET
    sal = 30000
WHERE
    empno = 1001;

SELECT
    deptno,
    MAX(sal)
FROM
    emp
GROUP BY
    deptno;

SELECT
    deptno,
    VARIANCE(sal)
FROM
    emp
GROUP BY
    deptno;

SELECT
    *
FROM
    emp;

SELECT
    to_number(deptno)
FROM
    dept;

SELECT
    to_char(empno)
FROM
    emp;

SELECT
    'AB' || 'CD'
FROM
    dual;

SELECT
    TRIM('   ABCDEF   ')
FROM
    dual;

SELECT
    EXTRACT(YEAR FROM sysdate),
    EXTRACT(MONTH FROM sysdate),
    EXTRACT(DAY FROM sysdate)
FROM
    dual;

SELECT
    mod(10, 3)
FROM
    dual;

SELECT
    ceil(10.3)
FROM
    dual;

SELECT
    floor(10.3)
FROM
    dual;

SELECT
    round(10.34, 1)
FROM
    dual;

SELECT
    trunc(10.34, 0)
FROM
    dual;

SELECT
    *
FROM
    emp;

/*DEPT 테이블의 DEPTNO 컬럼 타입 변경하는 방법*/

-- 먼저 DEPT 테이블과 DEPT 테이블을 참조하는 테이블의 FORIGEN KEY 제약 조건을 삭제한다.
ALTER TABLE emp DROP CONSTRAINT fk_depno;

ALTER TABLE new_emp DROP CONSTRAINT deptfk;

ALTER TABLE dept DROP CONSTRAINT dptnopk;

-- 컬럼 유형을 변경하기 위해선 해당 컬럼에 데이터가 없어야 하기 때문에, TMP 테이블을 활용하여 컬럼 유형을 변경한다.
CREATE TABLE dept_tmp
    AS
        SELECT
            *
        FROM
            dept;

DELETE dept;

ALTER TABLE dept MODIFY (
    deptno NUMBER(20)
);

INSERT INTO dept
    SELECT
        *
    FROM
        dept_tmp;

-- 컬럼 유형을 변경하기 위해선 해당 컬럼에 데이터가 없어야 하기 때문에, TMP 테이블을 활용하여 컬럼 유형을 변경한다.
CREATE TABLE emp_tmp
    AS
        SELECT
            *
        FROM
            emp;

DELETE emp;

ALTER TABLE emp MODIFY (
    deptno NUMBER(20)
);

INSERT INTO emp
    SELECT
        *
    FROM
        emp_tmp;

DROP TABLE emp_tmp;

-- 앞에서 제거해줬던 제약조건들을 다시 설정해준다.
ALTER TABLE dept ADD CONSTRAINT pk_deptno PRIMARY KEY ( deptno );

ALTER TABLE emp
    ADD CONSTRAINT fk_deptno FOREIGN KEY ( deptno )
        REFERENCES dept ( deptno );

SELECT
    decode(empno, 1000, 'TRUE', 'FALSE')
FROM
    emp;

SELECT
    CASE
        WHEN empno = 1000  THEN
            'A'
        WHEN empno = 1001  THEN
            'B'
        ELSE
            'C'
    END
FROM
    emp;

SELECT
    *
FROM
    (
        SELECT
            ROWNUM AS list,
            ename
        FROM
            emp
    )
WHERE
    list <= 3;

SELECT
    *
FROM
    (
        SELECT
            ROWNUM AS list,
            ename
        FROM
            emp
    )
WHERE
    list BETWEEN 2 AND 4;

WITH viewdata AS (
    SELECT
        *
    FROM
        emp
)
SELECT
    *
FROM
    viewdata;

SELECT
    *
FROM
    viewdata;

GRANT SELECT ON emp TO us1152;

GRANT
    CREATE SESSION
TO us1152;

GRANT
    CREATE TABLE,
    CREATE VIEW,
    CREATE SEQUENCE
TO us1152;

GRANT SELECT ON emp TO us1152;

SELECT
    *
FROM
    system.emp;

GRANT
    UNLIMITED TABLESPACE
TO us1152;

GRANT ALL ON emp TO us1152;

SHOW USER;

REVOKE SELECT ON emp FROM us1152;

SELECT
    *
FROM
    emp;

INSERT INTO emp VALUES (
    1005,
    '마바사',
    13000,
    '1000'
);

SELECT
    *
FROM
    emp;

UPDATE emp
SET
    ename = '유비'
WHERE
    ename = '조조';

ROLLBACK;

SELECT
    *
FROM
    emp;

SELECT
    *
FROM
    emp
WHERE
    sal > NULL;

SELECT
    1 + NULL
FROM
    dual;

SELECT
    trunc(10.34, 0)
FROM
    dual;

SELECT
    round(10.34, 1)
FROM
    dual;

SELECT
    *
FROM
    emp
ORDER BY
    ename DESC;

INSERT INTO dept VALUES (
    1002,
    '개발팀'
);

INSERT INTO dept VALUES (
    1003,
    '영업팀'
);

COMMIT;

SELECT
    *
FROM
    dept;

SELECT
    *
FROM
    emp,
    dept
WHERE
    emp.deptno != dept.deptno;

SELECT
    *
FROM
         emp
    INNER JOIN dept ON emp.deptno = dept.deptno
                       AND emp.ename LIKE '임%';

SELECT
    deptno
FROM
    emp
INTERSECT
SELECT
    deptno
FROM
    dept;

SELECT
    *
FROM
    emp,
    dept;

SELECT
    *
FROM
    emp
    LEFT OUTER JOIN dept ON emp.deptno = dept.deptno;

SELECT
    *
FROM
    emp
    RIGHT OUTER JOIN dept ON emp.deptno = dept.deptno;

SELECT
    *
FROM
    emp
    FULL OUTER JOIN dept ON emp.deptno = dept.deptno;

SELECT
    *
FROM
    emp
UNION
SELECT
    *
FROM
    emp;

SELECT
    *
FROM
    emp
UNION ALL
SELECT
    *
FROM
    emp;

INSERT INTO dept VALUES (
    '1002',
    '영업팀'
);

SELECT
    deptno
FROM
    dept
MINUS
SELECT
    deptno
FROM
    emp;

CREATE TABLE new_emp (
    empno   NUMBER(10) PRIMARY KEY,
    ename   VARCHAR2(20),
    deptno  NUMBER(10),
    mgr     NUMBER(10),
    job     VARCHAR2(20),
    sal     NUMBER(10)
);

INSERT INTO new_emp VALUES (
    1000,
    'TEST1',
    20,
    NULL,
    'CLERK',
    800
);

INSERT INTO new_emp VALUES (
    1001,
    'TEST2',
    30,
    1000,
    'SALESMAN',
    1600
);

INSERT INTO new_emp VALUES (
    1002,
    'TEST3',
    30,
    1000,
    'SALESMAN',
    1250
);

INSERT INTO new_emp VALUES (
    1003,
    'TEST4',
    20,
    1000,
    'MANAGER',
    2975
);

INSERT INTO new_emp VALUES (
    1004,
    'TEST5',
    30,
    1000,
    'SALESMAN',
    1250
);

INSERT INTO new_emp VALUES (
    1005,
    'TEST6',
    30,
    1001,
    'MANAGER',
    2850
);

INSERT INTO new_emp VALUES (
    1006,
    'TEST7',
    10,
    1001,
    'MANAGER',
    2450
);

INSERT INTO new_emp VALUES (
    1007,
    'TEST8',
    20,
    1006,
    'ANALYST',
    3000
);

INSERT INTO new_emp VALUES (
    1008,
    'TEST9',
    30,
    1006,
    'PRESIDENT',
    5000
);

INSERT INTO new_emp VALUES (
    1009,
    'TEST10',
    30,
    1002,
    'SALESMAN',
    1500
);

INSERT INTO new_emp VALUES (
    1010,
    'TEST11',
    20,
    1002,
    'CLERK',
    1100
);

INSERT INTO new_emp VALUES (
    1011,
    'TEST12',
    30,
    1001,
    'CLERK',
    950
);

INSERT INTO new_emp VALUES (
    1012,
    'TEST13',
    20,
    1000,
    'ANALYST',
    3000
);

INSERT INTO new_emp VALUES (
    1013,
    'TEST14',
    10,
    1000,
    'CLERK',
    1300
);

INSERT INTO new_emp VALUES (
    1014,
    'TEST15',
    30,
    1005,
    'SALESMAN',
    1300
);

COMMIT;

SELECT
    *
FROM
    new_emp;

SELECT
    *
FROM
    new_emp;

SELECT
    level,
    lpad(' ', 4 *(level - 1))
    || empno,
    mgr,
    sys_connect_by_path(empno, '|')
FROM
    new_emp
START WITH
    mgr IS NULL
CONNECT BY
    PRIOR empno = mgr;

SELECT
    ename,
    deptno,
    job
FROM
    new_emp
WHERE
    deptno = (
        SELECT
            deptno
        FROM
            new_emp
        WHERE
            ename = 'TEST1'
    );

SELECT
    *
FROM
    new_emp;

SELECT
    deptno,
    sal
FROM
    new_emp
WHERE
    sal > 2000;

SELECT
    empno,
    ename,
    sal
FROM
    new_emp
WHERE
    sal > ALL (
        SELECT
            sal
        FROM
            new_emp
        WHERE
            deptno = 20
    );

SELECT
    empno,
    ename
FROM
    (
        SELECT
            empno,
            ename,
            deptno
        FROM
            new_emp
        WHERE
            sal > 2000
    );

SELECT
    empno,
    ename,
    mgr
FROM
    new_emp a
WHERE
    EXISTS (
        SELECT
            *
        FROM
            new_emp b
        WHERE
            b.mgr = a.mgr
    );

SELECT
    AVG(sal)
FROM
    new_emp;

SELECT
    deptno,
    AVG(sal)
FROM
    new_emp
GROUP BY
    ROLLUP(deptno);

SELECT
    deptno,
    job,
    SUM(sal) AS sum
FROM
    new_emp
GROUP BY
    CUBE(deptno,
         job);

SELECT
    deptno,
    GROUPING(deptno),
    SUM(sal)
FROM
    new_emp
GROUP BY
    ROLLUP(deptno);

SELECT
    VARIANCE(sal)
FROM
    new_emp;

SELECT
    1
FROM
    dual
UNION
SELECT
    2
FROM
    dual
UNION
SELECT
    1
FROM
    dual;

SELECT
    decode(deptno, NULL, 'Total Sum', deptno),
    SUM(sal)
FROM
    new_emp
GROUP BY
    ROLLUP(deptno);

SELECT
    *
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    SUM(sal)
    OVER(PARTITION BY deptno
        ORDER BY
            sal
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    RANK()
    OVER(
        ORDER BY sal
    )
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    DENSE_RANK()
    OVER(
        ORDER BY sal
    )
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    ROW_NUMBER()
    OVER(
        ORDER BY sal
    )
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    SUM(sal)
    OVER(PARTITION BY deptno)
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    LEAD(sal, 2)
    OVER(
        ORDER BY
            sal
    ) AS prequel_sal
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    LAST_VALUE(sal)
    OVER(PARTITION BY deptno
         ORDER BY sal
    ) AS first_value
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    NTILE(4)
    OVER(
        ORDER BY sal DESC
    )
FROM
    new_emp;

SELECT
    deptno,
    ename,
    sal,
    PERCENT_RANK()
    OVER(
        ORDER BY sal DESC
    ) AS 퍼센트순위
FROM
    new_emp;

SELECT
    *
FROM
    new_emp;

CREATE VIEW view_new_emp AS
    ( SELECT
        ename,
        deptno
    FROM
        new_emp
    );

SELECT
    2
FROM
    dual
UNION
SELECT
    1
FROM
    dual;

SELECT
    level,
    lpad(' ', 4 *(level - 1), ' ')
    || empno,
    mgr
FROM
    new_emp
START WITH
    mgr IS NULL
CONNECT BY
    PRIOR empno = mgr;

SELECT
    *
FROM
    new_emp;

SELECT
    *
FROM
    TABLE ( dbms_xplan.display_cursor(NULL, NULL, 'ALLSTATS LAST') );

SELECT
    *
FROM
         emp a
    INNER JOIN dept b ON a.deptno = b.deptno
                         AND a.ename LIKE '임%';

SELECT
    ename
FROM
    new_emp
WHERE
    empno = 1005;

CREATE TABLE final_test (
    custname  VARCHAR2(20),
    custnum   NUMBER(20),
    CONSTRAINT pk_custnum PRIMARY KEY ( custnum )
);

ALTER TABLE final_test RENAME TO final_test_table;

COMMIT;

ALTER TABLE final_test_table RENAME COLUMN custname TO name;

ALTER TABLE final_test_table ADD (
    custcost NUMBER(4) NOT NULL
);

COMMIT;

ALTER TABLE final_test_table MODIFY (
    custcost NUMBER(6)
);

COMMIT;

ALTER TABLE final_test_table DROP COLUMN custcost;

INSERT INTO final_test_table VALUES (
    '최우석',
    1
);

UPDATE final_test_table
SET
    custnum = 2
WHERE
    custnum = 1;

DELETE FROM final_test_table
WHERE
    custnum = 2;

COMMIT;

INSERT INTO final_test_table VALUES (
    '최우석',
    1
);

INSERT INTO final_test_table VALUES (
    '최민규',
    2
);

COMMIT;

SELECT
    name || '님' AS name
FROM
    final_test_table;

SELECT
    *
FROM
    final_test_table
ORDER BY
    custnum,
    name DESC;

INSERT INTO final_test_talbe VALUES (
    '김동현',
    5
);

INSERT INTO final_test_table VALUES (
    '서문지훈',
    3
);

INSERT INTO final_test_table VALUES (
    '김범수',
    7
);

INSERT INTO final_test_table VALUES (
    '양지원',
    6
);

COMMIT;

SELECT /*+ INDEX_DESC(FINAL_TEST_TABLE PK_CUSTNUM) */ 
        *
FROM
    final_test_table;

INSERT INTO final_test_table VALUES (
    'josh',
    10
);

COMMIT;

SELECT
    upper(name) AS name
FROM
    final_test_table;

SELECT
    substr('ABCDEFG', 3, 2)
FROM
    dual;

SELECT
    CHR(3)
FROM
    dual;

SELECT
    EXTRACT(YEAR FROM sysdate)
FROM
    dual;

SELECT
    round(10.6, 0)
FROM
    dual;

SELECT
    *
FROM
    final_test_table;

SELECT
    name,
    decode(custnum, 7, 'YES', 'NO')
FROM
    final_test_table;

SELECT
    name,
    CASE
        WHEN custnum = 7  THEN
            '7 YES'
        WHEN custnum = 1  THEN
            '1 YES'
        ELSE
            'NO'
    END
FROM
    final_test_table;

SELECT
    ROWNUM,
    name
FROM
    final_test_table;

SELECT
    *
FROM
    (
        SELECT
            ROWNUM AS list,
            name
        FROM
            final_test_table
    )
WHERE
    list BETWEEN 2 AND 7;

SELECT
    ROWID
FROM
    final_test_table;

SELECT
    ROWID
FROM
    new_emp;

SELECT
    ROWID
FROM
    emp;

CREATE VIEW view_test AS
    ( SELECT
        *
    FROM
        final_test_table
    );

GRANT SELECT ON system.final_test_table TO us1152 WITH GRANT OPTION;

GRANT SELECT ON system.final_test_table TO us1152

WITH admin
option;

SELECT
    *
FROM
    emp,
    dept
WHERE
    emp.deptno != dept.deptno;

SELECT
    *
FROM
         emp a
    INNER JOIN dept b ON a.deptno = b.deptno;

SELECT
    *
FROM
         emp
    CROSS JOIN dept;

SELECT
    *
FROM
    new_emp;

SELECT
    level,
    ename,
    empno,
    lpad(' ', 4 *(level - 1), ' ')
    || mgr,
    CONNECT_BY_ROOT empno
FROM
    new_emp
START WITH
    mgr IS NULL
CONNECT BY
    PRIOR empno = mgr;

SELECT
    *
FROM
    new_emp;

SELECT
    *
FROM
    new_emp
WHERE
    deptno = (
        SELECT
            deptno
        FROM
            new_emp
        WHERE
            ename = 'TEST1'
    );

SELECT
    list,
    ename
FROM
    (
        SELECT
            ROWNUM AS list,
            ename
        FROM
            new_emp
    )
WHERE
    list BETWEEN 3 AND 5;

SELECT
    *
FROM
    new_emp;

SELECT
    sal
FROM
    new_emp
WHERE
    job = 'CLERK';

SELECT
    *
FROM
    new_emp
WHERE
    sal > ALL (
        SELECT
            sal
        FROM
            new_emp
        WHERE
            job = 'CLERK'
    );

SELECT
    *
FROM
    dept;

SELECT
    *
FROM
    emp;

SELECT
    *
FROM
    dept d
WHERE
    EXISTS (
        SELECT
            deptno
        FROM
            emp e
        WHERE
            e.deptno = d.deptno
    );

SELECT
    deptno,
    job,
    SUM(sal)
FROM
    new_emp
GROUP BY
    GROUPING SETS ( deptno,
                    job );

SELECT
    deptno,
    SUM(sal)
FROM
    new_emp
GROUP BY
    ROLLUP(deptno);

SELECT
    deptno,
    job,
    SUM(sal)
FROM
    new_emp
GROUP BY
    CUBE(deptno,
         job);

SELECT
    ename,
    job,
    SUM(sal)
    OVER(PARTITION BY job
        ORDER BY
            sal
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
FROM
    new_emp;

SELECT
    ename,
    job,
    sal,
    LEAD(sal)
    OVER(PARTITION BY job
         ORDER BY
             sal
    )
FROM
    new_emp;

DROP TABLE TEST;

CREATE TABLE GROUP_BY_TEST (
    team_no  NUMBER(4),
    name     VARCHAR2(20)
);

INSERT INTO GROUP_BY_TEST VALUES (
    1,
    '김'
);

INSERT INTO GROUP_BY_TEST VALUES (
    1,
    '박'
);

INSERT INTO GROUP_BY_TEST VALUES (
    2,
    '최'
);

INSERT INTO GROUP_BY_TEST VALUES (
    2,
    '이'
);

INSERT INTO GROUP_BY_TEST VALUES (
    NULL,
    '표'
);

COMMIT;

SELECT
    team_no,
    COUNT(team_no)
FROM
    GROUP_BY_TEST
GROUP BY
    team_no;
    
SELECT
    team_no,
    COUNT(*)
FROM
    GROUP_BY_TEST
GROUP BY
    team_no;
    

