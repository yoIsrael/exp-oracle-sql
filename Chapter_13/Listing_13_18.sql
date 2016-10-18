SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH vw_gbc
           AS (  SELECT /*+ no_place_group_by */
                        s.cust_id
                       ,p.prod_category
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s JOIN sh.products p USING (prod_id)
               GROUP BY s.cust_id, p.prod_category, prod_id)
        SELECT /*+ no_place_group_by leading(vw_gbc) use_hash(c) no_swap_join_inputs(c) */
               cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category
              ,SUM (vw_gbc.total_amt_sold) total_amt_sold
          FROM vw_gbc JOIN sh.customers c USING (cust_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_gbc
           AS (  SELECT /*+   place_group_by((s)) */
                       s.cust_id
                       ,p.prod_category
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s JOIN sh.products p USING (prod_id)
               GROUP BY s.cust_id, p.prod_category, prod_id)
        SELECT /*+ place_group_by((vw_gbc)) */
              cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category
              ,SUM (vw_gbc.total_amt_sold) total_amt_sold
          FROM vw_gbc JOIN sh.customers c USING (cust_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_gbc_1
           AS (  SELECT s.cust_id
                       ,s.prod_id
                       ,SUM (s.amount_sold) AS total_amt_sold
                   FROM sh.sales s
               GROUP BY s.cust_id, s.prod_id)
          ,vw_gbc_2
           AS (  SELECT vw_gbc_1.cust_id
                       ,vw_gbc_1.total_amt_sold
                       ,p.prod_category
                   FROM vw_gbc_1 JOIN sh.products p USING (prod_id)
               GROUP BY vw_gbc_1.cust_id
                       ,vw_gbc_1.total_amt_sold
                       ,p.prod_category
                       ,prod_id)
          ,vw_gbc
           AS (  SELECT vw_gbc_2.cust_id
                       ,SUM (vw_gbc_2.total_amt_sold) AS total_amt_sold
                       ,vw_gbc_2.prod_category
                   FROM vw_gbc_2
               GROUP BY vw_gbc_2.cust_id, vw_gbc_2.prod_category)
        SELECT cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category
              ,SUM (vw_gbc.total_amt_sold) total_amt_sold
          FROM vw_gbc JOIN sh.customers c USING (cust_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);