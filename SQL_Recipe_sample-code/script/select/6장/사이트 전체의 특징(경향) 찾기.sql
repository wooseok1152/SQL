-- 주어진 기간 內, 날짜별 접근 데이터를 집계하는 쿼리

SELECT SUBSTR(STAMP, 1, 10) AS BASE_DATE,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM ACCESS_LOG
GROUP BY SUBSTR(STAMP, 1, 10)
ORDER BY BASE_DATE;

-- 주어진 기간 內, URL별로 집계하는 쿼리

SELECT URL,
       COUNT(DISTINCT LONG_SESSION) AS ACCESS_USER_CNT,
       COUNT(DISTINCT SHORT_SESSION) AS ACCESS_CNT,
       COUNT(1) AS PAGE_VIEW_CNT
FROM ACCESS_LOG
GROUP BY URL
ORDER BY URL;

-- 주어진 기간 內, 경로별로 집계하는 쿼리

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

-- 주어진 기간 內, URL에 의미를 부여해서 집계하는 쿼리

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

-- 유입원별로 방문 횟수를 집계하는 쿼리

SELECT VIA,
       COUNT(1) AS ACCESS_CNT
FROM (
    SELECT  STAMP,
            LONG_SESSION,
            SHORT_SESSION,
            CASE 
                WHEN URL_UTM_SOURCE IS NOT NULL AND URL_UTM_MEDIUM IS NOT NULL
                     THEN URL_UTM_SOURCE || '-' || URL_UTM_MEDIUM
                ELSE CASE 
                          WHEN REGEXP_SUBSTR(REFERRER_DOMAIN, 'google') IS NOT NULL OR REGEXP_SUBSTR(REFERRER_DOMAIN, 'yahoo') IS NOT NULL 
                               THEN 'search'
                          WHEN REGEXP_SUBSTR(REFERRER_DOMAIN, 'twitter') IS NOT NULL OR REGEXP_SUBSTR(REFERRER_DOMAIN, 'facebook') IS NOT NULL 
                               THEN 'social'
                          ELSE 'other'
                     END
                END AS VIA
    FROM (
        SELECT URL,
               REGEXP_REPLACE(REGEXP_SUBSTR(URL, 'https?://[^/]*'), 'https?://', '') AS URL_DOMAIN,
               REGEXP_REPLACE(REGEXP_SUBSTR(URL, 'utm_source=[^&]*'), 'utm_source=', '') AS URL_UTM_SOURCE,
               REGEXP_REPLACE(REGEXP_SUBSTR(URL, 'utm_medium=[^&]*'), 'utm_medium=', '') AS URL_UTM_MEDIUM,
               REGEXP_REPLACE(REGEXP_SUBSTR(REFERRER, 'https?://[^/]*'), 'https?://', '') AS REFERRER_DOMAIN,
               LONG_SESSION,
               SHORT_SESSION,
               STAMP
        FROM   ACCESS_LOG
    )
    WHERE REFERRER_DOMAIN IS NOT NULL
          AND REFERRER_DOMAIN != URL_DOMAIN
)
GROUP BY VIA
ORDER BY ACCESS_CNT DESC
;

-- 