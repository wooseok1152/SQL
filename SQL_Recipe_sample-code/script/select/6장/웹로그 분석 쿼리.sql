-- 날짜별 접근 데이터를 집계하는 쿼리

SELECT SUBSTR(STAMP, 1, 10) AS BASE_DATE,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM ACCESS_LOG
GROUP BY SUBSTR(STAMP, 1, 10)
ORDER BY BASE_DATE;

-- URL별로 집계하는 쿼리

SELECT URL,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM ACCESS_LOG
GROUP BY URL
ORDER BY URL;

-- 경로별로 집계하는 쿼리

SELECT URL_PATH,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM (
    SELECT URL,
           REGEXP_REPLACE(REGEXP_SUBSTR(URL, '//[^?#]+'), '//[^/]+', '') AS URL_PATH,
           LONG_SESSION,
           SHORT_SESSION
    FROM ACCESS_LOG
)
GROUP BY URL_PATH
ORDER BY URL_PATH;

-- URL에 의미를 부여해서 집계하는 쿼리

SELECT PAGE_NAME,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM (
    SELECT URL,
           URL_PATH,
           CASE 
                WHEN URL_PATH = '/' THEN 'HOME_PAGE'
                WHEN URL_PATH = '/detail' THEN 'DETAIL_PAGE'
                ELSE
                     CASE 
                          WHEN PATH2 = '/newly' THEN 'NEWLY_LIST_PAGE'
                          ELSE 'CATEGORY_LIST_PAGE'
                     END
           END AS PAGE_NAME,
           LONG_SESSION,
           SHORT_SESSION
    FROM (
        SELECT URL,
               URL_PATH,
               SUBSTR(URL_PATH, INSTR(URL_PATH, '/', 1, 1), INSTR(URL_PATH, '/', 1, 2) - INSTR(URL_PATH, '/', 1, 1)) AS PATH1,
               CASE 
                    WHEN INSTR(URL_PATH, '/', 1, 2) = 0 THEN NULL
                    ELSE SUBSTR(URL_PATH, INSTR(URL_PATH, '/', 1, 2))
               END AS PATH2,
               LONG_SESSION,
               SHORT_SESSION
        FROM (
            SELECT URL,
                   REGEXP_REPLACE(REGEXP_SUBSTR(URL, '//[^?#]+'), '//[^/]+', '') AS URL_PATH,
                   LONG_SESSION,
                   SHORT_SESSION
            FROM ACCESS_LOG
        )
    )
)
GROUP BY PAGE_NAME
ORDER BY PAGE_NAME
;