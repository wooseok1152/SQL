-- �⺻���� �����Ǿ� �ִ� ��¥ format�� �����ϴ� ���
ALTER SESSION SET nls_date_format = 'YYYY/MM/DD';

SELECT SYSDATE FROM DUAL;

-- '2016/12/14'�� ���ڿ�������, �Ϲ������� DATE Type���� �����Ǿ� 'ADD_MONTHS'�Լ� ����ó�� �ȴ�.('20161214'�� ���� ���ĵ� ����������.)
SELECT ADD_MONTHS('2016/12/14', 2) FROM DUAL;

-- 'TO_CHAR()'�Լ� ����
SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;

-- 'TO_DATE()'�Լ� ����
SELECT TO_DATE('2016/01/02', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2016/01/02', 'YYYY/MM/DD'), 'YYYY') FROM DUAL;