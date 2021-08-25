SELECT DECODE(LENGTH(ANSWER), 
              5, SUBSTR(ANSWER, 1, 1) || '만원', 
              6, SUBSTR(ANSWER, 1, 1) || '십만원', 
              7, SUBSTR(ANSWER, 1, 1) || '백만원',
              8, SUBSTR(ANSWER, 1, 1) || '천만원',
              9, SUBSTR(ANSWER, 1, 1) || '억원',
              10, SUBSTR(ANSWER, 1, 1) || '십억원',
              11, SUBSTR(ANSWER, 1, 1) || '백억원',
              12, SUBSTR(ANSWER, 1, 1) || '천억원',
              13, SUBSTR(ANSWER, 1, 1) || '조원',
              14, SUBSTR(ANSWER, 1, 1) || '십조원',
              15, SUBSTR(ANSWER, 1, 1) || '백조원',
              16, SUBSTR(ANSWER, 1, 1) || '천조원',
              TRIM(TO_CHAR(TRUNC(ANSWER, -1 * LENGTH(ANSWER) + 1), '999,999,999,999,999,999,999,999')) || '원') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER    -- 내부 TRUNC : 결과 금액이 소수점으로 나오는 경우, 해당 소수점 절사 실시, 
                                                                                   -- 외부 TRUNC : 가장 높은 자리 숫자를 제외한 나머지 자리 숫자를 0으로 변환
    FROM DUAL
)

UNION ALL

SELECT DECODE(LENGTH(ANSWER / 2), 
              5, SUBSTR(ANSWER / 2, 1, 1) || '만원', 
              6, SUBSTR(ANSWER / 2, 1, 1) || '십만원', 
              7, SUBSTR(ANSWER / 2, 1, 1) || '백만원',
              8, SUBSTR(ANSWER / 2, 1, 1) || '천만원',
              9, SUBSTR(ANSWER / 2, 1, 1) || '억원',
              10, SUBSTR(ANSWER / 2, 1, 1) || '십억원',
              11, SUBSTR(ANSWER / 2, 1, 1) || '백억원',
              12, SUBSTR(ANSWER / 2, 1, 1) || '천억원',
              13, SUBSTR(ANSWER / 2, 1, 1) || '조원',
              14, SUBSTR(ANSWER / 2, 1, 1) || '십조원',
              15, SUBSTR(ANSWER / 2, 1, 1) || '백조원',
              16, SUBSTR(ANSWER / 2, 1, 1) || '천조원',
              TRIM(TO_CHAR(TRUNC(TRUNC(ANSWER / 2), -1 * LENGTH(TRUNC(ANSWER / 2)) + 1), '999,999,999,999,999,999,999,999')) || '원') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER
    FROM DUAL
)

UNION ALL

SELECT DECODE(LENGTH(ANSWER / 4), 
              5, SUBSTR(ANSWER / 4, 1, 1) || '만원', 
              6, SUBSTR(ANSWER / 4, 1, 1) || '십만원', 
              7, SUBSTR(ANSWER / 4, 1, 1) || '백만원',
              8, SUBSTR(ANSWER / 4, 1, 1) || '천만원',
              9, SUBSTR(ANSWER / 4, 1, 1) || '억원',
              10, SUBSTR(ANSWER / 4, 1, 1) || '십억원',
              11, SUBSTR(ANSWER / 4, 1, 1) || '백억원',
              12, SUBSTR(ANSWER / 4, 1, 1) || '천억원',
              13, SUBSTR(ANSWER / 4, 1, 1) || '조원',
              14, SUBSTR(ANSWER / 4, 1, 1) || '십조원',
              15, SUBSTR(ANSWER / 4, 1, 1) || '백조원',
              16, SUBSTR(ANSWER / 4, 1, 1) || '천조원',
              TRIM(TO_CHAR(TRUNC(TRUNC(ANSWER / 4), -1 * LENGTH(TRUNC(ANSWER / 4)) + 1), '999,999,999,999,999,999,999,999')) || '원') 
              
FROM (
    SELECT TRUNC(TRUNC(143414325), -1 * LENGTH(TRUNC(143414325)) + 1) AS ANSWER
    FROM DUAL
);