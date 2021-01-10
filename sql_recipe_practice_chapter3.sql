/* REFERRER�� domian�� �������� */
                drop TABLE if exists access_log;
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

/* URL�� parsing�ϱ� */
SELECT * FROM ACCESS_LOG;
SELECT URL as original, regexp_substr(url, '[^/?#]+', 1, 2) AS HOST, regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 1) AS PATH1, case when regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 2) like 'ref%' then ' ' else regexp_substr(substr(url, instr(url, '/', 1, 3)), '[^?#]+', 1, 2) end as path2   from access_log;

/* TIME type, TIMESTAMP type, EXTRACT �Լ� ����, type ���� �Լ� */
CREATE TABLE DATE_AND_TIMESTAMP_TEST
(
CREATEDATE DATE
);

INSERT INTO DATE_AND_TIMESTAMP_TEST VALUES(SYSDATE);
COMMIT;

SELECT EXTRACT(DAY FROM CREATEDATE) FROM DATE_AND_TIMESTAMP_TEST;
SELECT TO_CHAR(CREATEDATE, 'YYYY-MM-DD') FROM DATE_AND_TIMESTAMP_TEST;

/* coalesce()�Լ� Ȱ��� */
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

/* concat()�Լ� Ȱ��� */
DROP TABLE IF EXISTS mst_user_location;
CREATE TABLE mst_user_location 
(
    user_id   varchar2(255)
  , pref_name varchar2(255)
  , city_name varchar2(255)
);

INSERT INTO mst_user_location VALUES ('U001', '����Ư����', '������');
INSERT INTO mst_user_location VALUES ('U002', '��⵵������', '��ȱ�'  );
INSERT INTO mst_user_location VALUES ('U003', '����Ư����ġ��', '��������');
commit;

select PREF_NAME || ' ' || CITY_NAME AS PREF_CITY from mst_user_location;

/* ���� ���� �� ���ϴ� ���(COALESCE �Լ� ����) */
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

/* 0���� ������ ��Ȳ�� ���ϴ� ���(case ������ �ذ�) */
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

-- ��¥/�ð� ����ϱ�(INTERVALŰ���� ����Ͽ� �ð��� ���ϱ�/���� �ǽ�)
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

-- ���ڿ��� DATE type���� �����ϴ� ���1
SELECT TO_DATE(STAMP, 'YYYY-MM-DD HH24:MI:SS') FROM ACCESS_LOG;
-- ���ڿ��� DATE type���� �����ϴ� ���2(�ش� ���ڿ��� TIMESTAMP type���� ���� ������Ų ��, �ش� TIMESTAMP type�� DATE type���� ������Ų��.)
SELECT CAST(TO_TIMESTAMP(REGISTER_STAMP) AS DATE) FROM MST_USERS_WITH_DATES;

SELECT * FROM ACCESS_LOG;

WITH VIEWDATA AS(SELECT CASE WHEN SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '?', 1, 1) - INSTR(URL, '/', 1, 3)) IS NULL THEN ' ' ELSE SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '?', 1, 1) - INSTR(URL, '/', 1, 3))END AS RESULT1, CASE WHEN SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '#', 1, 1) - INSTR(URL, '/', 1, 3)) IS NULL THEN ' ' ELSE SUBSTR(URL, INSTR(URL, '/', 1, 3), INSTR(URL, '#', 1, 1) - INSTR(URL, '/', 1, 3)) END AS RESULT2 FROM ACCESS_LOG) SELECT RESULT1||RESULT2 AS FINAL FROM VIEWDATA;

/* �⺻���� WINDOW�Լ� ���� */
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

/* PARTITION BY������ ORDER BY������ ���ÿ� ����ϴ� WINDOW�Լ� Ȱ��� */
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

/* ���ڵ带 ���� ��ȯ�ϱ�1 */

-- ù��° �ǽ�
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

WITH dt_indicator_grouping AS (
    SELECT
        dt,
        indicator,
        CASE
            WHEN indicator = 'impressions' THEN
                MAX(val)
            ELSE
                0
        END  AS impressions,
        CASE
            WHEN indicator = 'sessions' THEN
                MAX(val)
            ELSE
                0
        END  AS sessions,
        CASE
            WHEN indicator = 'users' THEN
                MAX(val)
            ELSE
                0
        END  AS users
    FROM
        daily_kpi
    GROUP BY
        dt,
        indicator
)
SELECT
    DT, SUM(IMPRESSIONS) AS IMPRESSIONS, SUM(SESSIONS) AS SESSIONS, SUM(USERS) AS USERS
FROM
    dt_indicator_grouping
GROUP BY
    DT
ORDER BY
    DT;

-- �ι�° �ǽ�
WITH tdata AS (
    SELECT
        3      AS �Ǹŷ�,
        '�̱�'   ����,
        '�ڵ���'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        15     AS �Ǹŷ�,
        '�ѱ�'   ����,
        '�����'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        8      AS �Ǹŷ�,
        '�븸'   ����,
        '�ڵ���'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        5      AS �Ǹŷ�,
        '�ѱ�'   ����,
        '�ڵ���'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        42     AS �Ǹŷ�,
        '�ѱ�'   ����,
        '�ڵ���'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        24     AS �Ǹŷ�,
        '�̱�'   ����,
        '�����'  AS �Ǹ���ǰ
    FROM
        dual
    UNION ALL
    SELECT
        24     AS �Ǹŷ�,
        '�̱�'   ����,
        'ī�޶�'  AS �Ǹ���ǰ
    FROM
        dual
), first_change AS (
    SELECT
        ����,
        CASE
            WHEN �Ǹ���ǰ = '�ڵ���' THEN
                SUM(�Ǹŷ�)
            ELSE
                0
        END  �ڵ���,
        CASE
            WHEN �Ǹ���ǰ = '�����' THEN
                SUM(�Ǹŷ�)
            ELSE
                0
        END  �����,
        CASE
            WHEN �Ǹ���ǰ = '�ڵ���' THEN
                SUM(�Ǹŷ�)
            ELSE
                0
        END  �ڵ���,
        CASE
            WHEN �Ǹ���ǰ = 'ī�޶�' THEN
                SUM(�Ǹŷ�)
            ELSE
                0
        END  ī�޶�
    FROM
        tdata
    GROUP BY
        ����,
        �Ǹ���ǰ
    ORDER BY
        ����
)
SELECT
    ����,
    SUM(�ڵ���)     AS �ڵ���,
    SUM(�����)     AS �����,
    SUM(�ڵ���)     AS �ڵ���,
    SUM(ī�޶�)     AS ī�޶�
FROM
    first_change
GROUP BY
    ����;

/* ���ڵ带 ���� ��ȯ�ϱ�2(Ư�� ���ڵ���� ��ǥ�� ������ ���ڿ��� �����ϱ�[LISTAGG()�Լ� ����]) */
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

SELECT
    *
FROM
    purchase_detail_log;

SELECT
    purchase_id,
    LISTAGG(product_id, ', ') WITHIN GROUP(
            ORDER BY
                product_id
        ) AS PRODUCT_IDS,
    SUM(PRICE) AS AMOUNT
FROM
    purchase_detail_log
GROUP BY
    purchase_id;

/* ���� ǥ���� ���� ������ ��ȯ�ϱ� */
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

/* JOIN�� ����Ͽ� �� ���̺��� ���η� �����ϱ� */
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

-- ���� ���� ���̺��� �����ؼ� ���η� �����ϴ� ����1
WITH cat_mst_sales_join AS (
    SELECT
        m.category_id    AS cat1,
        m.name           AS name,
        s.category_id    AS cat2,
        s.sales          AS sales
    FROM
        mst_categories  m,
        category_sales  s
    WHERE
        m.category_id = s.category_id
)
SELECT
    r.category_id,
    j.name,
    j.sales,
    r.product_id AS sale_product
FROM
    cat_mst_sales_join    j,
    product_sale_ranking  r
WHERE
    j.cat1 = r.category_id;

-- ���� ���� ���̺��� �����ؼ� ���η� �����ϴ� ����2    
SELECT
    m.category_id, m.name, r.product_id, s.sales 
FROM
         mst_categories m,
         category_sales s,
         product_sale_ranking r
WHERE
    m.category_id = s.category_id and s.category_id = r.category_id;

-- ������ ���̺��� �� ���� �������� �ʰ� �������� ���̺��� ���η� �����ϴ� ����
WITH cat_mst_sale_left_join AS (
    SELECT
        m.category_id    AS category_id,
        m.name           AS name,
        s.sales
    FROM
        mst_categories  m
        LEFT JOIN category_sales  s ON m.category_id = s.category_id
)
SELECT
    j.category_id, J.NAME, J.SALES, R.PRODUCT_ID AS TOP_SALE_PRODUCT
FROM
    cat_mst_sale_left_join  j
    LEFT JOIN product_sale_ranking    r ON j.category_id = r.category_id
WHERE R.RANK = 1 OR R.RANK IS NULL;

SELECT
    m.category_id,
    m.name,
    r.product_id,
    s.sales
FROM
    (
        mst_categories        m
        LEFT JOIN product_sale_ranking  r ON m.category_id = r.category_id
    )
    LEFT JOIN category_sales        s ON m.category_id = s.category_id
WHERE
    r.rank = 1
    OR r.rank IS NULL;
    
/* ���� �÷��׸� 0�� 1�� ǥ���ϱ� */
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

/* WITH���� Ȱ���ϴ� �� */
DROP TABLE IF exists
product_sales;

CREATE TABLE product_sales (
    category_name  VARCHAR(255),
    product_id     VARCHAR(255),
    sales          INTEGER
);

INSERT INTO product_sales VALUES (
    'dvd',
    'D001',
    50000
);

INSERT INTO product_sales VALUES (
    'dvd',
    'D002',
    20000
);

INSERT INTO product_sales VALUES (
    'dvd',
    'D003',
    10000
);

INSERT INTO product_sales VALUES (
    'cd',
    'C001',
    30000
);

INSERT INTO product_sales VALUES (
    'cd',
    'C002',
    20000
);

INSERT INTO product_sales VALUES (
    'cd',
    'C003',
    10000
);

INSERT INTO product_sales VALUES (
    'book',
    'B001',
    20000
);

INSERT INTO product_sales VALUES (
    'book',
    'B002',
    15000
);

INSERT INTO product_sales VALUES (
    'book',
    'B003',
    10000
);

INSERT INTO product_sales VALUES (
    'book',
    'B004',
    5000
);

INSERT INTO product_sales VALUES (
    'BOOK',
    'B004',
    5000
);

COMMIT;

SELECT
    *
FROM
    product_sales;

-- ī�װ��� ������ �߰��� ���̺� ��ȸ
SELECT
    category_name,
    product_id,
    sales,
    ROW_NUMBER()
    OVER(PARTITION BY category_name
         ORDER BY sales
    ) AS rank
FROM
    product_sales;

-- ī�װ����� �������� ����ũ�� ���� ����� ��ȸ
WITH ranked_product_sales AS (
    SELECT
        category_name,
        sales,
        ROW_NUMBER()
        OVER(PARTITION BY category_name
             ORDER BY sales
        ) AS rank
    FROM
        product_sales
), mst_rank AS (
    SELECT DISTINCT
        rank
    FROM
        ranked_product_sales
)
SELECT
    *
FROM
    mst_rank;

-- 
WITH ranked_product_sales AS (
    SELECT
        category_name,
        product_id,
        sales,
        ROW_NUMBER()
        OVER(PARTITION BY category_name
             ORDER BY sales
        ) AS rank
    FROM
        product_sales
), mst_rank AS (
    SELECT DISTINCT
        rank
    FROM
        ranked_product_sales
)
SELECT
    *
FROM
    (
        (
            mst_rank              m
            LEFT JOIN ranked_product_sales  r1 ON m.rank = r1.rank
                                                 AND r1.category_name = 'dvd'
        )
        LEFT JOIN ranked_product_sales  r2 ON m.rank = r2.rank
                                             AND r2.category_name = 'cd'
    )
    LEFT JOIN ranked_product_sales  r3 ON m.rank = r3.rank
                                         AND r3.category_name = 'book';



