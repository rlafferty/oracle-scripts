/* Formatted on 3/8/2013 10:26:28 AM (QP5 v5.215.12089.38647) */
select OWNER, SUM(MB) from (
SELECT owner,
       segment_name,
       segment_type,
       bytes / 1024 / 1024 "MB"
  FROM dba_segments
 WHERE                                  --tablespace_name = 'GET_FINREPT_DATA'
       (SEGMENT_NAME LIKE '%_BKP%'
           OR SUBSTR (SEGMENT_NAME, -1, 1) IN
                 ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
           OR SEGMENT_NAME LIKE '%_TEST'
           OR SEGMENT_NAME LIKE '%_RESTORE'
           OR SEGMENT_NAME LIKE '%_NEW')
       AND SEGMENT_TYPE = 'TABLE'
       AND OWNER = 'GET_FINREPT'
       order by MB desc)
       group by OWNER;