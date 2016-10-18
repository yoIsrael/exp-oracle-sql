SET ECHO OFF TERMOUT OFF LINES 32767 PAGES 0 TRIMSPOOL ON VERIFY OFF LONG 1000000 LONGC 1000000
SPOOL c:\temp\monitor.html REPLACE

SELECT DBMS_SQLTUNE.report_sql_monitor (sql_id   => '&sql_id'
                                       ,TYPE     => 'ACTIVE')
  FROM DUAL;

SPOOL OFF
SET TERMOUT ON PAGES 900 LINES 200