-- 기본으로 설정되어 있는 날짜 format을 변경하는 방법
ALTER SESSION SET nls_date_format = 'YYYY/MM/DD';

SELECT SYSDATE FROM DUAL;

-- '2016/12/14'는 문자열이지만, 암묵적으로 DATE Type으로 변형되어 'ADD_MONTHS'함수 연산처리 된다.('20161214'와 같은 형식도 마찬가지다.)
SELECT ADD_MONTHS('2016/12/14', 2) FROM DUAL;

-- 'TO_CHAR()'함수 사용법
SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;

-- 'TO_DATE()'함수 사용법
SELECT TO_DATE('2016/01/02', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2016/01/02', 'YYYY/MM/DD'), 'YYYY') FROM DUAL;