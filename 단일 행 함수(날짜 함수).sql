-- ��¥ format �����ϴ� ���
ALTER SESSION SET nls_date_format = 'YYYY/MM/DD';

SELECT SYSDATE FROM DUAL;

-- '2016/12/14'�� ���ڿ�������, �Ϲ������� DATE Type���� �����Ǿ� 'ADD_MONTHS'�Լ� ����ó�� �ȴ�.('20161214'�� ���� ���ĵ� ����������.)
SELECT ADD_MONTHS('2016/12/14', 2) FROM DUAL;
