CREATE TABLE DEPT
(
 deptno VARCHAR2(4),
 deptname VARCHAR2(20),
 CONSTRAINT dptnopk PRIMARY KEY(deptno)
);

INSERT INTO DEPT VALUES('1000', '�λ���');
INSERT INTO DEPT VALUES('1001', '�ѹ���');

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

INSERT INTO EMP VALUES(100, '�Ӻ���Ʈ', 1000, '1000', sysdate);
INSERT INTO EMP VALUES(101, '��������', 2000, '1001', sysdate);

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

INSERT INTO new_emp VALUES(102, '�����ٶ�', 3000, '1001', sysdate);
UPDATE new_emp SET SAL = 4000 WHERE SAL = 3000;
SELECT * FROM NEW_EMP;

DELETE FROM new_emp WHERE new_ename = '�����ٶ�';

SELECT EMPNO, NEW_ENAME || '��' FROM NEW_EMP;