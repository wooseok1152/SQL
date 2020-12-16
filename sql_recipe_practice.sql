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

/* WINDOW함수 사용법 */
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



