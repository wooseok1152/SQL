DROP TABLE emp;
DROP TABLE dept;
DROP TABLE salgrade;

PURGE RECYCLEBIN;

CREATE TABLE dept (
dno VARCHAR2(2),
dname VARCHAR2(10),
loc VARCHAR2(6),
CONSTRAINT dept_dno_pk PRIMARY KEY(dno)
);

CREATE TABLE emp (
eno VARCHAR2(4),
ename VARCHAR2(10),
sex VARCHAR2(2),
job VARCHAR2(8),
mgr VARCHAR2(4),
hdate DATE,
sal NUMBER,
comm NUMBER,
dno VARCHAR2(2),
CONSTRAINT emp_eno_pk PRIMARY KEY (eno),
CONSTRAINT emp_mgr_fk FOREIGN KEY (mgr)  REFERENCES emp (eno),
CONSTRAINT emp_dno_fk FOREIGN KEY (dno)  REFERENCES dept (dno)
);

CREATE TABLE salgrade (
grade NUMBER,
losal NUMBER,
hisal NUMBER
);


DROP TABLE score;
DROP TABLE course;
DROP TABLE professor;
DROP TABLE student;
DROP TABLE scgrade;

PURGE RECYCLEBIN;

CREATE TABLE student (
sno VARCHAR2(8), 
sname VARCHAR2(10),
sex VARCHAR2(4),
syear NUMBER(1),
major VARCHAR2(10),
avr NUMBER(4,2),
CONSTRAINT student_sno_pk PRIMARY KEY(sno)
);

CREATE TABLE professor (
pno VARCHAR2(8), 
pname VARCHAR2(10),
section VARCHAR2(10),
orders VARCHAR2(10),
hiredate DATE,
CONSTRAINT professor_pno_pk PRIMARY KEY(pno)
);

CREATE TABLE course (
cno VARCHAR2(8),
cname VARCHAR2(14),
st_num NUMBER,
pno VARCHAR2(8),
CONSTRAINT course_cno_pk PRIMARY KEY (cno),
CONSTRAINT course_pno_fk FOREIGN KEY (pno)  REFERENCES professor (pno)
);

CREATE TABLE score (
sno VARCHAR2(8),
cno VARCHAR2(8),
result NUMBER,
CONSTRAINT score_sno_cno_pk PRIMARY KEY (sno,cno),
CONSTRAINT score_sno_fk FOREIGN KEY (sno)  REFERENCES student (sno),
CONSTRAINT score_cno_fk FOREIGN KEY (cno)  REFERENCES course (cno)
); 


alter session set nls_DATE_format='YYYY/MM/DD';
set line 100
set pages 200
col dno format a4
col dname format a10
col loc format a6
col eno format a8
col ename format a10
col sex format a3
col job format a6
col mgr format a5
col sname format a10
col pname format a10
col cname format a14
col sno format a8
col sex format a4
col major format a6
col 상위테이블 format a10
col 상위제약조건 format a20
col 하위테이블 format a10
col 참조제약조건 format a20
col INDEX_NAME format a30
col COLUMN_EXPRESSION format a60
col VIEW_NAME format a30
col text format a60
col SEQUENCE_NAME format a20

SELECT * FROM dept;
SELECT * FROM emp;
SELECT * FROM salgrade;
SELECT * FROM student;
SELECT * FROM professor;
SELECT * FROM course;
SELECT * FROM score WHERE rownum < 10;


SELECT count(*) dept FROM dept;
SELECT count(*) emp FROM emp;
SELECT count(*) salgrade FROM salgrade;

SELECT count(*) student FROM student;
SELECT count(*) professor FROM professor;
SELECT count(*) course FROM course;
SELECT count(*) score FROM score;