SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      INSERT ALL
        INTO t1 (c1)
         WITH q1 AS (SELECT /*+  qb_name(qb1) */
                           c1 FROM t1)
             ,q2 AS (SELECT /*+  no_merge */
                           c2 FROM t2)
         SELECT /*+ qb_name(qb2) */
                COUNT (c1)
           FROM q1, q2 myalias
          WHERE c1 = c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));