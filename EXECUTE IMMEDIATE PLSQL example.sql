DECLARE
    table_nm VARCHAR2 (150) := 'PL_SQL_TEST';
    sql_qry  VARCHAR2 (150);
BEGIN

    sql_qry:= 'DROP TABLE ' ||table_nm;
    EXECUTE IMMEDIATE sql_qry;
    DBMS_OUTPUT.PUT_LINE (table_nm||' is dropped.');

END;
/