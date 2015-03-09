/* Formatted on 3/8/2013 10:37:45 AM (QP5 v5.215.12089.38647) */
SELECT    'alter index '
       || OWNER
       || '.'
       || SEGMENT_NAME
       || ' rebuild tablespace EXA_IDX;'
  FROM (  SELECT owner,
                 segment_name,
                 segment_type,
                 bytes / 1024 / 1024 "MB",
                 TABLESPACE_NAME
            FROM dba_segments
           WHERE     tablespace_name = 'EXA_DATA'
                 AND SEGMENT_TYPE NOT LIKE 'TABLE%'
                 AND OWNER = 'GETS_DW_SVC'
                 AND (    SEGMENT_NAME NOT LIKE 'SYS%'
                      AND SEGMENT_NAME NOT LIKE '%SNAP%')
        ORDER BY bytes DESC);


SELECT OWNER,
       INDEX_NAME,
       INDEX_TYPE,
       TABLE_OWNER,
       TABLE_NAME,
       TABLESPACE_NAME
  FROM dba_indexes
 WHERE     INDEX_NAME IN
              (SELECT OBJECT_NAME
                 FROM dba_objects
                WHERE     CREATED >= TO_DATE ('02/25/2013', 'MM/DD/YYYY')
                      AND OBJECT_TYPE LIKE '%INDEX%'
                      AND OWNER = 'GET_FINREPT')
       AND TABLESPACE_NAME = 'EXA_DATA';