SELECT DECODE(LENGTH(ANSWER), 
              5, SUBSTR(ANSWER, 1, 1) || '����', 
              6, SUBSTR(ANSWER, 1, 1) || '�ʸ���', 
              7, SUBSTR(ANSWER, 1, 1) || '�鸸��',
              8, SUBSTR(ANSWER, 1, 1) || 'õ����',
              9, SUBSTR(ANSWER, 1, 1) || '���',
              10, SUBSTR(ANSWER, 1, 1) || '�ʾ��',
              11, SUBSTR(ANSWER, 1, 1) || '����',
              12, SUBSTR(ANSWER, 1, 1) || 'õ���',
              13, SUBSTR(ANSWER, 1, 1) || '����',
              14, SUBSTR(ANSWER, 1, 1) || '������',
              15, SUBSTR(ANSWER, 1, 1) || '������',
              16, SUBSTR(ANSWER, 1, 1) || 'õ����',
              TRIM(TO_CHAR(TRUNC(ANSWER, -1 * LENGTH(ANSWER) + 1), '999,999,999,999,999,999,999,999')) || '��') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER    -- ���� TRUNC : ��� �ݾ��� �Ҽ������� ������ ���, �ش� �Ҽ��� ���� �ǽ�, 
                                                                                   -- �ܺ� TRUNC : ���� ���� �ڸ� ���ڸ� ������ ������ �ڸ� ���ڸ� 0���� ��ȯ
    FROM DUAL
)

UNION ALL

SELECT DECODE(LENGTH(ANSWER / 2), 
              5, SUBSTR(ANSWER / 2, 1, 1) || '����', 
              6, SUBSTR(ANSWER / 2, 1, 1) || '�ʸ���', 
              7, SUBSTR(ANSWER / 2, 1, 1) || '�鸸��',
              8, SUBSTR(ANSWER / 2, 1, 1) || 'õ����',
              9, SUBSTR(ANSWER / 2, 1, 1) || '���',
              10, SUBSTR(ANSWER / 2, 1, 1) || '�ʾ��',
              11, SUBSTR(ANSWER / 2, 1, 1) || '����',
              12, SUBSTR(ANSWER / 2, 1, 1) || 'õ���',
              13, SUBSTR(ANSWER / 2, 1, 1) || '����',
              14, SUBSTR(ANSWER / 2, 1, 1) || '������',
              15, SUBSTR(ANSWER / 2, 1, 1) || '������',
              16, SUBSTR(ANSWER / 2, 1, 1) || 'õ����',
              TRIM(TO_CHAR(TRUNC(TRUNC(ANSWER / 2), -1 * LENGTH(TRUNC(ANSWER / 2)) + 1), '999,999,999,999,999,999,999,999')) || '��') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER
    FROM DUAL
)

UNION ALL

SELECT DECODE(LENGTH(ANSWER / 4), 
              5, SUBSTR(ANSWER / 4, 1, 1) || '����', 
              6, SUBSTR(ANSWER / 4, 1, 1) || '�ʸ���', 
              7, SUBSTR(ANSWER / 4, 1, 1) || '�鸸��',
              8, SUBSTR(ANSWER / 4, 1, 1) || 'õ����',
              9, SUBSTR(ANSWER / 4, 1, 1) || '���',
              10, SUBSTR(ANSWER / 4, 1, 1) || '�ʾ��',
              11, SUBSTR(ANSWER / 4, 1, 1) || '����',
              12, SUBSTR(ANSWER / 4, 1, 1) || 'õ���',
              13, SUBSTR(ANSWER / 4, 1, 1) || '����',
              14, SUBSTR(ANSWER / 4, 1, 1) || '������',
              15, SUBSTR(ANSWER / 4, 1, 1) || '������',
              16, SUBSTR(ANSWER / 4, 1, 1) || 'õ����',
              TRIM(TO_CHAR(TRUNC(TRUNC(ANSWER / 4), -1 * LENGTH(TRUNC(ANSWER / 4)) + 1), '999,999,999,999,999,999,999,999')) || '��') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER
    FROM DUAL
);