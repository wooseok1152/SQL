/* REFERRER의 domian만 가져오기 */
DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log 
(
stamp    varchar2(255),
referrer varchar2(255),
url      varchar2(255)
);

INSERT INTO access_log VALUES ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php1', 'http://www.example.com/video/detail?id=001');
INSERT INTO access_log VALUES ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?', 'http://www.example.com/video#ref');
INSERT INTO access_log VALUES ('2016-08-26 12:02:01', 'https://www.other.com/', 'http://www.example.com/book/detail?id=002' );

commit;

SELECT * FROM ACCESS_LOG;

SELECT RTRIM(LTRIM(SUBSTR(REFERRER, INSTR(REFERRER, '/', 1, 2), INSTR(REFERRER, '/', 9, 1)), '/'), '/') AS INSTR_TEST FROM ACCESS_LOG;

/* URL을 parsing하기 */
SELECT * FROM ACCESS_LOG;
SELECT URL as original, regexp_substr(url, '[^/?#]+', 1, 2) AS HOST, regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 1) AS PATH1, case when regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 2) like 'ref%' then ' ' else regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 2) end as path2   from access_log;

/* TIME type, TIMESTAMP type, EXTRACT 함수 사용법, type 변형 함수 */
CREATE TABLE DATE_AND_TIMESTAMP_TEST
(
CREATEDATE DATE
);

INSERT INTO DATE_AND_TIMESTAMP_TEST VALUES(SYSDATE);
COMMIT;

SELECT EXTRACT(DAY FROM CREATEDATE) FROM DATE_AND_TIMESTAMP_TEST;
SELECT TO_CHAR(CREATEDATE, 'YYYY-MM-DD') FROM DATE_AND_TIMESTAMP_TEST;

/* coalesce()함수 활용법 */
DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar2(255)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon VALUES('10001', 3280, NULL);
INSERT INTO purchase_log_with_coupon VALUES('10002', 4650,  500);
INSERT INTO purchase_log_with_coupon VALUES('10003', 3870, NULL);
commit;

select amount - coalesce(coupon, 0) as discounted_amount from purchase_log_with_coupon;

/* concat()함수 활용법 */
DROP TABLE IF EXISTS mst_user_location;
CREATE TABLE mst_user_location 
(
    user_id   varchar2(255)
  , pref_name varchar2(255)
  , city_name varchar2(255)
);

INSERT INTO mst_user_location VALUES ('U001', '서울특별시', '강서구');
INSERT INTO mst_user_location VALUES ('U002', '경기도수원시', '장안구'  );
INSERT INTO mst_user_location VALUES ('U003', '제주특별자치도', '서귀포시');
commit;

select PREF_NAME || ' ' || CITY_NAME AS PREF_CITY from mst_user_location;

/* 여러 개의 값 비교하는 방법(COALESCE 함수 사용법) */
DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales 
(
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales VALUES (2015, 82000, 83000, 78000, 83000);
INSERT INTO quarterly_sales VALUES (2016, 85000, 85000, 80000, 81000);
INSERT INTO quarterly_sales VALUES (2017, 92000, 81000, NULL , NULL );
COMMIT;

SELECT * FROM quarterly_sales ;
WITH VIEWDATA AS(SELECT COALESCE(Q1, Q2, Q3, Q4) AS Q1, COALESCE(Q2, Q1, Q3, Q4) AS Q2, COALESCE(Q3, Q1, Q3, Q4) AS Q3, COALESCE(Q4, Q1, Q3, Q4) AS Q4 FROM QUARTERLY_SALES) SELECT GREATEST(Q1, Q2, Q3, Q4) AS GREATEST_QUARTER, LEAST(Q1, Q2, Q3, Q4) AS LEAST_QUARTER FROM VIEWDATA;

/* 0으로 나누는 상황을 피하는 방법(case 문으로 해결) */
DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats 
(
    dt          varchar2(255)
  , ad_id       varchar2(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats VALUES ('2017-04-01', '001', 100000,  3000);
INSERT INTO advertising_stats VALUES ('2017-04-01', '002', 120000,  1200);
INSERT INTO advertising_stats VALUES ('2017-04-01', '003', 500000, 10000);
INSERT INTO advertising_stats VALUES ('2017-04-02', '001',      0,     0);
INSERT INTO advertising_stats VALUES ('2017-04-02', '002', 130000,  1400);
INSERT INTO advertising_stats VALUES ('2017-04-02', '003', 620000, 15000);
COMMIT;

SELECT dt, ad_id, case when impressions > 0 then round(100.0 * clicks / impressions, 2) else null end as ctr_as_percent_by_case from advertising_stats;

-- 날짜/시간 계산하기(INTERVAL키워드 사용하여 시간의 더하기/빼기 실시)
DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates VALUES ('U001', '2016-02-28 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U002', '2016-02-29 10:00:00', '2000-02-29');
INSERT INTO mst_users_with_dates VALUES ('U003', '2016-03-01 10:00:00', '2000-02-29');

SELECT * FROM MST_USERS_WITH_DATES;
SELECT TO_TIMESTAMP(REGISTER_STAMP) + INTERVAL '5' HOUR FROM MST_USERS_WITH_DATES;

-- 문자열을 DATE type으로 변형하는 방법1
SELECT TO_DATE(STAMP, 'YYYY-MM-DD HH24:MI:SS') FROM ACCESS_LOG;
-- 문자열을 DATE type으로 변형하는 방법2(해당 문자열을 TIMESTAMP type으로 먼저 변형시킨 뒤, 해당 TIMESTAMP type을 DATE type으로 변형시킨다.)
SELECT CAST(TO_TIMESTAMP(REGISTER_STAMP) AS DATE) FROM MST_USERS_WITH_DATES;

SELECT * FROM ACCESS_LOG;

WITH VIEWDATA AS(SELECT CASE WHEN SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '?', 1, 1) - INSTR(URL, '/', 1, 3)) IS NULL THEN ' ' ELSE SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '?', 1, 1) - INSTR(URL, '/', 1, 3))END AS RESULT1, CASE WHEN SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '#', 1, 1) - INSTR(URL, '/', 1, 3)) IS NULL THEN ' ' ELSE SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '#', 1, 1) - INSTR(URL, '/', 1, 3)) END AS RESULT2 FROM ACCESS_LOG) SELECT RESULT1||RESULT2 AS FINAL FROM VIEWDATA;

/* 기본적인 WINDOW함수 사용법 */
DROP TABLE IF EXISTS review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review VALUES('U001', 'A001', 4.0);
INSERT INTO review VALUES('U001', 'A002', 5.0);
INSERT INTO review VALUES('U001', 'A003', 5.0);
INSERT INTO review VALUES('U002', 'A001', 3.0);
INSERT INTO review VALUES('U002', 'A002', 3.0);
INSERT INTO review VALUES('U002', 'A003', 4.0);
INSERT INTO review VALUES('U003', 'A001', 5.0);
INSERT INTO review VALUES('U003', 'A002', 4.0);
INSERT INTO review VALUES('U003', 'A003', 4.0);

SELECT * FROM REVIEW;
SELECT USER_ID, SCORE, ROUND(AVG(SCORE) OVER()) AS AVG_WITH_WHOLE, ROUND(AVG(SCORE) OVER(PARTITION BY USER_ID)) AS AVG_BY_USER_ID FROM REVIEW;

/* PARTITION BY구문과 ORDER BY구문을 동시에 사용하는 WINDOW함수 활용법 */
DROP TABLE IF EXISTS popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products VALUES('A001', 'action', 94);
INSERT INTO popular_products VALUES('A002', 'action', 81);
INSERT INTO popular_products VALUES('A003', 'action', 78);
INSERT INTO popular_products VALUES('A004', 'action', 64);
INSERT INTO popular_products VALUES('D001', 'drama' , 90);
INSERT INTO popular_products VALUES('D002', 'drama' , 82);
INSERT INTO popular_products VALUES('D003', 'drama' , 78);
INSERT INTO popular_products VALUES('D004', 'drama' , 58);
COMMIT;

WITH WINDOW_RANKED_TABLE AS(SELECT CATEGORY, PRODUCT_ID, SCORE, ROW_NUMBER() OVER (PARTITION BY CATEGORY ORDER BY SCORE DESC) AS RANK FROM POPULAR_PRODUCTS) 
SELECT CATEGORY, PRODUCT_ID FROM WINDOW_RANKED_TABLE WHERE RANK = 1 ORDER BY CATEGORY DESC;

/* 레코드를 열로 변환하기 */
DROP TABLE IF EXISTS daily_kpi;
CREATE TABLE daily_kpi (
    dt        varchar(255)
  , indicator varchar(255)
  , val       NUMBER(10)
);

INSERT INTO daily_kpi VALUES('2017-01-01', 'impressions', 1800);
INSERT INTO daily_kpi VALUES('2017-01-01', 'sessions'   ,  500);
INSERT INTO daily_kpi VALUES('2017-01-01', 'users'      ,  200);
INSERT INTO daily_kpi VALUES('2017-01-02', 'impressions', 2000);
INSERT INTO daily_kpi VALUES('2017-01-02', 'sessions'   ,  700);
INSERT INTO daily_kpi VALUES('2017-01-02', 'users'      ,  250);
COMMIT;

SELECT * FROM daily_kpi;
SELECT DT, MAX(CASE WHEN INDICATOR = 'IMPRESSIONS' THEN VAL END) AS IMPRESSIONS, MAX(CASE WHEN INDICATOR = 'SESSIONS' THEN VAL END) AS sessions, MAX(CASE WHEN INDICATOR = 'USERS' THEN VAL END) AS users FROM daily_kpi GROUP BY DT ORDER BY DT;

/* 특정 레코드들을 쉼표로 구분한 문자열로 집약하기(LISTAGG()함수 사용법) */
DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log 
(
    purchase_id integer
  , product_id varchar(255)
  , price integer
);

INSERT INTO purchase_detail_log VALUES(100001, 'A001', 300);
INSERT INTO purchase_detail_log VALUES(100001, 'A002', 400);
INSERT INTO purchase_detail_log VALUES(100001, 'A003', 200);
INSERT INTO purchase_detail_log VALUES(100002, 'D001', 500);
INSERT INTO purchase_detail_log VALUES(100002, 'D001', 300);
INSERT INTO purchase_detail_log VALUES(100003, 'A001', 300);

SELECT * FROM PURCHASE_DETAIL_LOG;
SELECT PURCHASE_ID, LISTAGG(PRODUCT_ID, ', ') WITHIN GROUP(ORDER BY PRODUCT_ID) FROM PURCHASE_DETAIL_LOG GROUP BY PURCHASE_ID; 

/* 열로 표현된 값을 행으로 변환하기 */
DROP TABLE IF EXISTS quarterly_sales2;
CREATE TABLE quarterly_sales2 (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales2 VALUES (2015, 82000, 83000, 78000, 83000);
INSERT INTO quarterly_sales2 VALUES (2016, 85000, 85000, 80000, 81000);
INSERT INTO quarterly_sales2 VALUES (2017, 92000, 81000, NULL , NULL );

SELECT Q.YEAR, CASE WHEN P.IDX = 1 THEN 'Q1' WHEN P.IDX = 2 THEN 'Q2' WHEN P.IDX = 3 THEN 'Q3' WHEN P.IDX = 4 THEN 'Q4' END AS QUARTER, CASE WHEN P.IDX = 1 THEN Q.Q1 WHEN P.IDX = 2 THEN Q.Q2 WHEN P.IDX = 3 THEN Q.Q3 WHEN P.IDX = 4 THEN Q.Q4 END AS SALES FROM QUARTERLY_SALES2 Q CROSS JOIN (SELECT 1 AS IDX FROM DUAL UNION ALL SELECT 2 AS IDX FROM DUAL UNION ALL SELECT 3 AS IDX FROM DUAL UNION ALL SELECT 4 AS IDX FROM DUAL) P;

/* JOIN을 사용하여 두 테이블을 가로로 연결하기 */
DROP TABLE IF EXISTS mst_categories;
CREATE TABLE mst_categories (
    category_id integer
  , name        varchar(255)
);

INSERT INTO mst_categories VALUES(1, 'dvd');
INSERT INTO mst_categories VALUES(2, 'cd');
INSERT INTO mst_categories VALUES(3, 'book');

DROP TABLE IF EXISTS category_sales;
CREATE TABLE category_sales (
    category_id integer
  , sales       integer
);

INSERT INTO category_sales VALUES(1, 850000);
INSERT INTO category_sales VALUES(2, 500000);

DROP TABLE IF EXISTS product_sale_ranking;
CREATE TABLE product_sale_ranking (
    category_id integer
  , rank        integer
  , product_id  varchar(255)
  , sales       integer
);

INSERT INTO product_sale_ranking VALUES(1, 1, 'D001', 50000);
INSERT INTO product_sale_ranking VALUES(1, 2, 'D002', 20000);
INSERT INTO product_sale_ranking VALUES(1, 3, 'D003', 10000);
INSERT INTO product_sale_ranking VALUES(2, 1, 'C001', 30000);
INSERT INTO product_sale_ranking VALUES(2, 2, 'C002', 20000);
INSERT INTO product_sale_ranking VALUES(2, 3, 'C003', 10000);

SELECT * FROM MST_CATEGORIES M JOIN CATEGORY_SALES S ON m.category_id = s.category_id JOIN PRODUCT_SALE_RANKING R ON M.CATEGORY_ID = R.CATEGORY_ID;
SELECT M.CATEGORY_ID, M.NAME, R.PRODUCT_ID, S.SALES FROM (MST_CATEGORIES M LEFT JOIN PRODUCT_SALE_RANKING R ON m.category_id = R.CATEGORY_ID) LEFT JOIN CATEGORY_SALES S ON M.CATEGORY_ID = S.CATEGORY_ID WHERE R.RANK = 1 OR R.RANK IS NULL;

/* 조건 플래그를 0과 1로 표현하기 */
DROP TABLE IF EXISTS mst_users_with_card_number;
CREATE TABLE mst_users_with_card_number 
(
    user_id     varchar(255)
  , card_number varchar(255)
);

INSERT INTO mst_users_with_card_number VALUES('U001', '1234-xxxx-xxxx-xxxx');
INSERT INTO mst_users_with_card_number VALUES('U002', NULL                 );
INSERT INTO mst_users_with_card_number VALUES('U003', '5678-xxxx-xxxx-xxxx');

DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log 
(
    purchase_id integer
  , user_id     varchar(255)
  , amount      integer
  , stamp       varchar(255)
);

INSERT INTO purchase_log VALUES(10001, 'U001', 200, '2017-01-30 10:00:00');
INSERT INTO purchase_log VALUES(10002, 'U001', 500, '2017-02-10 10:00:00');
INSERT INTO purchase_log VALUES(10003, 'U001', 200, '2017-02-12 10:00:00');
INSERT INTO purchase_log VALUES(10004, 'U002', 800, '2017-03-01 10:00:00');
INSERT INTO purchase_log VALUES(10005, 'U002', 400, '2017-03-02 10:00:00');

SELECT * FROM MST_USERS_WITH_CARD_NUMBER M LEFT JOIN PURCHASE_LOG P ON M.USER_ID = P.user_id;
SELECT M.USER_ID, M.CARD_NUMBER, COUNT(P.PURCHASE_ID) AS PURCHASE_COUNT, CASE WHEN COUNT(P.PURCHASE_ID) = 0 THEN 0 ELSE 1 END AS HAS_PURCHASED,  CASE WHEN COUNT(M.CARD_NUMBER) = 0 THEN 0 ELSE 1 END AS HAS_CARD FROM MST_USERS_WITH_CARD_NUMBER M LEFT JOIN PURCHASE_LOG P ON M.USER_ID = P.user_id GROUP BY M.USER_ID, M.CARD_NUMBER;

/* WITH구문 활용하는 법 */
DROP TABLE IF EXISTS product_sales;
CREATE TABLE product_sales 
(
    category_name varchar(255)
  , product_id    varchar(255)
  , sales         integer
);

INSERT INTO product_sales VALUES('dvd' , 'D001', 50000);
INSERT INTO product_sales VALUES('dvd' , 'D002', 20000);
INSERT INTO product_sales VALUES('dvd' , 'D003', 10000);
INSERT INTO product_sales VALUES('cd'  , 'C001', 30000);
INSERT INTO product_sales VALUES('cd'  , 'C002', 20000);
INSERT INTO product_sales VALUES('cd'  , 'C003', 10000);
INSERT INTO product_sales VALUES('book', 'B001', 20000);
INSERT INTO product_sales VALUES('book', 'B002', 15000);
INSERT INTO product_sales VALUES('book', 'B003', 10000);
INSERT INTO product_sales VALUES('book', 'B004',  5000);
COMMIT;

SELECT * FROM PRODUCT_SALES;

-- 카테고리별 순위를 추가한 테이블 조회
SELECT CATEGORY_NAME, SALES, ROW_NUMBER() 
OVER(PARTITION BY CATEGORY_NAME ORDER BY SALES) 
AS RANK 
FROM PRODUCT_SALES;

-- 카테고리들의 순위에서 유니크한 순위 목록을 조회
WITH RANKED_PRODUCT_SALES AS
(
SELECT CATEGORY_NAME, SALES, ROW_NUMBER() 
OVER(PARTITION BY CATEGORY_NAME ORDER BY SALES) 
AS RANK 
FROM PRODUCT_SALES
), MST_RANK AS
(SELECT DISTINCT RANK 
FROM RANKED_PRODUCT_SALES
) 
SELECT * FROM MST_RANK;

-- 
WITH RANKED_PRODUCT_SALES AS
(
SELECT CATEGORY_NAME, SALES, ROW_NUMBER() 
OVER(PARTITION BY CATEGORY_NAME ORDER BY SALES) 
AS RANK 
FROM PRODUCT_SALES
), MST_RANK AS
(SELECT DISTINCT RANK 
FROM RANKED_PRODUCT_SALES
) 
SELECT * 
FROM MST_RANK AS M LEFT JOIN RANKED_PRODUCT_SALES R1 ON M.RANK = R1.RANK AND R1.CATEGORY_NAME = 'DVD';



