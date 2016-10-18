SET LINES 200 PAGES 0 SERVEROUTPUT OFF

CREATE TABLE t1
AS
       SELECT ROWNUM c1
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE TABLE t2
AS
       SELECT ROWNUM c1
         FROM DUAL
   CONNECT BY LEVEL <= 100;

SELECT *
  FROM t1 JOIN t2 USING (c1)
 WHERE c1 = 200;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));