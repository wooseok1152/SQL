-- 날짜 format 변경하는 방법
ALTER SESSION SET nls_date_format = 'YYYY/MM/DD';

SELECT SYSDATE FROM DUAL;

-- '2016/12/14'는 문자열이지만, 암묵적으로 DATE Type으로 변형되어 'ADD_MONTHS'함수 연산처리 된다.('20161214'와 같은 형식도 마찬가지다.)
SELECT ADD_MONTHS('2016/12/14', 2) FROM DUAL;
